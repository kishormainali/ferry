import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "data_emitter_context.dart";
import "data_emitter_types.dart";
import "naming.dart";
import "selection_resolver.dart";
import "type_utils.dart";

List<FieldSpec> buildFieldSpecs({
  required DataEmitterContext ctx,
  required String baseName,
  required ResolvedSelectionSet selectionSet,
  required String parentTypeName,
  required FieldContext fieldContext,
}) {
  final fields = <FieldSpec>[];
  for (final selection in selectionSet.fields.values) {
    final fieldName = selection.responseKey;
    final propertyName = identifier(fieldName);
    final nestedBaseName = "${baseName}_$fieldName";
    final namedTypeName = unwrapNamedTypeName(selection.typeNode) ?? "Object";
    final typeDef = ctx.schema.lookupType(NameNode(value: namedTypeName));

    String? fragmentName = ctx.config.dataClassConfig.reuseFragments
        ? selection.fragmentSpreadOnlyName
        : null;
    Reference? namedTypeRef;

    if (fragmentName != null) {
      namedTypeRef =
          fragmentDataReference(ctx: ctx, fragmentName: fragmentName);
    } else if (typeDef is ObjectTypeDefinitionNode ||
        typeDef is InterfaceTypeDefinitionNode ||
        typeDef is UnionTypeDefinitionNode) {
      namedTypeRef = Reference(
        builtClassName(nestedBaseName),
        "#data",
      );
    } else if (typeDef is EnumTypeDefinitionNode ||
        typeDef is InputObjectTypeDefinitionNode) {
      namedTypeRef = Reference(
        builtClassName(namedTypeName),
        "#schema",
      );
    } else if (typeDef is ScalarTypeDefinitionNode) {
      namedTypeRef = scalarReference(ctx: ctx, typeName: namedTypeName);
    } else {
      namedTypeRef = refer("Object");
    }

    final typeRef = typeReferenceForTypeNode(
      selection.typeNode,
      namedTypeRef,
    );

    fields.add(
      FieldSpec(
        responseKey: fieldName,
        propertyName: propertyName,
        typeNode: selection.typeNode,
        typeRef: typeRef,
        namedTypeRef: namedTypeRef,
        selectionSet: selection.selectionSet,
        fragmentSpreadOnlyName: fragmentName,
      ),
    );
  }
  return fields;
}

Reference fragmentDataReference({
  required DataEmitterContext ctx,
  required String fragmentName,
}) {
  final url = ctx.fragmentSourceUrls[fragmentName];
  if (url == null) {
    return Reference(builtClassName("${fragmentName}Data"), "#data");
  }
  return Reference(builtClassName("${fragmentName}Data"), "$url#data");
}

Reference fragmentInterfaceReference({
  required DataEmitterContext ctx,
  required String fragmentName,
}) {
  final url = ctx.fragmentSourceUrls[fragmentName];
  if (url == null) {
    return Reference(builtClassName(fragmentName), "#data");
  }
  return Reference(builtClassName(fragmentName), "$url#data");
}

Reference scalarReference({
  required DataEmitterContext ctx,
  required String typeName,
}) {
  final override = ctx.config.typeOverrides[typeName];
  if (override?.type != null) {
    if (override!.import != null) {
      ctx.extraImports.add(override.import!);
    }
    return Reference(override.type);
  }

  return switch (typeName) {
    "Int" => refer("int"),
    "Float" => refer("double"),
    "Boolean" => refer("bool"),
    "ID" => refer("String"),
    "String" => refer("String"),
    _ => refer("Object"),
  };
}

bool isMapOverride({
  required DataEmitterContext ctx,
  required String typeName,
}) {
  final override = ctx.config.typeOverrides[typeName];
  final overrideType = override?.type;
  if (overrideType == null) return false;
  final normalized = overrideType.replaceAll(" ", "");
  return RegExp(r'(^|\\.)Map(<|\\?|$)').hasMatch(normalized);
}

Reference typeReferenceForTypeNode(
  TypeNode typeNode,
  Reference namedTypeRef,
) {
  if (typeNode is ListTypeNode) {
    return TypeReference(
      (b) => b
        ..symbol = "List"
        ..isNullable = !typeNode.isNonNull
        ..types.add(typeReferenceForTypeNode(typeNode.type, namedTypeRef)),
    );
  }
  if (typeNode is NamedTypeNode) {
    if (namedTypeRef is TypeReference) {
      return namedTypeRef.rebuild((b) => b..isNullable = !typeNode.isNonNull);
    }
    return TypeReference(
      (b) => b
        ..symbol = namedTypeRef.symbol
        ..url = namedTypeRef.url
        ..isNullable = !typeNode.isNonNull,
    );
  }
  throw StateError("Invalid type node");
}

bool canUseListFrom({
  required DataEmitterContext ctx,
  required String typeName,
  required TypeDefinitionNode? typeDef,
  required TypeOverrideConfig? override,
}) {
  if (typeDef is! ScalarTypeDefinitionNode) return false;
  if (override?.fromJsonFunctionName != null) return false;
  if (_isBuiltinScalarName(typeName)) return true;
  final overrideType = override?.type;
  if (overrideType == null) return false;
  final normalized = overrideType.replaceAll(" ", "");
  if (normalized == "Object" ||
      normalized == "Object?" ||
      normalized == "dynamic") {
    return false;
  }
  return true;
}

bool _isBuiltinScalarName(String typeName) => switch (typeName) {
      "Int" => true,
      "Float" => true,
      "Boolean" => true,
      "ID" => true,
      "String" => true,
      _ => false,
    };

Reference typeReferenceWithNullability(
  Reference typeRef, {
  required bool isNullable,
}) {
  if (typeRef is TypeReference) {
    return typeRef.rebuild((b) => b..isNullable = isNullable);
  }
  return TypeReference(
    (b) => b
      ..symbol = typeRef.symbol
      ..url = typeRef.url
      ..isNullable = isNullable,
  );
}

bool isNullableField(FieldSpec field) {
  final typeRef = field.typeRef;
  if (typeRef is TypeReference) {
    return typeRef.isNullable ?? false;
  }
  return false;
}

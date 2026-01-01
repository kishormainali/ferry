import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "data_emitter_context.dart";
import "data_emitter_fields.dart";
import "data_emitter_json.dart";
import "data_emitter_types.dart";
import "naming.dart";
import "selection_resolver.dart";

({List<Spec> specs, DataEmitterContext ctx}) buildOperationData({
  required DataEmitterContext ctx,
  required OperationDefinitionNode operation,
}) {
  if (operation.name == null) {
    return (specs: const <Spec>[], ctx: ctx);
  }
  final resolved = ctx.resolver.resolveOperation(operation);
  final baseName = "${operation.name!.value}Data";
  return (
    specs: buildSelectionSetClasses(
      ctx: ctx,
      baseName: baseName,
      selectionSet: resolved,
      parentTypeName: resolved.parentTypeName,
      fragmentSpreads: resolved.fragmentSpreads,
      classImplements: const [],
      fragmentName: null,
    ),
    ctx: ctx,
  );
}

List<Spec> buildSelectionSetClasses({
  required DataEmitterContext ctx,
  required String baseName,
  required ResolvedSelectionSet selectionSet,
  required String parentTypeName,
  required Set<String> fragmentSpreads,
  required List<Reference> classImplements,
  required String? fragmentName,
}) {
  final className = builtClassName(baseName);
  if (!ctx.generatedClasses.add(className)) {
    return [];
  }

  final specs = <Spec>[];

  if (selectionSet.inlineFragments.isEmpty) {
    final fieldsList = buildFieldSpecs(
      ctx: ctx,
      baseName: baseName,
      selectionSet: selectionSet,
      parentTypeName: parentTypeName,
      fieldContext: FieldContext.base,
    );
    final implementsRefs = _interfaceRefs(
      ctx: ctx,
      fragmentSpreads: fragmentSpreads,
      parentTypeName: parentTypeName,
      baseImplements: classImplements,
    );
    specs.add(
      _buildConcreteClass(
        ctx: ctx,
        className: className,
        fields: fieldsList,
        implementsRefs: implementsRefs,
        extendsRef: null,
        superFields: const [],
        usesSuperToJson: false,
      ),
    );
    specs
        .addAll(_buildNestedClasses(ctx, baseName, fieldsList, implementsRefs));
    return specs;
  }

  final baseFields = buildFieldSpecs(
    ctx: ctx,
    baseName: baseName,
    selectionSet: selectionSet,
    parentTypeName: parentTypeName,
    fieldContext: FieldContext.base,
  );

  final baseImplements = _interfaceRefs(
    ctx: ctx,
    fragmentSpreads: fragmentSpreads,
    parentTypeName: parentTypeName,
    baseImplements: classImplements,
  );
  specs.add(
    _buildPolymorphicBaseClass(
      ctx: ctx,
      className: className,
      baseFields: baseFields,
      inlineTypeNames: selectionSet.inlineFragments.keys.toList(),
      implementsRefs: baseImplements,
    ),
  );
  final whenExtension = _buildWhenExtension(
    ctx: ctx,
    baseName: baseName,
    inlineTypeNames: selectionSet.inlineFragments.keys.toList(),
  );
  if (whenExtension != null) {
    specs.add(whenExtension);
  }
  specs.addAll(_buildNestedClasses(ctx, baseName, baseFields, baseImplements));

  for (final entry in selectionSet.inlineFragments.entries) {
    final typeName = entry.key;
    final inlineBaseName = "${baseName}__as$typeName";
    final inlineFields = buildFieldSpecs(
      ctx: ctx,
      baseName: inlineBaseName,
      selectionSet: entry.value,
      parentTypeName: typeName,
      fieldContext: FieldContext.inline,
    );
    final baseKeys = baseFields.map((field) => field.responseKey).toSet();
    final List<FieldSpec> mergedFields = [
      ...baseFields,
      ...inlineFields.where(
        (field) => !baseKeys.contains(field.responseKey),
      ),
    ];
    final inlineImplements = _interfaceRefs(
      ctx: ctx,
      fragmentSpreads: entry.value.fragmentSpreads,
      parentTypeName: typeName,
      baseImplements: classImplements,
    );
    final fragmentInfo =
        fragmentName == null ? null : ctx.fragmentInfo[fragmentName];
    if (fragmentInfo != null && fragmentInfo.inlineTypes.contains(typeName)) {
      inlineImplements.add(
        refer(builtClassName("${fragmentName}__as$typeName")),
      );
    }
    specs.add(
      _buildConcreteClass(
        ctx: ctx,
        className: builtClassName(inlineBaseName),
        fields: mergedFields,
        implementsRefs: inlineImplements,
        extendsRef: refer(className),
        superFields: baseFields,
        usesSuperToJson: true,
      ),
    );
    specs.addAll(
      _buildNestedClasses(
        ctx,
        inlineBaseName,
        inlineFields
            .where((field) => !baseKeys.contains(field.responseKey))
            .toList(),
        inlineImplements,
      ),
    );
  }

  specs.add(
    _buildConcreteClass(
      ctx: ctx,
      className: builtClassName("${baseName}__unknown"),
      fields: baseFields,
      implementsRefs: _interfaceRefs(
        ctx: ctx,
        fragmentSpreads: fragmentSpreads,
        parentTypeName: parentTypeName,
        baseImplements: classImplements,
      ),
      extendsRef: refer(className),
      superFields: baseFields,
      usesSuperToJson: true,
    ),
  );

  return specs;
}

Extension? _buildWhenExtension({
  required DataEmitterContext ctx,
  required String baseName,
  required List<String> inlineTypeNames,
}) {
  if (inlineTypeNames.isEmpty) return null;
  if (!ctx.config.whenExtensionConfig.generateWhenExtensionMethod &&
      !ctx.config.whenExtensionConfig.generateMaybeWhenExtensionMethod) {
    return null;
  }

  final className = builtClassName(baseName);
  final usedNames = <String>{"orElse", "_T"};
  final paramNames = <String, String>{};

  String uniqueParamName(String typeName) {
    var name = identifier(_uncapitalize(typeName));
    while (usedNames.contains(name)) {
      name = identifier("g$name");
    }
    usedNames.add(name);
    return name;
  }

  for (final typeName in inlineTypeNames) {
    paramNames[typeName] = uniqueParamName(typeName);
  }

  final methods = <Method>[];
  if (ctx.config.whenExtensionConfig.generateWhenExtensionMethod) {
    methods.add(
      Method(
        (b) => b
          ..name = "when"
          ..returns = refer("_T")
          ..types.add(refer("_T"))
          ..optionalParameters.addAll([
            for (final typeName in inlineTypeNames)
              Parameter(
                (b) => b
                  ..name = paramNames[typeName]!
                  ..type = FunctionType(
                    (b) => b
                      ..returnType = refer("_T")
                      ..requiredParameters.add(
                        refer(
                          builtClassName("${baseName}__as$typeName"),
                        ),
                      ),
                  )
                  ..named = true
                  ..required = true,
              ),
            Parameter(
              (b) => b
                ..name = "orElse"
                ..type = FunctionType((b) => b..returnType = refer("_T"))
                ..named = true
                ..required = true,
            ),
          ])
          ..body = Block.of([
            const Code("switch(G__typename) {"),
            for (final typeName in inlineTypeNames)
              Code(
                "case '$typeName': return ${paramNames[typeName]}(this as ${builtClassName("${baseName}__as$typeName")});",
              ),
            const Code("default: return orElse();"),
            const Code("}"),
          ]),
      ),
    );
  }

  if (ctx.config.whenExtensionConfig.generateMaybeWhenExtensionMethod) {
    methods.add(
      Method(
        (b) => b
          ..name = "maybeWhen"
          ..returns = refer("_T")
          ..types.add(refer("_T"))
          ..optionalParameters.addAll([
            for (final typeName in inlineTypeNames)
              Parameter(
                (b) => b
                  ..name = paramNames[typeName]!
                  ..type = FunctionType(
                    (b) => b
                      ..returnType = refer("_T")
                      ..isNullable = true
                      ..requiredParameters.add(
                        refer(
                          builtClassName("${baseName}__as$typeName"),
                        ),
                      ),
                  )
                  ..named = true
                  ..required = false,
              ),
            Parameter(
              (b) => b
                ..name = "orElse"
                ..type = FunctionType((b) => b..returnType = refer("_T"))
                ..named = true
                ..required = true,
            ),
          ])
          ..body = Block.of([
            const Code("switch(G__typename) {"),
            for (final typeName in inlineTypeNames)
              Code(
                "case '$typeName': return ${paramNames[typeName]} == null ? orElse() : ${paramNames[typeName]}(this as ${builtClassName("${baseName}__as$typeName")});",
              ),
            const Code("default: return orElse();"),
            const Code("}"),
          ]),
      ),
    );
  }

  return Extension(
    (b) => b
      ..name = "${className}WhenExtension"
      ..on = refer(className)
      ..methods.addAll(methods),
  );
}

String _uncapitalize(String value) {
  if (value.isEmpty) return value;
  return "${value[0].toLowerCase()}${value.substring(1)}";
}

List<Spec> _buildNestedClasses(
  DataEmitterContext ctx,
  String baseName,
  List<FieldSpec> fieldsList,
  List<Reference> parentInterfaces,
) {
  final specs = <Spec>[];
  for (final field in fieldsList) {
    if (field.selectionSet == null || field.fragmentSpreadOnlyName != null) {
      continue;
    }
    final nestedName = "${baseName}_${field.responseKey}";
    final nestedInterfaces = _nestedInterfaceRefsForField(
      ctx,
      parentInterfaces,
      field,
    );
    specs.addAll(
      buildSelectionSetClasses(
        ctx: ctx,
        baseName: nestedName,
        selectionSet: field.selectionSet!,
        parentTypeName: field.selectionSet!.parentTypeName,
        fragmentSpreads: field.selectionSet!.fragmentSpreads,
        classImplements: nestedInterfaces,
        fragmentName: null,
      ),
    );
  }
  return specs;
}

List<Reference> _nestedInterfaceRefsForField(
  DataEmitterContext ctx,
  List<Reference> parentInterfaces,
  FieldSpec field,
) {
  if (field.selectionSet == null) return const [];
  final refs = <Reference>[];
  for (final interfaceRef in parentInterfaces) {
    final symbol = interfaceRef.symbol;
    if (symbol == null || !symbol.startsWith("G")) continue;
    final interfaceKey = symbol.substring(1);
    final selectionSet = ctx.fragmentInterfaceSelections[interfaceKey];
    if (selectionSet == null) continue;
    final nestedField = selectionSet.fields[field.responseKey];
    if (nestedField?.selectionSet == null) continue;
    if (ctx.config.dataClassConfig.reuseFragments &&
        nestedField!.fragmentSpreadOnlyName != null) {
      continue;
    }
    final nestedKey = "${interfaceKey}_${field.responseKey}";
    final fragmentName = ctx.interfaceKeyToFragmentName[nestedKey] ??
        ctx.interfaceKeyToFragmentName[interfaceKey];
    if (fragmentName == null) continue;
    final url = ctx.fragmentSourceUrls[fragmentName];
    refs.add(
      Reference(
        builtClassName(nestedKey),
        url == null ? "#data" : "$url#data",
      ),
    );
  }
  return refs;
}

List<Reference> _interfaceRefs({
  required DataEmitterContext ctx,
  required Set<String> fragmentSpreads,
  required String parentTypeName,
  required List<Reference> baseImplements,
}) {
  final refs = <Reference>[...baseImplements];
  for (final fragmentName in fragmentSpreads) {
    final interfaceName = _fragmentInterfaceForType(
        ctx: ctx, fragmentName: fragmentName, typeName: parentTypeName);
    final fragmentUrl = ctx.fragmentSourceUrls[fragmentName];
    if (fragmentUrl == null) continue;
    refs.add(
      Reference(
        interfaceName,
        "$fragmentUrl#data",
      ),
    );
  }
  return refs;
}

String _fragmentInterfaceForType({
  required DataEmitterContext ctx,
  required String fragmentName,
  required String typeName,
}) {
  final info = ctx.fragmentInfo[fragmentName];
  if (info == null) return builtClassName(fragmentName);
  if (info.inlineTypes.contains(typeName)) {
    return builtClassName("${fragmentName}__as$typeName");
  }
  return builtClassName(fragmentName);
}

Class _buildPolymorphicBaseClass({
  required DataEmitterContext ctx,
  required String className,
  required List<FieldSpec> baseFields,
  required List<String> inlineTypeNames,
  required List<Reference> implementsRefs,
}) {
  return Class(
    (b) => b
      ..name = className
      ..abstract = true
      ..sealed = true
      ..implements.addAll(implementsRefs)
      ..fields.addAll(baseFields.map(_buildField))
      ..constructors.addAll([
        _buildConstructor(baseFields, null),
        _buildFromJsonFactory(className, baseFields, inlineTypeNames),
      ])
      ..methods.add(
        _buildToJsonMethod(ctx, baseFields, usesSuper: false),
      ),
  );
}

Class _buildConcreteClass({
  required DataEmitterContext ctx,
  required String className,
  required List<FieldSpec> fields,
  required List<Reference> implementsRefs,
  required Reference? extendsRef,
  required List<FieldSpec> superFields,
  required bool usesSuperToJson,
}) {
  final methods = <Method>[
    _buildToJsonMethod(ctx, fields, usesSuper: usesSuperToJson),
  ];
  if (ctx.config.generateCopyWith) {
    methods.add(_buildCopyWithMethod(className, fields));
  }
  if (ctx.config.generateEquals) {
    methods.add(_buildEqualsMethod(ctx, className, fields));
  }
  if (ctx.config.generateHashCode) {
    methods.add(_buildHashCodeGetter(ctx, fields));
  }
  if (ctx.config.generateToString) {
    methods.add(_buildToStringMethod(className, fields));
  }

  return Class(
    (b) => b
      ..name = className
      ..implements.addAll(implementsRefs)
      ..extend = extendsRef
      ..fields.addAll(
        fields.where((field) => !superFields.contains(field)).map(_buildField),
      )
      ..constructors.addAll([
        _buildConstructor(fields, extendsRef, superFields: superFields),
        _buildConcreteFromJson(ctx, className, fields),
      ])
      ..methods.addAll(methods),
  );
}

Constructor _buildConstructor(
  List<FieldSpec> fieldsList,
  Reference? extendsRef, {
  List<FieldSpec> superFields = const [],
}) {
  final namedParameters = fieldsList.map((field) {
    final isRequired = field.typeRef is TypeReference
        ? !((field.typeRef as TypeReference).isNullable ?? false)
        : true;
    return Parameter(
      (b) => b
        ..name = field.propertyName
        ..named = true
        ..required = isRequired
        ..toThis = !superFields.contains(field),
    );
  });

  final initializers = <Code>[];
  if (extendsRef != null && superFields.isNotEmpty) {
    final args = superFields
        .map((field) => "${field.propertyName}: ${field.propertyName}")
        .join(", ");
    initializers.add(Code("super($args)"));
  }

  return Constructor(
    (b) => b
      ..constant = true
      ..optionalParameters.addAll(namedParameters)
      ..initializers.addAll(initializers),
  );
}

Constructor _buildFromJsonFactory(
  String className,
  List<FieldSpec> baseFields,
  List<String> inlineTypeNames,
) {
  final switchCases = inlineTypeNames
      .map(
        (typeName) => Code(
          "case '$typeName': return ${builtClassName("${stripPrefix(className)}__as$typeName")}.fromJson(json);",
        ),
      )
      .toList();
  final body = [
    Code("switch(json['__typename'] as String) {"),
    ...switchCases,
    Code(
      "default: return ${builtClassName("${stripPrefix(className)}__unknown")}.fromJson(json);",
    ),
    Code("}"),
  ];

  return Constructor(
    (b) => b
      ..name = "fromJson"
      ..factory = true
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = "json"
          ..type = refer("Map<String, dynamic>")),
      )
      ..body = Block.of(body),
  );
}

Constructor _buildConcreteFromJson(
  DataEmitterContext ctx,
  String className,
  List<FieldSpec> fieldsList,
) {
  final args = <String, Expression>{};
  for (final field in fieldsList) {
    args[field.propertyName] = fromJsonExpression(ctx: ctx, field: field);
  }
  final constructorCall = refer(className).call([], args);

  return Constructor(
    (b) => b
      ..name = "fromJson"
      ..factory = true
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = "json"
          ..type = mapStringDynamicType()),
      )
      ..body = Block.of([constructorCall.returned.statement]),
  );
}

Method _buildToJsonMethod(
  DataEmitterContext ctx,
  List<FieldSpec> fieldsList, {
  required bool usesSuper,
}) {
  final statements = <Code>[];
  if (usesSuper) {
    statements.add(const Code("final result = super.toJson();"));
  } else {
    statements.add(const Code("final result = <String, dynamic>{};"));
  }
  for (final field in fieldsList) {
    Expression valueRef = refer(field.propertyName);
    if (isNullableField(field)) {
      final localName = "${field.propertyName}Value";
      statements.add(Code("final $localName = ${field.propertyName};"));
      valueRef = refer(localName);
    }
    final target = refer("result").index(literalString(field.responseKey));
    final valueExpr = toJsonExpression(
      ctx: ctx,
      field: field,
      valueExpr: valueRef,
    );
    statements.add(target.assign(valueExpr).statement);
  }
  statements.add(refer("result").returned.statement);

  return Method(
    (b) => b
      ..name = "toJson"
      ..returns = mapStringDynamicType()
      ..body = Block.of(statements),
  );
}

Method _buildCopyWithMethod(String className, List<FieldSpec> fieldsList) {
  final parameters = <Parameter>[];
  final args = <String, Expression>{};

  for (final field in fieldsList) {
    final isNullable = isNullableField(field);
    final paramType =
        isNullable ? field.typeRef : _nullableTypeReference(field.typeRef);
    parameters.add(
      Parameter(
        (b) => b
          ..name = field.propertyName
          ..type = paramType
          ..named = true,
      ),
    );

    if (isNullable) {
      final isSetName = _copyWithIsSetName(field.propertyName);
      parameters.add(
        Parameter(
          (b) => b
            ..name = isSetName
            ..type = refer("bool")
            ..named = true
            ..defaultTo = const Code("false"),
        ),
      );
      args[field.propertyName] = conditionalExpression(
        refer(isSetName),
        refer(field.propertyName),
        refer("this").property(field.propertyName),
      );
    } else {
      args[field.propertyName] = refer(field.propertyName)
          .ifNullThen(refer("this").property(field.propertyName));
    }
  }

  final constructorCall = refer(className).call([], args);
  return Method(
    (b) => b
      ..name = "copyWith"
      ..returns = refer(className)
      ..optionalParameters.addAll(parameters)
      ..body = Block.of([constructorCall.returned.statement]),
  );
}

Method _buildEqualsMethod(
  DataEmitterContext ctx,
  String className,
  List<FieldSpec> fieldsList,
) {
  final comparisons = fieldsList
      .map(
        (field) => _equalsExpressionForTypeNode(
          ctx,
          field.typeNode,
          field.propertyName,
          "other.${field.propertyName}",
        ),
      )
      .join(" && ");
  final body = fieldsList.isEmpty
      ? "return identical(this, other) || other is $className;"
      : "return identical(this, other) || "
          "(other is $className && $comparisons);";

  return Method(
    (b) => b
      ..name = "operator =="
      ..annotations.add(refer("override"))
      ..returns = refer("bool")
      ..requiredParameters.add(
        Parameter(
          (b) => b
            ..name = "other"
            ..type = refer("Object"),
        ),
      )
      ..body = Code(body),
  );
}

Method _buildHashCodeGetter(
    DataEmitterContext ctx, List<FieldSpec> fieldsList) {
  final entries = [
    "runtimeType",
    ...fieldsList.map(
      (field) => _hashExpressionForTypeNode(
        ctx,
        field.typeNode,
        field.propertyName,
      ),
    ),
  ];
  final body = entries.length == 1
      ? const Code("return runtimeType.hashCode;")
      : entries.length <= 20
          ? Code("return Object.hash(${entries.join(", ")});")
          : Code("return Object.hashAll([${entries.join(", ")}]);");
  return Method(
    (b) => b
      ..annotations.add(refer("override"))
      ..name = "hashCode"
      ..type = MethodType.getter
      ..returns = refer("int")
      ..body = body,
  );
}

Method _buildToStringMethod(String className, List<FieldSpec> fieldsList) {
  final parts = fieldsList
      .map((field) => "${field.propertyName}: \$${field.propertyName}")
      .join(", ");
  final value = fieldsList.isEmpty ? "$className()" : "$className($parts)";
  return Method(
    (b) => b
      ..annotations.add(refer("override"))
      ..name = "toString"
      ..returns = refer("String")
      ..body = Code("return '$value';"),
  );
}

String _copyWithIsSetName(String propertyName) =>
    identifier("${propertyName}IsSet");

Reference _nullableTypeReference(Reference typeRef) {
  if (typeRef is TypeReference) {
    return typeRef.rebuild((b) => b..isNullable = true);
  }
  return TypeReference(
    (b) => b
      ..symbol = typeRef.symbol
      ..url = typeRef.url
      ..isNullable = true,
  );
}

Field _buildField(FieldSpec field) => Field(
      (b) => b
        ..name = field.propertyName
        ..type = field.typeRef
        ..modifier = FieldModifier.final$,
    );

bool _requiresDeepList(TypeNode node, DataEmitterContext ctx) {
  if (node is ListTypeNode) return true;
  if (node is NamedTypeNode) {
    return isMapOverride(ctx: ctx, typeName: node.name.value);
  }
  return false;
}

String _equalsExpressionForTypeNode(
  DataEmitterContext ctx,
  TypeNode node,
  String left,
  String right,
) {
  if (node is ListTypeNode) {
    ctx.needsUtilsImport = true;
    final helper =
        _requiresDeepList(node.type, ctx) ? "listEqualsDeep" : "listEquals";
    return "$utilsPrefix$helper($left, $right)";
  }
  if (node is NamedTypeNode) {
    final typeName = node.name.value;
    if (isMapOverride(ctx: ctx, typeName: typeName)) {
      ctx.needsUtilsImport = true;
      return "${utilsPrefix}deepEquals($left, $right)";
    }
    return "$left == $right";
  }
  throw StateError("Invalid type node");
}

String _hashExpressionForTypeNode(
  DataEmitterContext ctx,
  TypeNode node,
  String value,
) {
  if (node is ListTypeNode) {
    ctx.needsUtilsImport = true;
    final helper =
        _requiresDeepList(node.type, ctx) ? "listHashDeep" : "listHash";
    return "$utilsPrefix$helper($value)";
  }
  if (node is NamedTypeNode) {
    final typeName = node.name.value;
    if (isMapOverride(ctx: ctx, typeName: typeName)) {
      ctx.needsUtilsImport = true;
      return "${utilsPrefix}deepHash($value)";
    }
    return value;
  }
  throw StateError("Invalid type node");
}

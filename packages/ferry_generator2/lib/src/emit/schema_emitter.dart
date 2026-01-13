import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "../config/builder_config.dart";
import "../utils/naming.dart";
import "collection_helpers.dart";
import "../schema/schema.dart";
import "../schema/type_utils.dart";
import "../utils/docs.dart";

Library buildSchemaLibrary({
  required SchemaIndex schema,
  required BuilderConfig config,
}) {
  final emitter = _SchemaEmitter(schema, config);
  return emitter.buildLibrary();
}

List<Spec> _buildEnum(
  EnumTypeDefinitionNode node,
  SchemaIndex schema,
  EnumFallbackConfig config,
  bool generateDocs,
) {
  final enumName = builtClassName(node.name.value);
  final enumValues = schema.lookupEnumValueDefinitions(node);
  final fallbackName = _selectFallbackValueName(node, enumValues, config);

  final values = <_EnumMappedValue>[
    for (final value in enumValues)
      _EnumMappedValue(
        graphQLName: value.name.value,
        dartName: identifier(value.name.value),
        description: value.description?.value,
      ),
    if (fallbackName != null)
      _EnumMappedValue(
        graphQLName: fallbackName,
        dartName: identifier(fallbackName),
      ),
  ];

  return [
    Enum(
      (b) => b
        ..name = enumName
        ..docs
            .addAll(generateDocs ? docLines(node.description?.value) : const [])
        ..values.addAll(
          values.map(
            (value) => EnumValue(
              (b) => b
                ..name = value.dartName
                ..docs.addAll(
                  generateDocs ? docLines(value.description) : const <String>[],
                ),
            ),
          ),
        )
        ..methods.addAll([
          _buildEnumFromJson(enumName, values, fallbackName),
          _buildEnumToJson(enumName, values),
        ]),
    ),
  ];
}

Method _buildEnumFromJson(
  String enumName,
  List<_EnumMappedValue> values,
  String? fallbackName,
) {
  final cases = values.where((value) => value.graphQLName != fallbackName).map(
        (value) => Code(
            "case r'${value.graphQLName}': return $enumName.${value.dartName};"),
      );

  final fallbackCase = fallbackName == null
      ? Code(
          "default: throw ArgumentError.value(value, 'value', 'Unknown $enumName value');",
        )
      : Code("default: return $enumName.${identifier(fallbackName)};");

  return Method(
    (b) => b
      ..name = "fromJson"
      ..static = true
      ..returns = refer(enumName)
      ..requiredParameters.add(
        Parameter(
          (b) => b
            ..name = "value"
            ..type = refer("String"),
        ),
      )
      ..body = Block.of([
        Code("switch(value) {"),
        ...cases,
        fallbackCase,
        Code("}"),
      ]),
  );
}

Method _buildEnumToJson(
  String enumName,
  List<_EnumMappedValue> values,
) {
  final cases = values.map(
    (value) => Code(
      "case $enumName.${value.dartName}: return r'${value.graphQLName}';",
    ),
  );

  return Method(
    (b) => b
      ..name = "toJson"
      ..returns = refer("String")
      ..body = Block.of([
        Code("switch(this) {"),
        ...cases,
        Code("}"),
      ]),
  );
}

Spec _buildPossibleTypesMap(SchemaIndex schema) {
  final possibleTypes = schema.possibleTypesMap();
  return declareConst(
    "possibleTypesMap",
    type: Reference("Map<String, Set<String>>"),
  ).assign(literalMap(possibleTypes)).statement;
}

String? _selectFallbackValueName(
  EnumTypeDefinitionNode node,
  List<EnumValueDefinitionNode> values,
  EnumFallbackConfig config,
) {
  final localFallback = config.fallbackValueMap[node.name.value];
  final fallbackBase = localFallback ??
      (config.generateFallbackValuesGlobally
          ? config.globalEnumFallbackName
          : null);
  if (fallbackBase == null) return null;

  final existing = values.map((value) => value.name.value).toSet();
  var candidate = fallbackBase;
  while (existing.contains(candidate)) {
    candidate = "g$candidate";
  }
  return candidate;
}

class _EnumMappedValue {
  final String graphQLName;
  final String dartName;
  final String? description;

  const _EnumMappedValue({
    required this.graphQLName,
    required this.dartName,
    this.description,
  });
}

class _SchemaEmitter {
  final SchemaIndex schema;
  final BuilderConfig config;
  final Set<String> _extraImports = {};
  bool _usesTriStateValue = false;

  _SchemaEmitter(this.schema, this.config);

  List<String> _docs(String? description) =>
      config.generateDocs ? docLines(description) : const [];

  Library buildLibrary() {
    final specs = <Spec>[];

    for (final definition in schema.document.definitions) {
      if (definition is EnumTypeDefinitionNode &&
          !definition.name.value.startsWith("__")) {
        specs.addAll(_buildEnum(
          definition,
          schema,
          config.enumFallbackConfig,
          config.generateDocs,
        ));
      }
      if (definition is InputObjectTypeDefinitionNode &&
          !definition.name.value.startsWith("__")) {
        specs.add(_buildInputObject(definition));
      }
    }

    if (config.shouldGeneratePossibleTypes) {
      specs.add(_buildPossibleTypesMap(schema));
    }

    if (_usesTriStateValue) {
      _extraImports.add(
        "package:gql_tristate_value/gql_tristate_value.dart",
      );
    }

    return Library(
      (b) => b
        ..directives.addAll(
          _extraImports.map(Directive.import),
        )
        ..body.addAll(specs),
    );
  }

  Class _buildInputObject(InputObjectTypeDefinitionNode node) {
    final fields = schema
        .lookupInputValueDefinitions(node)
        .map(_fieldSpecFromDefinition)
        .toList();
    final className = builtClassName(node.name.value);
    return Class(
      (b) => b
        ..name = className
        ..docs.addAll(_docs(node.description?.value))
        ..fields.addAll(fields.map(_buildField))
        ..constructors.addAll([
          _buildConstructor(fields),
          _buildFromJsonFactory(className, fields),
        ])
        ..methods.add(
          _buildToJsonMethod(fields),
        ),
    );
  }

  Constructor _buildConstructor(List<_InputFieldSpec> fields) {
    final wrapFields = fields.where(_needsCollectionWrapper).toList();
    final wrapNames = wrapFields.map((field) => field.propertyName).toSet();

    final parameters = fields.map(
      (field) => Parameter(
        (b) => b
          ..name = field.propertyName
          ..named = true
          ..required = field.isRequired
          ..toThis = !wrapNames.contains(field.propertyName)
          ..defaultTo =
              field.isTriState ? const Code("const Value.absent()") : null,
      ),
    );

    final initializers = <Code>[];
    for (final field in wrapFields) {
      final propertyName = field.propertyName;
      final wrapper = _collectionWrapperExpression(field, propertyName);
      initializers.add(Code("$propertyName = $wrapper"));
    }

    return Constructor(
      (b) => b
        ..constant = wrapFields.isEmpty
        ..optionalParameters.addAll(parameters)
        ..initializers.addAll(initializers),
    );
  }

  Constructor _buildFromJsonFactory(
    String className,
    List<_InputFieldSpec> fields,
  ) {
    final args = <String, Expression>{};
    for (final field in fields) {
      args[field.propertyName] = _fromJsonExpression(field);
    }
    final constructorCall = refer(className).call([], args);
    return Constructor(
      (b) => b
        ..name = "fromJson"
        ..factory = true
        ..requiredParameters.add(
          Parameter((b) => b
            ..name = "json"
            ..type = _mapStringDynamicType()),
        )
        ..body = Block.of([constructorCall.returned.statement]),
    );
  }

  Method _buildToJsonMethod(List<_InputFieldSpec> fields) {
    final statements = <Code>[
      const Code(r"final _$result = <String, dynamic>{};"),
    ];
    for (final field in fields) {
      final localName = "_\$${field.propertyName}Value";
      statements.add(Code("final $localName = this.${field.propertyName};"));
      final localRef = refer(localName);
      if (field.isTriState) {
        statements.add(Code("if ($localName.isPresent) {"));
        final requiredName = "_\$${field.propertyName}Required";
        statements.add(
          Code("final $requiredName = $localName.requireValue;"),
        );
        final valueExpr = _toJsonExpression(
          field,
          valueExpr: refer(requiredName),
        );
        statements.add(
          refer(r"_$result")
              .index(literalString(field.responseKey))
              .assign(valueExpr)
              .statement,
        );
        statements.add(const Code("}"));
      } else if (field.isRequired) {
        final valueExpr = _toJsonExpression(field, valueExpr: localRef);
        statements.add(
          refer(r"_$result")
              .index(literalString(field.responseKey))
              .assign(valueExpr)
              .statement,
        );
      } else {
        final valueExpr = _toJsonExpression(field, valueExpr: localRef);
        statements.add(Code("if ($localName != null) {"));
        statements.add(
          refer(r"_$result")
              .index(literalString(field.responseKey))
              .assign(valueExpr)
              .statement,
        );
        statements.add(const Code("}"));
      }
    }
    statements.add(refer(r"_$result").returned.statement);

    return Method(
      (b) => b
        ..name = "toJson"
        ..returns = _mapStringDynamicType()
        ..body = Block.of(statements),
    );
  }

  Field _buildField(_InputFieldSpec field) => Field(
        (b) => b
          ..name = field.propertyName
          ..docs.addAll(_docs(field.description))
          ..type = field.typeRef
          ..modifier = FieldModifier.final$,
      );

  _InputFieldSpec _fieldSpecFromDefinition(InputValueDefinitionNode node) {
    final responseKey = node.name.value;
    final propertyName = identifier(node.name.value);
    final typeNode = node.type;
    final namedTypeName = unwrapNamedTypeName(typeNode) ?? "Object";
    final typeDef = schema.lookupType(NameNode(value: namedTypeName));

    Reference namedTypeRef;
    if (typeDef is InputObjectTypeDefinitionNode ||
        typeDef is EnumTypeDefinitionNode) {
      namedTypeRef = Reference(builtClassName(namedTypeName));
    } else if (typeDef is ScalarTypeDefinitionNode) {
      namedTypeRef = _scalarReference(namedTypeName);
    } else {
      namedTypeRef = refer("Object");
    }

    final isTriState = _useTriState && !typeNode.isNonNull;
    if (isTriState) {
      _usesTriStateValue = true;
    }

    final typeRef = _typeReferenceForTypeNode(
      typeNode,
      namedTypeRef,
      isTriState: isTriState,
    );

    return _InputFieldSpec(
      responseKey: responseKey,
      propertyName: propertyName,
      typeNode: typeNode,
      typeRef: typeRef,
      namedTypeRef: namedTypeRef,
      isTriState: isTriState,
      description: node.description?.value,
    );
  }

  Reference _scalarReference(String typeName) {
    final override = config.typeOverrides[typeName];
    if (override?.type != null) {
      if (override!.import != null) {
        _extraImports.add(override.import!);
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

  Reference _typeReferenceForTypeNode(
    TypeNode typeNode,
    Reference namedTypeRef, {
    required bool isTriState,
    bool forceNonNullOuter = false,
  }) {
    if (isTriState && !typeNode.isNonNull && !forceNonNullOuter) {
      final innerType = _typeReferenceForTypeNode(
        typeNode,
        namedTypeRef,
        isTriState: false,
        forceNonNullOuter: true,
      );
      return TypeReference(
        (b) => b
          ..symbol = "Value"
          ..types.add(innerType),
      );
    }

    if (typeNode is ListTypeNode) {
      final innerType = _typeReferenceForTypeNode(
        typeNode.type,
        namedTypeRef,
        isTriState: false,
      );
      return TypeReference(
        (b) => b
          ..symbol = "List"
          ..isNullable = forceNonNullOuter ? false : !typeNode.isNonNull
          ..types.add(innerType),
      );
    }

    if (typeNode is NamedTypeNode) {
      if (namedTypeRef is TypeReference) {
        return namedTypeRef.rebuild(
          (b) =>
              b..isNullable = forceNonNullOuter ? false : !typeNode.isNonNull,
        );
      }
      return TypeReference(
        (b) => b
          ..symbol = namedTypeRef.symbol
          ..url = namedTypeRef.url
          ..isNullable = forceNonNullOuter ? false : !typeNode.isNonNull,
      );
    }

    throw StateError("Invalid type node");
  }

  Expression _fromJsonExpression(_InputFieldSpec field) {
    final accessExpr = refer("json").index(literalString(field.responseKey));
    if (field.isTriState) {
      final inner = _fromJsonForTypeNode(field.typeNode, field, accessExpr);
      final condition = refer("json")
          .property("containsKey")
          .call([literalString(field.responseKey)]);
      final presentExpr = refer("Value").newInstanceNamed("present", [inner]);
      final absentExpr = refer("Value").newInstanceNamed("absent", []);
      final valueExpr =
          _conditionalExpression(condition, presentExpr, absentExpr);
      return wrapCollectionValue(
        config: config,
        node: field.typeNode,
        overrides: config.typeOverrides,
        valueExpr: valueExpr,
        nullGuard: _nullGuard,
      );
    }
    final valueExpr = _fromJsonForTypeNode(field.typeNode, field, accessExpr);
    return wrapCollectionValue(
      config: config,
      node: field.typeNode,
      overrides: config.typeOverrides,
      valueExpr: valueExpr,
      nullGuard: _nullGuard,
    );
  }

  Expression _fromJsonForTypeNode(
    TypeNode node,
    _InputFieldSpec field,
    Expression valueExpr,
  ) {
    if (node is ListTypeNode) {
      final innerExpr = _fromJsonForTypeNode(node.type, field, refer(r"_$e"));
      final castExpr = valueExpr.asA(_listDynamicType());
      final mapped = castExpr
          .property("map")
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(
                  Parameter((b) => b..name = r"_$e"),
                )
                ..lambda = true
                ..body = innerExpr.code,
            ).closure,
          ])
          .property("toList")
          .call([]);
      if (node.isNonNull) {
        return mapped;
      }
      return _nullGuard(valueExpr, mapped);
    }
    if (node is NamedTypeNode) {
      final typeName = node.name.value;
      final override = config.typeOverrides[typeName];
      final typeDef = schema.lookupType(NameNode(value: typeName));
      final inner = _fromJsonForNamedType(
        typeName: typeName,
        typeDef: typeDef,
        override: override,
        field: field,
        valueExpr: valueExpr,
      );
      if (node.isNonNull) {
        return inner;
      }
      return _nullGuard(valueExpr, inner);
    }
    throw StateError("Invalid type node");
  }

  Expression _fromJsonForNamedType({
    required String typeName,
    required TypeDefinitionNode? typeDef,
    required TypeOverrideConfig? override,
    required _InputFieldSpec field,
    required Expression valueExpr,
  }) {
    if (override?.fromJsonFunctionName != null) {
      return refer(override!.fromJsonFunctionName!).call([valueExpr]);
    }
    if (typeDef is EnumTypeDefinitionNode) {
      return field.namedTypeRef.property("fromJson").call([
        valueExpr.asA(refer("String")),
      ]);
    }
    if (typeDef is InputObjectTypeDefinitionNode) {
      return field.namedTypeRef.property("fromJson").call([
        valueExpr.asA(_mapStringDynamicType()),
      ]);
    }

    final scalarType = _scalarReference(typeName);
    return valueExpr.asA(scalarType);
  }

  Expression _toJsonExpression(
    _InputFieldSpec field, {
    required Expression valueExpr,
  }) {
    return _toJsonForTypeNode(
      field.typeNode,
      field,
      valueExpr,
    );
  }

  bool _needsCollectionWrapper(_InputFieldSpec field) {
    return needsCollectionWrapper(
      config: config,
      node: field.typeNode,
      overrides: config.typeOverrides,
    );
  }

  String _collectionWrapperExpression(
    _InputFieldSpec field,
    String propertyName,
  ) {
    return collectionWrapperExpression(
      config: config,
      node: field.typeNode,
      overrides: config.typeOverrides,
      propertyName: propertyName,
    );
  }

  Expression _toJsonForTypeNode(
    TypeNode node,
    _InputFieldSpec field,
    Expression valueExpr,
  ) {
    if (node is ListTypeNode) {
      final innerExpr = _toJsonForTypeNode(node.type, field, refer(r"_$e"));
      final mapped = valueExpr
          .property("map")
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(
                  Parameter((b) => b..name = r"_$e"),
                )
                ..lambda = true
                ..body = innerExpr.code,
            ).closure,
          ])
          .property("toList")
          .call([]);
      if (node.isNonNull) {
        return mapped;
      }
      return _nullGuard(valueExpr, mapped);
    }
    if (node is NamedTypeNode) {
      final typeName = node.name.value;
      final override = config.typeOverrides[typeName];
      final typeDef = schema.lookupType(NameNode(value: typeName));
      final inner = _toJsonForNamedType(
        typeName: typeName,
        typeDef: typeDef,
        override: override,
        field: field,
        valueExpr: valueExpr,
      );
      if (node.isNonNull) {
        return inner;
      }
      return _nullGuard(valueExpr, inner);
    }
    throw StateError("Invalid type node");
  }

  Expression _toJsonForNamedType({
    required String typeName,
    required TypeDefinitionNode? typeDef,
    required TypeOverrideConfig? override,
    required _InputFieldSpec field,
    required Expression valueExpr,
  }) {
    if (override?.toJsonFunctionName != null) {
      return refer(override!.toJsonFunctionName!).call([valueExpr]);
    }
    if (typeDef is EnumTypeDefinitionNode ||
        typeDef is InputObjectTypeDefinitionNode) {
      return valueExpr.property("toJson").call([]);
    }
    return valueExpr;
  }

  bool get _useTriState =>
      config.triStateOptionalsConfig == TriStateValueConfig.onAllNullableFields;
}

class _InputFieldSpec {
  final String responseKey;
  final String propertyName;
  final TypeNode typeNode;
  final Reference typeRef;
  final Reference namedTypeRef;
  final bool isTriState;
  final String? description;

  const _InputFieldSpec({
    required this.responseKey,
    required this.propertyName,
    required this.typeNode,
    required this.typeRef,
    required this.namedTypeRef,
    required this.isTriState,
    required this.description,
  });

  bool get isRequired => !isTriState && typeNode.isNonNull;
}

Expression _conditionalExpression(
  Expression condition,
  Expression whenTrue,
  Expression whenFalse,
) {
  return CodeExpression(
    Block.of([
      condition.code,
      const Code(" ? "),
      whenTrue.code,
      const Code(" : "),
      whenFalse.code,
    ]),
  );
}

Expression _nullGuard(Expression valueExpr, Expression innerExpr) {
  return CodeExpression(
    Block.of([
      valueExpr.code,
      const Code(" == null ? null : "),
      innerExpr.code,
    ]),
  );
}

TypeReference _mapStringDynamicType() => TypeReference(
      (b) => b
        ..symbol = "Map"
        ..types.addAll([
          refer("String"),
          refer("dynamic"),
        ]),
    );

TypeReference _listDynamicType() => TypeReference(
      (b) => b
        ..symbol = "List"
        ..types.add(refer("dynamic")),
    );

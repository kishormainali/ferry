import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "naming.dart";
import "schema.dart";
import "selection_resolver.dart";
import "type_utils.dart";

class VarsEmitter {
  final SchemaIndex schema;
  final BuilderConfig config;
  final DocumentIndex documentIndex;
  final Set<String> extraImports = {};

  bool _usesTriStateValue = false;

  VarsEmitter({
    required this.schema,
    required this.config,
    required this.documentIndex,
  });

  Library? buildLibrary({
    required Iterable<FragmentDefinitionNode> ownedFragments,
    required Iterable<OperationDefinitionNode> ownedOperations,
  }) {
    final specs = <Spec>[];

    for (final operation in ownedOperations) {
      if (operation.name == null) continue;
      if (operation.variableDefinitions.isEmpty) {
        continue;
      }
      specs.addAll(
        _buildVarsClass(
          "${operation.name!.value}Vars",
          operation.variableDefinitions
              .map(
                (definition) => _fieldSpecFromDefinition(
                  definition.variable.name.value,
                  definition.type,
                ),
              )
              .toList(),
        ),
      );
    }

    for (final fragment in ownedFragments) {
      final varTypes = _fragmentVarTypes(fragment);
      specs.addAll(
        _buildVarsClass(
          "${fragment.name.value}Vars",
          varTypes.entries
              .map(
                (entry) => _fieldSpecFromDefinition(
                  entry.key,
                  entry.value,
                ),
              )
              .toList(),
        ),
      );
    }

    if (specs.isEmpty) {
      return null;
    }

    if (_usesTriStateValue) {
      extraImports.add(
        "package:gql_tristate_value/gql_tristate_value.dart",
      );
    }

    return Library(
      (b) => b
        ..directives.addAll(
          extraImports.map(Directive.import),
        )
        ..body.addAll(specs),
    );
  }

  List<Spec> _buildVarsClass(String name, List<InputFieldSpec> fields) {
    final className = builtClassName(name);
    return [
      Class(
        (b) => b
          ..name = className
          ..fields.addAll(fields.map(_buildField))
          ..constructors.addAll([
            _buildConstructor(fields),
            _buildFromJsonFactory(className, fields),
          ])
          ..methods.add(
            _buildToJsonMethod(fields),
          ),
      ),
    ];
  }

  Constructor _buildConstructor(List<InputFieldSpec> fields) {
    final parameters = fields.map(
      (field) => Parameter(
        (b) => b
          ..name = field.propertyName
          ..named = true
          ..required = field.isRequired
          ..toThis = true
          ..defaultTo = field.isTriState
              ? const Code("const Value.absent()")
              : null,
      ),
    );

    return Constructor(
      (b) => b
        ..constant = true
        ..optionalParameters.addAll(parameters),
    );
  }

  Constructor _buildFromJsonFactory(
    String className,
    List<InputFieldSpec> fields,
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

  Method _buildToJsonMethod(List<InputFieldSpec> fields) {
    final statements = <Code>[
      const Code("final result = <String, dynamic>{};"),
    ];
    for (final field in fields) {
      final localName = "${field.propertyName}Value";
      statements.add(Code("final $localName = ${field.propertyName};"));
      final localRef = refer(localName);
      if (field.isTriState) {
        statements.add(Code("if ($localName.isPresent) {"));
        final requiredName = "${field.propertyName}Required";
        statements.add(
          Code("final $requiredName = $localName.requireValue;"),
        );
        final valueExpr = _toJsonExpression(
          field,
          valueExpr: refer(requiredName),
        );
        statements.add(
          refer("result")
              .index(literalString(field.responseKey))
              .assign(valueExpr)
              .statement,
        );
        statements.add(const Code("}"));
      } else if (field.isRequired) {
        final valueExpr = _toJsonExpression(field, valueExpr: localRef);
        statements.add(
          refer("result")
              .index(literalString(field.responseKey))
              .assign(valueExpr)
              .statement,
        );
      } else {
        final valueExpr = _toJsonExpression(field, valueExpr: localRef);
        statements.add(Code("if ($localName != null) {"));
        statements.add(
          refer("result")
              .index(literalString(field.responseKey))
              .assign(valueExpr)
              .statement,
        );
        statements.add(const Code("}"));
      }
    }
    statements.add(refer("result").returned.statement);

    return Method(
      (b) => b
        ..name = "toJson"
        ..returns = _mapStringDynamicType()
        ..body = Block.of(statements),
    );
  }

  Field _buildField(InputFieldSpec field) => Field(
        (b) => b
          ..name = field.propertyName
          ..type = field.typeRef
          ..modifier = FieldModifier.final$,
      );

  InputFieldSpec _fieldSpecFromDefinition(String name, TypeNode typeNode) {
    final responseKey = name;
    final propertyName = identifier(name);
    final namedTypeName = unwrapNamedTypeName(typeNode) ?? "Object";
    final typeDef = schema.lookupType(NameNode(value: namedTypeName));

    Reference namedTypeRef;
    if (typeDef is InputObjectTypeDefinitionNode ||
        typeDef is EnumTypeDefinitionNode) {
      namedTypeRef = Reference(
        builtClassName(namedTypeName),
        "#schema",
      );
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

    return InputFieldSpec(
      responseKey: responseKey,
      propertyName: propertyName,
      typeNode: typeNode,
      typeRef: typeRef,
      namedTypeRef: namedTypeRef,
      isTriState: isTriState,
    );
  }

  Reference _scalarReference(String typeName) {
    final override = config.typeOverrides[typeName];
    if (override?.type != null) {
      if (override!.import != null) {
        extraImports.add(override.import!);
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
          (b) => b..isNullable = forceNonNullOuter ? false : !typeNode.isNonNull,
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

  Expression _fromJsonExpression(InputFieldSpec field) {
    final accessExpr = refer("json").index(literalString(field.responseKey));
    if (field.isTriState) {
      final inner = _fromJsonForTypeNode(field.typeNode, field, accessExpr);
      final condition = refer("json")
          .property("containsKey")
          .call([literalString(field.responseKey)]);
      final presentExpr = refer("Value").newInstanceNamed("present", [inner]);
      final absentExpr = refer("Value").newInstanceNamed("absent", []);
      return _conditionalExpression(condition, presentExpr, absentExpr);
    }
    return _fromJsonForTypeNode(field.typeNode, field, accessExpr);
  }

  Expression _fromJsonForTypeNode(
    TypeNode node,
    InputFieldSpec field,
    Expression valueExpr,
  ) {
    if (node is ListTypeNode) {
      final innerExpr = _fromJsonForTypeNode(node.type, field, refer("e"));
      final castExpr = valueExpr.asA(_listDynamicType());
      final mapped = castExpr
          .property("map")
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(
                  Parameter((b) => b..name = "e"),
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
    required InputFieldSpec field,
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
    InputFieldSpec field, {
    required Expression valueExpr,
  }) {
    return _toJsonForTypeNode(
      field.typeNode,
      field,
      valueExpr,
    );
  }

  Expression _toJsonForTypeNode(
    TypeNode node,
    InputFieldSpec field,
    Expression valueExpr,
  ) {
    if (node is ListTypeNode) {
      final innerExpr = _toJsonForTypeNode(node.type, field, refer("e"));
      final mapped = valueExpr
          .property("map")
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(
                  Parameter((b) => b..name = "e"),
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
    required InputFieldSpec field,
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

  Map<String, TypeNode> _fragmentVarTypes(FragmentDefinitionNode fragment) {
    return _collectVarTypes(
      fragment.selectionSet,
      fragment.typeCondition.on.name.value,
      fragmentStack: {fragment.name.value},
    );
  }

  Map<String, TypeNode> _collectVarTypes(
    SelectionSetNode selectionSet,
    String parentTypeName, {
    required Set<String> fragmentStack,
  }) {
    final parentType = schema.lookupType(NameNode(value: parentTypeName));
    if (parentType == null) return {};

    final result = <String, TypeNode>{};

    for (final selection in selectionSet.selections) {
      if (selection is FieldNode) {
        final fieldDef =
            schema.lookupFieldDefinitionNode(parentType, selection.name);
        if (fieldDef != null) {
          for (final argument in selection.arguments) {
            final argDef = fieldDef.args
                .whereType<InputValueDefinitionNode?>()
                .firstWhere(
                  (arg) => arg?.name.value == argument.name.value,
                  orElse: () => null,
                );
            if (argDef != null) {
              _mergeVarTypes(
                result,
                _collectVarTypesFromValue(argument.value, argDef.type),
              );
            }
          }

          if (selection.selectionSet != null) {
            final fieldType =
                schema.lookupTypeDefinitionFromTypeNode(fieldDef.type);
            if (fieldType != null) {
              _mergeVarTypes(
                result,
                _collectVarTypes(
                  selection.selectionSet!,
                  fieldType.name.value,
                  fragmentStack: fragmentStack,
                ),
              );
            }
          }
        }
      } else if (selection is InlineFragmentNode) {
        final typeName =
            selection.typeCondition?.on.name.value ?? parentTypeName;
        _mergeVarTypes(
          result,
          _collectVarTypes(
            selection.selectionSet,
            typeName,
            fragmentStack: fragmentStack,
          ),
        );
      } else if (selection is FragmentSpreadNode) {
        final name = selection.name.value;
        if (fragmentStack.contains(name)) {
          throw StateError("Fragment spread cycle detected at $name");
        }
        final fragment = documentIndex.getFragment(name);
        _mergeVarTypes(
          result,
          _collectVarTypes(
            fragment.selectionSet,
            fragment.typeCondition.on.name.value,
            fragmentStack: {...fragmentStack, name},
          ),
        );
      }
    }

    return result;
  }

  Map<String, TypeNode> _collectVarTypesFromValue(
    ValueNode value,
    TypeNode typeNode,
  ) {
    if (value is VariableNode) {
      return {value.name.value: typeNode};
    }
    if (value is ListValueNode && typeNode is ListTypeNode) {
      final result = <String, TypeNode>{};
      for (final entry in value.values) {
        _mergeVarTypes(
          result,
          _collectVarTypesFromValue(entry, typeNode.type),
        );
      }
      return result;
    }
    if (value is ObjectValueNode) {
      final namedType = unwrapNamedType(typeNode);
      if (namedType == null) return {};
      final inputDef = schema.lookupTypeAs<InputObjectTypeDefinitionNode>(
        namedType.name,
      );
      if (inputDef == null) return {};
      final result = <String, TypeNode>{};
      for (final field in value.fields) {
        final inputField =
            schema.lookupInputFieldDefinition(inputDef, field.name);
        if (inputField == null) continue;
        _mergeVarTypes(
          result,
          _collectVarTypesFromValue(field.value, inputField.type),
        );
      }
      return result;
    }
    return {};
  }

  void _mergeVarTypes(
    Map<String, TypeNode> target,
    Map<String, TypeNode> other,
  ) {
    for (final entry in other.entries) {
      target[entry.key] = entry.value;
    }
  }
}

class InputFieldSpec {
  final String responseKey;
  final String propertyName;
  final TypeNode typeNode;
  final Reference typeRef;
  final Reference namedTypeRef;
  final bool isTriState;

  const InputFieldSpec({
    required this.responseKey,
    required this.propertyName,
    required this.typeNode,
    required this.typeRef,
    required this.namedTypeRef,
    required this.isTriState,
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

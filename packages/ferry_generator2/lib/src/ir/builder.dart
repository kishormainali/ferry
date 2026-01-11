import "package:gql/ast.dart";

import "../config/config.dart";
import "../schema/schema.dart";
import "../schema/type_utils.dart";
import "../selection/selection_resolver.dart";
import "model.dart";
import "types.dart";

DocumentIR buildDocumentIr({
  required SchemaIndex schema,
  required BuilderConfig config,
  required DocumentIndex documentIndex,
}) {
  final resolver = SelectionResolver(
    schema: schema,
    documentIndex: documentIndex,
    addTypenames: config.shouldAddTypenames,
  );

  final fragments = <String, FragmentIR>{};
  for (final fragment in documentIndex.fragments.values) {
    final selection = _buildSelectionSetIr(
      schema: schema,
      selectionSet: resolver.resolveFragment(fragment),
    );
    final variables = _fragmentVariableList(
      schema: schema,
      documentIndex: documentIndex,
      fragment: fragment,
    );

    fragments[fragment.name.value] = FragmentIR(
      name: fragment.name.value,
      typeCondition: fragment.typeCondition.on.name.value,
      selection: selection,
      usedFragments: const {},
      inlineTypes: selection.inlineFragments.keys.toSet(),
      variables: variables,
    );
  }

  for (final entry in fragments.entries.toList()) {
    final fragment = entry.value;
    fragments[entry.key] = FragmentIR(
      name: fragment.name,
      typeCondition: fragment.typeCondition,
      selection: fragment.selection,
      usedFragments: _collectUsedFragments(
        fragment.selection,
        fragments: fragments,
      ),
      inlineTypes: fragment.inlineTypes,
      variables: fragment.variables,
    );
  }

  final operations = <String, OperationIR>{};
  for (final operation in documentIndex.operations.values) {
    final selection = _buildSelectionSetIr(
      schema: schema,
      selectionSet: resolver.resolveOperation(operation),
    );
    final usedFragments = _collectUsedFragments(
      selection,
      fragments: fragments,
    );
    final variables = operation.variableDefinitions
        .map(
          (definition) => _variableFromDefinition(
            schema: schema,
            name: definition.variable.name.value,
            typeNode: definition.type,
          ),
        )
        .toList(growable: false);

    operations[operation.name!.value] = OperationIR(
      name: operation.name!.value,
      type: operation.type,
      rootTypeName: schema.determineOperationTypeName(operation.type),
      selection: selection,
      variables: variables,
      usedFragments: usedFragments,
    );
  }

  return DocumentIR(
    operations: operations,
    fragments: fragments,
  );
}

SelectionSetIR _buildSelectionSetIr({
  required SchemaIndex schema,
  required ResolvedSelectionSet selectionSet,
}) {
  final fields = <String, FieldIR>{};
  for (final entry in selectionSet.fields.entries) {
    final selection = entry.value;
    final namedTypeName = unwrapNamedTypeName(selection.typeNode) ?? "Object";
    final namedType = NamedTypeInfo(
      name: namedTypeName,
      kind: typeKindFor(schema, namedTypeName),
    );
    fields[entry.key] = FieldIR(
      responseKey: selection.responseKey,
      fieldName: selection.fieldName,
      typeNode: selection.typeNode,
      namedType: namedType,
      selectionSet: selection.selectionSet == null
          ? null
          : _buildSelectionSetIr(
              schema: schema,
              selectionSet: selection.selectionSet!,
            ),
      fragmentSpreadOnlyName: selection.fragmentSpreadOnlyName,
      isSynthetic: selection.isSynthetic,
    );
  }

  final inlineFragments = <String, SelectionSetIR>{};
  for (final entry in selectionSet.inlineFragments.entries) {
    inlineFragments[entry.key] = _buildSelectionSetIr(
      schema: schema,
      selectionSet: entry.value,
    );
  }

  return SelectionSetIR(
    parentTypeName: selectionSet.parentTypeName,
    fields: fields,
    inlineFragments: inlineFragments,
    fragmentSpreads: {...selectionSet.fragmentSpreads},
    unconditionalFragmentSpreads: {
      ...selectionSet.unconditionalFragmentSpreads
    },
  );
}

Set<String> _collectUsedFragments(
  SelectionSetIR selection, {
  required Map<String, FragmentIR> fragments,
}) {
  final result = <String>{};

  void visitSelection(SelectionSetIR current) {
    for (final name in current.fragmentSpreads) {
      if (!result.add(name)) continue;
      final fragment = fragments[name];
      if (fragment != null) {
        visitSelection(fragment.selection);
      }
    }
    for (final field in current.fields.values) {
      final nested = field.selectionSet;
      if (nested != null) {
        visitSelection(nested);
      }
    }
    for (final inline in current.inlineFragments.values) {
      visitSelection(inline);
    }
  }

  visitSelection(selection);
  return result;
}

VariableIR _variableFromDefinition({
  required SchemaIndex schema,
  required String name,
  required TypeNode typeNode,
}) {
  final namedTypeName = unwrapNamedTypeName(typeNode) ?? "Object";
  final namedType = NamedTypeInfo(
    name: namedTypeName,
    kind: typeKindFor(schema, namedTypeName),
  );
  return VariableIR(
    name: name,
    typeNode: typeNode,
    namedType: namedType,
  );
}

List<VariableIR> _fragmentVariableList({
  required SchemaIndex schema,
  required DocumentIndex documentIndex,
  required FragmentDefinitionNode fragment,
}) {
  final varTypes = _fragmentVarTypes(
    schema: schema,
    documentIndex: documentIndex,
    fragment: fragment,
  );
  return varTypes.entries
      .map(
        (entry) => _variableFromDefinition(
          schema: schema,
          name: entry.key,
          typeNode: entry.value,
        ),
      )
      .toList(growable: false);
}

Map<String, TypeNode> _fragmentVarTypes({
  required SchemaIndex schema,
  required DocumentIndex documentIndex,
  required FragmentDefinitionNode fragment,
}) {
  return _collectVarTypes(
    schema: schema,
    documentIndex: documentIndex,
    selectionSet: fragment.selectionSet,
    parentTypeName: fragment.typeCondition.on.name.value,
    fragmentStack: {fragment.name.value},
  );
}

Map<String, TypeNode> _collectVarTypes({
  required SchemaIndex schema,
  required DocumentIndex documentIndex,
  required SelectionSetNode selectionSet,
  required String parentTypeName,
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
          final argDef =
              fieldDef.args.whereType<InputValueDefinitionNode?>().firstWhere(
                    (arg) => arg?.name.value == argument.name.value,
                    orElse: () => null,
                  );
          if (argDef != null) {
            _mergeVarTypes(
              result,
              _collectVarTypesFromValue(schema, argument.value, argDef.type),
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
                schema: schema,
                documentIndex: documentIndex,
                selectionSet: selection.selectionSet!,
                parentTypeName: fieldType.name.value,
                fragmentStack: fragmentStack,
              ),
            );
          }
        }
      }
    } else if (selection is InlineFragmentNode) {
      final typeName = selection.typeCondition?.on.name.value ?? parentTypeName;
      _mergeVarTypes(
        result,
        _collectVarTypes(
          schema: schema,
          documentIndex: documentIndex,
          selectionSet: selection.selectionSet,
          parentTypeName: typeName,
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
          schema: schema,
          documentIndex: documentIndex,
          selectionSet: fragment.selectionSet,
          parentTypeName: fragment.typeCondition.on.name.value,
          fragmentStack: {...fragmentStack, name},
        ),
      );
    }
  }

  return result;
}

Map<String, TypeNode> _collectVarTypesFromValue(
  SchemaIndex schema,
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
        _collectVarTypesFromValue(schema, entry, typeNode.type),
      );
    }
    return result;
  }
  if (value is ObjectValueNode) {
    if (typeNode is! NamedTypeNode) return {};
    final typeName = typeNode.name.value;
    final typeDef = schema.lookupType(NameNode(value: typeName));
    if (typeDef is InputObjectTypeDefinitionNode) {
      final result = <String, TypeNode>{};
      final inputFields = schema.lookupInputValueDefinitions(typeDef);
      for (final field in value.fields) {
        final inputField =
            inputFields.whereType<InputValueDefinitionNode?>().firstWhere(
                  (entry) => entry?.name.value == field.name.value,
                  orElse: () => null,
                );
        if (inputField != null) {
          _mergeVarTypes(
            result,
            _collectVarTypesFromValue(schema, field.value, inputField.type),
          );
        }
      }
      return result;
    }
    return {};
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

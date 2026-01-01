import "package:gql/ast.dart";
import "package:gql/language.dart";

import "schema.dart";
import "type_utils.dart";

class DocumentIndex {
  final DocumentNode document;
  final Map<String, FragmentDefinitionNode> fragments;
  final Map<String, OperationDefinitionNode> operations;

  DocumentIndex(this.document)
      : fragments = {
          for (final fragment in document.definitions
              .whereType<FragmentDefinitionNode>())
            fragment.name.value: fragment,
        },
        operations = {
          for (final operation in document.definitions
              .whereType<OperationDefinitionNode>())
            if (operation.name != null)
              operation.name!.value: operation,
        };

  FragmentDefinitionNode getFragment(String name) {
    final fragment = fragments[name];
    if (fragment == null) {
      throw StateError("Missing fragment definition for $name");
    }
    return fragment;
  }
}

class FieldSelection {
  final String responseKey;
  final String fieldName;
  final String argumentsKey;
  final TypeNode typeNode;
  final ResolvedSelectionSet? selectionSet;
  final String? fragmentSpreadOnlyName;
  final bool isSynthetic;

  const FieldSelection({
    required this.responseKey,
    required this.fieldName,
    required this.argumentsKey,
    required this.typeNode,
    required this.selectionSet,
    required this.fragmentSpreadOnlyName,
    required this.isSynthetic,
  });

  FieldSelection mergeWith(FieldSelection other) {
    final mergedSelectionSet =
        _mergeSelectionSets(selectionSet, other.selectionSet);
    return FieldSelection(
      responseKey: responseKey,
      fieldName: fieldName,
      argumentsKey: argumentsKey,
      typeNode: typeNode,
      selectionSet: mergedSelectionSet,
      fragmentSpreadOnlyName: null,
      isSynthetic: isSynthetic && other.isSynthetic,
    );
  }
}

class ResolvedSelectionSet {
  final String parentTypeName;
  final Map<String, FieldSelection> fields = {};
  final Map<String, ResolvedSelectionSet> inlineFragments = {};
  final Set<String> fragmentSpreads = {};

  ResolvedSelectionSet({required this.parentTypeName});

  void addFragmentSpread(String name) => fragmentSpreads.add(name);

  void mergeFrom(ResolvedSelectionSet other) {
    for (final entry in other.fields.entries) {
      final existing = fields[entry.key];
      if (existing == null) {
        fields[entry.key] = entry.value;
      } else {
        fields[entry.key] = existing.mergeWith(entry.value);
      }
    }

    for (final entry in other.inlineFragments.entries) {
      final existing = inlineFragments[entry.key];
      if (existing == null) {
        inlineFragments[entry.key] = entry.value;
      } else {
        existing.mergeInlineFrom(entry.value);
      }
    }
  }

  void mergeInlineFrom(ResolvedSelectionSet other) {
    mergeFrom(other);
    fragmentSpreads.addAll(other.fragmentSpreads);
  }
}

ResolvedSelectionSet? _mergeSelectionSets(
  ResolvedSelectionSet? a,
  ResolvedSelectionSet? b,
) {
  if (a == null) return b;
  if (b == null) return a;
  a.mergeInlineFrom(b);
  return a;
}

class SelectionResolver {
  final SchemaIndex schema;
  final DocumentIndex documentIndex;
  final bool addTypenames;

  SelectionResolver({
    required this.schema,
    required this.documentIndex,
    required this.addTypenames,
  });

  ResolvedSelectionSet resolveOperation(OperationDefinitionNode operation) {
    if (operation.name == null) {
      throw StateError("Operations must be named");
    }
    final rootTypeName = schema.determineOperationTypeName(operation.type);
    return resolveSelectionSet(
      operation.selectionSet,
      rootTypeName,
      fragmentStack: const {},
    );
  }

  ResolvedSelectionSet resolveFragment(FragmentDefinitionNode fragment) {
    return resolveSelectionSet(
      fragment.selectionSet,
      fragment.typeCondition.on.name.value,
      fragmentStack: {fragment.name.value},
    );
  }

  ResolvedSelectionSet resolveSelectionSet(
    SelectionSetNode selectionSet,
    String parentTypeName, {
    required Set<String> fragmentStack,
  }) {
    final parentType = schema.lookupType(NameNode(value: parentTypeName));
    if (parentType == null) {
      throw StateError("Missing type definition for $parentTypeName");
    }

    final result = ResolvedSelectionSet(parentTypeName: parentTypeName);

    for (final selection in selectionSet.selections) {
      if (selection is FieldNode) {
        _addFieldSelection(result, parentType, selection, fragmentStack);
      } else if (selection is InlineFragmentNode) {
        _addInlineFragment(result, parentTypeName, selection, fragmentStack);
      } else if (selection is FragmentSpreadNode) {
        _addFragmentSpread(result, parentTypeName, selection, fragmentStack);
      }
    }

    final needsTypename =
        parentType is InterfaceTypeDefinitionNode ||
            parentType is UnionTypeDefinitionNode ||
            result.inlineFragments.isNotEmpty;
    if (needsTypename && !result.fields.containsKey("__typename")) {
      if (!addTypenames) {
        throw StateError(
          "Polymorphic selections require add_typenames to be true.",
        );
      }
      _ensureTypenameField(result);
    }

    return result;
  }

  void _addFieldSelection(
    ResolvedSelectionSet result,
    TypeDefinitionNode parentType,
    FieldNode field,
    Set<String> fragmentStack,
  ) {
    final fieldDefinition =
        schema.lookupFieldDefinitionNode(parentType, field.name);
    if (fieldDefinition == null) {
      throw StateError(
        "Failed to find type for field ${field.name.value} on ${parentType.name.value}",
      );
    }

    final typeNode = _applyConditionalNullability(
      fieldDefinition.type,
      field.directives,
    );

    final responseKey = field.alias?.value ?? field.name.value;
    final argumentsKey = _argumentsKey(field.arguments);
    ResolvedSelectionSet? nestedSelectionSet;
    String? fragmentSpreadOnlyName;

    if (field.selectionSet != null) {
      fragmentSpreadOnlyName = _fragmentSpreadOnlyName(field.selectionSet!);
      final fieldType =
          schema.lookupTypeDefinitionFromTypeNode(typeNode);
      if (fieldType == null) {
        throw StateError(
          "Failed to find type definition for ${field.name.value} on ${parentType.name.value}",
        );
      }
      nestedSelectionSet = resolveSelectionSet(
        field.selectionSet!,
        fieldType.name.value,
        fragmentStack: fragmentStack,
      );
    }

    final selection = FieldSelection(
      responseKey: responseKey,
      fieldName: field.name.value,
      argumentsKey: argumentsKey,
      typeNode: typeNode,
      selectionSet: nestedSelectionSet,
      fragmentSpreadOnlyName: fragmentSpreadOnlyName,
      isSynthetic: false,
    );

    final existing = result.fields[responseKey];
    if (existing == null) {
      result.fields[responseKey] = selection;
    } else {
      _assertCompatibleFieldSelection(existing, selection, parentType.name.value);
      result.fields[responseKey] = existing.mergeWith(selection);
    }
  }

  void _addInlineFragment(
    ResolvedSelectionSet result,
    String parentTypeName,
    InlineFragmentNode fragment,
    Set<String> fragmentStack,
  ) {
    final typeConditionName =
        fragment.typeCondition?.on.name.value ?? parentTypeName;
    final resolved = resolveSelectionSet(
      fragment.selectionSet,
      typeConditionName,
      fragmentStack: fragmentStack,
    );

    if (_shouldMergeIntoBase(parentTypeName, typeConditionName)) {
      result.mergeFrom(resolved);
      return;
    }

    final existing = result.inlineFragments[typeConditionName];
    if (existing == null) {
      result.inlineFragments[typeConditionName] = resolved;
    } else {
      existing.mergeInlineFrom(resolved);
    }
  }

  void _addFragmentSpread(
    ResolvedSelectionSet result,
    String parentTypeName,
    FragmentSpreadNode spread,
    Set<String> fragmentStack,
  ) {
    final name = spread.name.value;
    if (fragmentStack.contains(name)) {
      throw StateError("Fragment spread cycle detected at $name");
    }

    final fragment = documentIndex.getFragment(name);
    final fragmentTypeName = fragment.typeCondition.on.name.value;
    final resolved = resolveSelectionSet(
      fragment.selectionSet,
      fragmentTypeName,
      fragmentStack: {...fragmentStack, name},
    );

    if (_shouldMergeIntoBase(parentTypeName, fragmentTypeName)) {
      result.mergeFrom(resolved);
      result.addFragmentSpread(name);
      return;
    }

    final existing = result.inlineFragments[fragmentTypeName];
    if (existing == null) {
      result.inlineFragments[fragmentTypeName] = resolved;
      resolved.addFragmentSpread(name);
    } else {
      existing.mergeInlineFrom(resolved);
      existing.addFragmentSpread(name);
    }
  }

  bool _shouldMergeIntoBase(String parentTypeName, String fragmentTypeName) {
    if (parentTypeName == fragmentTypeName) return true;
    final parentPossible = _possibleTypesFor(parentTypeName);
    final fragmentPossible = _possibleTypesFor(fragmentTypeName);
    if (parentPossible.isEmpty || fragmentPossible.isEmpty) return false;
    return parentPossible.difference(fragmentPossible).isEmpty;
  }

  Set<String> _possibleTypesFor(String typeName) {
    final typeDef = schema.lookupType(NameNode(value: typeName));
    if (typeDef is ObjectTypeDefinitionNode) {
      return {typeName};
    }
    return schema.possibleTypesMap()[typeName] ?? {};
  }

  void _ensureTypenameField(ResolvedSelectionSet result) {
    if (result.fields.containsKey("__typename")) return;
    result.fields["__typename"] = FieldSelection(
      responseKey: "__typename",
      fieldName: "__typename",
      argumentsKey: "",
      typeNode: NamedTypeNode(
        name: NameNode(value: "String"),
        isNonNull: true,
      ),
      selectionSet: null,
      fragmentSpreadOnlyName: null,
      isSynthetic: true,
    );
  }
}

TypeNode _applyConditionalNullability(
  TypeNode typeNode,
  List<DirectiveNode> directives,
) {
  if (_hasConditionalDirective(directives)) {
    return makeTypeNodeNullable(typeNode);
  }
  return typeNode;
}

bool _hasConditionalDirective(List<DirectiveNode> directives) {
  for (final directive in directives) {
    if (directive.name.value == "include" ||
        directive.name.value == "skip") {
      return true;
    }
  }
  return false;
}

String _argumentsKey(List<ArgumentNode> arguments) {
  if (arguments.isEmpty) return "";
  final entries = arguments
      .map(
        (argument) => MapEntry(
          argument.name.value,
          printNode(argument.value),
        ),
      )
      .toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return entries.map((entry) => "${entry.key}:${entry.value}").join(",");
}

void _assertCompatibleFieldSelection(
  FieldSelection existing,
  FieldSelection incoming,
  String parentTypeName,
) {
  if (existing.fieldName != incoming.fieldName) {
    throw StateError(
      "Conflicting fields for response key ${existing.responseKey} on $parentTypeName: ${existing.fieldName} vs ${incoming.fieldName}",
    );
  }
  if (existing.argumentsKey != incoming.argumentsKey) {
    throw StateError(
      "Conflicting arguments for response key ${existing.responseKey} on $parentTypeName",
    );
  }
}

String? _fragmentSpreadOnlyName(SelectionSetNode selectionSet) {
  String? spreadName;
  for (final selection in selectionSet.selections) {
    if (selection is FragmentSpreadNode) {
      if (spreadName != null) return null;
      spreadName = selection.name.value;
      continue;
    }
    if (selection is FieldNode &&
        selection.name.value == "__typename" &&
        selection.selectionSet == null) {
      continue;
    }
    return null;
  }
  return spreadName;
}

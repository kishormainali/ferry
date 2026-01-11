import "package:gql/ast.dart";

import "types.dart";

class DocumentIR {
  final Map<String, OperationIR> operations;
  final Map<String, FragmentIR> fragments;

  const DocumentIR({
    required this.operations,
    required this.fragments,
  });
}

class OperationIR {
  final String name;
  final OperationType type;
  final String rootTypeName;
  final SelectionSetIR selection;
  final List<VariableIR> variables;
  final Set<String> usedFragments;

  const OperationIR({
    required this.name,
    required this.type,
    required this.rootTypeName,
    required this.selection,
    required this.variables,
    required this.usedFragments,
  });
}

class FragmentIR {
  final String name;
  final String typeCondition;
  final SelectionSetIR selection;
  final Set<String> usedFragments;
  final Set<String> inlineTypes;
  final List<VariableIR> variables;

  const FragmentIR({
    required this.name,
    required this.typeCondition,
    required this.selection,
    required this.usedFragments,
    required this.inlineTypes,
    required this.variables,
  });
}

class SelectionSetIR {
  final String parentTypeName;
  final Map<String, FieldIR> fields;
  final Map<String, SelectionSetIR> inlineFragments;
  final Set<String> fragmentSpreads;
  final Set<String> unconditionalFragmentSpreads;

  const SelectionSetIR({
    required this.parentTypeName,
    required this.fields,
    required this.inlineFragments,
    required this.fragmentSpreads,
    required this.unconditionalFragmentSpreads,
  });
}

class FieldIR {
  final String responseKey;
  final String fieldName;
  final TypeNode typeNode;
  final NamedTypeInfo namedType;
  final SelectionSetIR? selectionSet;
  final String? fragmentSpreadOnlyName;
  final bool isSynthetic;

  const FieldIR({
    required this.responseKey,
    required this.fieldName,
    required this.typeNode,
    required this.namedType,
    required this.selectionSet,
    required this.fragmentSpreadOnlyName,
    required this.isSynthetic,
  });
}

class VariableIR {
  final String name;
  final TypeNode typeNode;
  final NamedTypeInfo namedType;

  const VariableIR({
    required this.name,
    required this.typeNode,
    required this.namedType,
  });
}

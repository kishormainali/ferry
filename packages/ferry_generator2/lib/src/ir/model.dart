import "package:gql/ast.dart";

import "names.dart";
import "types.dart";

class DocumentIR {
  final Map<OperationName, OperationIR> operations;
  final Map<FragmentName, FragmentIR> fragments;

  const DocumentIR({
    required this.operations,
    required this.fragments,
  });
}

class OperationIR {
  final OperationName name;
  final OperationType type;
  final TypeName rootTypeName;
  final SelectionSetIR selection;
  final List<VariableIR> variables;
  final Set<FragmentName> usedFragments;

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
  final FragmentName name;
  final TypeName typeCondition;
  final SelectionSetIR selection;
  final Set<FragmentName> usedFragments;
  final Set<TypeName> inlineTypes;
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
  /// GraphQL parent type name for this selection set (object/interface/union).
  final TypeName parentTypeName;

  /// Concrete field selections keyed by response key.
  final Map<ResponseKey, FieldIR> fields;

  /// Type-conditioned branches that cannot be merged into the base selection.
  ///
  /// Keys are concrete type names (e.g. "Human", "Droid") and values are the
  /// selections that apply only when __typename matches that type.
  final Map<TypeName, SelectionSetIR> inlineFragments;

  /// All fragment spreads referenced anywhere in this selection set.
  ///
  /// This is a dependency list and includes conditional spreads.
  final Set<FragmentName> fragmentSpreads;

  /// Fragment spreads that are unconditionally applied (no @skip/@include).
  ///
  /// This is used for interface typing: conditional spreads are excluded to
  /// avoid claiming fields that may not be present.
  final Set<FragmentName> unconditionalFragmentSpreads;

  const SelectionSetIR({
    required this.parentTypeName,
    required this.fields,
    required this.inlineFragments,
    required this.fragmentSpreads,
    required this.unconditionalFragmentSpreads,
  });
}

class FieldIR {
  final ResponseKey responseKey;
  final FieldName fieldName;
  final TypeNode typeNode;
  final NamedTypeInfo namedType;
  final SelectionSetIR? selectionSet;
  final FragmentName? fragmentSpreadOnlyName;
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
  final VariableName name;
  final TypeNode typeNode;
  final NamedTypeInfo namedType;

  const VariableIR({
    required this.name,
    required this.typeNode,
    required this.namedType,
  });
}

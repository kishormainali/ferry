import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "../config/builder_config.dart";

bool isMapOverrideType(
  String typeName,
  Map<String, TypeOverrideConfig> overrides,
) {
  final override = overrides[typeName];
  final overrideType = override?.type;
  if (overrideType == null) return false;
  final normalized = overrideType.replaceAll(" ", "");
  return RegExp(r'(^|\.)Map(<|\?|$)').hasMatch(normalized);
}

bool needsCollectionWrapper({
  required BuilderConfig config,
  required TypeNode node,
  required Map<String, TypeOverrideConfig> overrides,
}) {
  if (config.collections.mode != CollectionMode.unmodifiable) {
    return false;
  }
  if (node is ListTypeNode) return true;
  if (node is NamedTypeNode) {
    return isMapOverrideType(node.name.value, overrides);
  }
  return false;
}

Expression wrapCollectionValue({
  required BuilderConfig config,
  required TypeNode node,
  required Map<String, TypeOverrideConfig> overrides,
  required Expression valueExpr,
  required Expression Function(Expression valueExpr, Expression innerExpr)
      nullGuard,
}) {
  if (!needsCollectionWrapper(
    config: config,
    node: node,
    overrides: overrides,
  )) {
    return valueExpr;
  }
  if (node is ListTypeNode) {
    final wrapped = refer("List").property("unmodifiable").call([valueExpr]);
    return node.isNonNull ? wrapped : nullGuard(valueExpr, wrapped);
  }
  if (node is NamedTypeNode && isMapOverrideType(node.name.value, overrides)) {
    final wrapped = refer("Map").property("unmodifiable").call([valueExpr]);
    return node.isNonNull ? wrapped : nullGuard(valueExpr, wrapped);
  }
  return valueExpr;
}

String collectionWrapperExpression({
  required BuilderConfig config,
  required TypeNode node,
  required Map<String, TypeOverrideConfig> overrides,
  required String propertyName,
}) {
  if (!needsCollectionWrapper(
    config: config,
    node: node,
    overrides: overrides,
  )) {
    return propertyName;
  }
  if (node is ListTypeNode) {
    final wrapper = "List.unmodifiable($propertyName)";
    return node.isNonNull ? wrapper : "$propertyName == null ? null : $wrapper";
  }
  if (node is NamedTypeNode && isMapOverrideType(node.name.value, overrides)) {
    final wrapper = "Map.unmodifiable($propertyName)";
    return node.isNonNull ? wrapper : "$propertyName == null ? null : $wrapper";
  }
  return propertyName;
}

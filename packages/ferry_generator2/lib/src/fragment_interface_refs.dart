import "package:code_builder/code_builder.dart";

import "data_emitter_context.dart";
import "naming.dart";

List<Reference> fragmentInterfaceRefs({
  required DataEmitterContext ctx,
  required Set<String> fragmentSpreads,
  required String parentTypeName,
  required List<Reference> baseImplements,
}) {
  final refs = <Reference>[...baseImplements];
  final seen = <String>{
    for (final ref in baseImplements)
      if (ref.symbol != null) "${ref.symbol}|${ref.url ?? ''}",
  };

  final expanded = _expandFragmentSpreads(
    ctx: ctx,
    fragmentSpreads: fragmentSpreads,
  );

  for (final fragmentName in expanded) {
    final interfaceName = _fragmentInterfaceForType(
      ctx: ctx,
      fragmentName: fragmentName,
      typeName: parentTypeName,
    );
    final fragmentUrl = ctx.fragmentSourceUrls[fragmentName];
    if (fragmentUrl == null) continue;
    final url = "$fragmentUrl#data";
    final key = "$interfaceName|$url";
    if (!seen.add(key)) continue;
    refs.add(Reference(interfaceName, url));
  }

  return refs;
}

List<String> _expandFragmentSpreads({
  required DataEmitterContext ctx,
  required Set<String> fragmentSpreads,
}) {
  final ordered = <String>[];
  final seen = <String>{};

  void visit(String name) {
    if (!seen.add(name)) return;
    ordered.add(name);
    final info = ctx.fragmentInfo[name];
    if (info == null) return;
    for (final nested in info.selectionSet.unconditionalFragmentSpreads) {
      visit(nested);
    }
  }

  for (final name in fragmentSpreads) {
    visit(name);
  }

  return ordered;
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

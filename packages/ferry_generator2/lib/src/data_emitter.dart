import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "data_emitter_classes.dart";
import "data_emitter_context.dart";
import "data_emitter_fragments.dart";
import "schema.dart";
import "selection_resolver.dart";

class DataEmitter {
  final DataEmitterContext _ctx;

  DataEmitter._(this._ctx);

  factory DataEmitter({
    required SchemaIndex schema,
    required BuilderConfig config,
    required DocumentIndex documentIndex,
    required SelectionResolver resolver,
    required Map<String, String> fragmentSourceUrls,
    required String? utilsUrl,
  }) {
    final ctx = DataEmitterContext(
      schema: schema,
      config: config,
      documentIndex: documentIndex,
      resolver: resolver,
      fragmentSourceUrls: fragmentSourceUrls,
      utilsUrl: utilsUrl,
    );
    indexFragments(ctx: ctx);
    return DataEmitter._(ctx);
  }

  Library buildLibrary({
    required Iterable<FragmentDefinitionNode> ownedFragments,
    required Iterable<OperationDefinitionNode> ownedOperations,
  }) {
    final specs = <Spec>[];
    _ctx.needsUtilsImport = false;

    for (final fragment in ownedFragments) {
      final fragmentInterfaces = buildFragmentInterfaces(
        ctx: _ctx,
        fragment: fragment,
      );
      specs.addAll(fragmentInterfaces.specs);

      final fragmentData = buildFragmentData(
        ctx: _ctx,
        fragment: fragment,
      );
      specs.addAll(fragmentData.specs);
    }

    for (final operation in ownedOperations) {
      final operationData = buildOperationData(
        ctx: _ctx,
        operation: operation,
      );
      specs.addAll(operationData.specs);
    }

    final directives = <Directive>[
      if (_ctx.needsUtilsImport && _ctx.utilsUrl != null)
        Directive.import(_ctx.utilsUrl!, as: utilsImportAlias),
      ..._ctx.extraImports.map(Directive.import),
    ];
    return Library(
      (b) => b
        ..directives.addAll(directives)
        ..body.addAll(specs),
    );
  }
}

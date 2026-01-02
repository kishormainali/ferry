import "dart:async";

import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";
import "package:path/path.dart" as p;

import "src/add_typenames.dart";
import "src/allocator.dart";
import "src/ast_builder.dart";
import "src/config.dart";
import "src/data_emitter.dart";
import "src/locations.dart";
import "src/reader.dart";
import "src/req_emitter.dart";
import "src/schema.dart";
import "src/schema_emitter.dart";
import "src/selection_resolver.dart";
import "src/source.dart";
import "src/utils_emitter.dart";
import "src/vars_emitter.dart";
import "src/writer.dart";
import "src/validation.dart";

Builder graphqlBuilder(BuilderOptions options) =>
    GraphqlBuilder(options.config);

class GraphqlBuilder implements Builder {
  final BuilderConfig config;

  GraphqlBuilder(Map<String, dynamic> config) : config = BuilderConfig(config);

  @override
  Map<String, List<String>> get buildExtensions {
    final outputs = <String>[];

    if (config.outputs.ast) {
      outputs.add("{{dir}}/${config.outputDir}/{{file}}$astExtension");
    }
    if (config.outputs.data) {
      outputs.add("{{dir}}/${config.outputDir}/{{file}}$dataExtension");
    }
    if (config.outputs.vars) {
      outputs.add("{{dir}}/${config.outputDir}/{{file}}$varExtension");
    }
    if (config.outputs.req) {
      outputs.add("{{dir}}/${config.outputDir}/{{file}}$reqExtension");
    }
    if (config.outputs.schema) {
      outputs.add("{{dir}}/${config.outputDir}/{{file}}$schemaExtension");
    }
    if (config.generateEquals || config.generateHashCode) {
      outputs.add("{{dir}}/${config.outputDir}/{{file}}$utilsExtension");
    }

    if (outputs.isEmpty) {
      return const {};
    }

    return {
      "{{dir}}/{{file}}${config.sourceExtension}": outputs,
    };
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (!config.outputs.ast &&
        !config.outputs.data &&
        !config.outputs.vars &&
        !config.outputs.req &&
        !config.outputs.schema) {
      return;
    }

    DocumentSource? schemaSource;
    AssetId? schemaId;

    if (config.schemaIds != null) {
      for (final candidate in config.schemaIds!) {
        if (buildStep.inputId.package != candidate.package) {
          continue;
        }
        final docPath = p.url.normalize(buildStep.inputId.path);
        final schemaDir = p.url.dirname(candidate.path);
        if (p.url.isWithin(schemaDir, docPath)) {
          schemaSource = await readDocument(
            buildStep,
            config.sourceExtension,
            candidate,
          );
          schemaId = candidate;
          break;
        }
      }
    }

    if (schemaSource == null && config.schemaId != null) {
      schemaSource = await readDocument(
        buildStep,
        config.sourceExtension,
        config.schemaId,
      );
      schemaId = config.schemaId;
    }

    if (schemaSource == null || schemaId == null) {
      throw StateError("No schema found for ${buildStep.inputId}");
    }

    if ((config.whenExtensionConfig.generateMaybeWhenExtensionMethod ||
            config.whenExtensionConfig.generateWhenExtensionMethod) &&
        !config.shouldAddTypenames) {
      throw StateError(
        "When extensions require schema.add_typenames to be true. Consider setting schema.add_typenames to true or disabling data_classes.when_extensions in your build.yaml.",
      );
    }

    final schemaIndex = SchemaIndex.fromDocuments([schemaSource.flatDocument]);
    final sourceUrl = buildStep.inputId.uri.toString();
    final schemaUrl = schemaId.uri.toString();

    Future<void> writeOutput(
      String extension,
      Library library,
      AssetId outputId,
    ) {
      final allocator = GeneratorAllocator(
        sourceUrl: sourceUrl,
        sourceExtension: config.sourceExtension,
        currentUrl: outputId.uri.toString(),
        outputDir: config.outputDir,
        schemaUrl: schemaUrl,
      );
      return writeLibrary(
        outputId: outputId,
        library: library,
        buildStep: buildStep,
        config: config,
        allocator: allocator,
      );
    }

    if (buildStep.inputId == schemaId) {
      if (config.outputs.schema) {
        final outputId = outputAssetId(
          buildStep.inputId,
          schemaExtension,
          config.outputDir,
        );
        await writeOutput(
          schemaExtension,
          buildSchemaLibrary(
            schema: schemaIndex,
            config: config,
          ),
          outputId,
        );
      }

      if (config.generateEquals || config.generateHashCode) {
        final outputId = outputAssetId(
          buildStep.inputId,
          utilsExtension,
          config.outputDir,
        );
        await writeOutput(
          utilsExtension,
          buildUtilsLibrary(),
          outputId,
        );
      }
      return;
    }

    final docSource = await readDocument(
      buildStep,
      config.sourceExtension,
    );
    final sourceWithTypenames =
        config.shouldAddTypenames ? addTypenamesToSource(docSource) : docSource;

    final documentIndex = DocumentIndex(sourceWithTypenames.flatDocument);
    final resolver = SelectionResolver(
      schema: schemaIndex,
      documentIndex: documentIndex,
      addTypenames: config.shouldAddTypenames,
    );
    DocumentValidator(
      schema: schemaIndex,
      documentIndex: documentIndex,
    ).validate(sourceWithTypenames.flatDocument);

    final fragmentSourceUrls = _fragmentSourceUrls(sourceWithTypenames);

    final utilsUrl = (config.generateEquals || config.generateHashCode)
        ? outputAssetId(schemaId, utilsExtension, config.outputDir)
            .uri
            .toString()
        : null;
    final ownedFragments = sourceWithTypenames.document.definitions
        .whereType<FragmentDefinitionNode>();
    final ownedOperations = sourceWithTypenames.document.definitions
        .whereType<OperationDefinitionNode>();

    final dataEmitter = DataEmitter(
      schema: schemaIndex,
      config: config,
      documentIndex: documentIndex,
      resolver: resolver,
      fragmentSourceUrls: fragmentSourceUrls,
      utilsUrl: utilsUrl,
    );
    final varsEmitter = VarsEmitter(
      schema: schemaIndex,
      config: config,
      documentIndex: documentIndex,
    );
    final fragmentsWithVars = <String>{};
    for (final fragment in ownedFragments) {
      if (varsEmitter.fragmentVarTypes(fragment).isNotEmpty) {
        fragmentsWithVars.add(fragment.name.value);
      }
    }
    final reqEmitter = ReqEmitter(
      config: config,
      fragmentsWithVars: fragmentsWithVars,
      documentIndex: documentIndex,
      fragmentSourceUrls: fragmentSourceUrls,
      utilsUrl: utilsUrl,
    );

    if (config.outputs.ast) {
      final outputId = outputAssetId(
        buildStep.inputId,
        astExtension,
        config.outputDir,
      );
      await writeOutput(
        astExtension,
        buildAstLibrary(sourceWithTypenames),
        outputId,
      );
    }

    if (config.outputs.data) {
      final outputId = outputAssetId(
        buildStep.inputId,
        dataExtension,
        config.outputDir,
      );
      await writeOutput(
        dataExtension,
        dataEmitter.buildLibrary(
          ownedFragments: ownedFragments,
          ownedOperations: ownedOperations,
        ),
        outputId,
      );
    }

    if (config.outputs.vars) {
      final outputId = outputAssetId(
        buildStep.inputId,
        varExtension,
        config.outputDir,
      );
      final varsLibrary = varsEmitter.buildLibrary(
        ownedFragments: ownedFragments,
        ownedOperations: ownedOperations,
      );
      if (varsLibrary != null) {
        await writeOutput(
          varExtension,
          varsLibrary,
          outputId,
        );
      }
    }

    if (config.outputs.req) {
      final outputId = outputAssetId(
        buildStep.inputId,
        reqExtension,
        config.outputDir,
      );
      await writeOutput(
        reqExtension,
        reqEmitter.buildLibrary(
          ownedFragments: ownedFragments,
          ownedOperations: ownedOperations,
        ),
        outputId,
      );
    }

  }
}

Map<String, String> _fragmentSourceUrls(DocumentSource source) {
  final urls = <String, String>{};

  void collect(DocumentSource current) {
    for (final fragment
        in current.document.definitions.whereType<FragmentDefinitionNode>()) {
      urls[fragment.name.value] = current.url;
    }
    for (final entry in current.imports) {
      collect(entry);
    }
  }

  collect(source);
  return urls;
}

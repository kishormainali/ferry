import "dart:async";

import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "src/selection/add_typenames.dart";
import "src/utils/allocator.dart";
import "src/emit/ast_builder.dart";
import "src/config/config.dart";
import "src/emit/data_emitter.dart";
import "src/utils/locations.dart";
import "src/source/reader.dart";
import "src/emit/req_emitter.dart";
import "src/schema/schema.dart";
import "src/emit/schema_emitter.dart";
import "src/selection/selection_resolver.dart";
import "src/ir/builder.dart";
import "src/source/source.dart";
import "src/emit/utils_emitter.dart";
import "src/emit/vars_emitter.dart";
import "src/utils/writer.dart";
import "src/selection/validation.dart";

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

    final schemaId = config.schemaId;
    if (schemaId == null) {
      throw StateError("No schema configured for ${buildStep.inputId}");
    }

    final schemaSource = await readDocument(
      buildStep,
      config.sourceExtension,
      schemaId,
    );

    if ((config.whenExtensionConfig.generateMaybeWhenExtensionMethod ||
            config.whenExtensionConfig.generateWhenExtensionMethod) &&
        !config.shouldAddTypenames) {
      throw StateError(
        "When extensions require schema.add_typenames to be true. Consider setting schema.add_typenames to true or disabling data_classes.when_extensions in your build.yaml.",
      );
    }

    final schemaIndex = SchemaIndex.fromDocuments([schemaSource.flatDocument]);
    _validateEnumFallbacks(schemaIndex, config.enumFallbackConfig);
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
      if (config.outputs.ast) {
        final outputId = outputAssetId(
          buildStep.inputId,
          astExtension,
          config.outputDir,
        );
        await writeOutput(
          astExtension,
          buildAstLibrary(schemaSource),
          outputId,
        );
      }

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
    DocumentValidator(
      schema: schemaIndex,
      documentIndex: documentIndex,
    ).validate(sourceWithTypenames.flatDocument);

    final documentIr = buildDocumentIr(
      schema: schemaIndex,
      config: config,
      documentIndex: documentIndex,
    );

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
      config: config,
      document: documentIr,
      fragmentSourceUrls: fragmentSourceUrls,
      utilsUrl: utilsUrl,
    );
    final varsEmitter = VarsEmitter(
      config: config,
      document: documentIr,
      utilsUrl: utilsUrl,
    );
    final reqEmitter = ReqEmitter(
      config: config,
      documentIndex: documentIndex,
      document: documentIr,
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

void _validateEnumFallbacks(
  SchemaIndex schema,
  EnumFallbackConfig config,
) {
  if (config.fallbackValueMap.isEmpty) return;
  final unknown = config.fallbackValueMap.keys
      .where(
        (name) =>
            schema
                .lookupTypeAs<EnumTypeDefinitionNode>(NameNode(value: name)) ==
            null,
      )
      .toList()
    ..sort();
  if (unknown.isNotEmpty) {
    throw StateError(
      "Unknown enum(s) in enums.fallback.per_enum: ${unknown.join(', ')}",
    );
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

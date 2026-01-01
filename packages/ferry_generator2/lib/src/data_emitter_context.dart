import "config.dart";
import "data_emitter_types.dart";
import "schema.dart";
import "selection_resolver.dart";

const utilsImportAlias = "_gqlUtils";
const utilsPrefix = "$utilsImportAlias.";

class DataEmitterContext {
  final SchemaIndex schema;
  final BuilderConfig config;
  final DocumentIndex documentIndex;
  final SelectionResolver resolver;
  final Map<String, String> fragmentSourceUrls;
  final String? utilsUrl;

  final Set<String> extraImports = {};
  final Map<String, FragmentInfo> fragmentInfo = {};
  final Set<String> generatedClasses = {};
  final Set<String> generatedInterfaces = {};
  final Map<String, ResolvedSelectionSet> fragmentInterfaceSelections = {};
  final Map<String, String> interfaceKeyToFragmentName = {};
  bool needsUtilsImport = false;

  DataEmitterContext({
    required this.schema,
    required this.config,
    required this.documentIndex,
    required this.resolver,
    required this.fragmentSourceUrls,
    required this.utilsUrl,
  });
}

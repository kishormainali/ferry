import "../config/config.dart";
import "../ir/model.dart";
import "../ir/names.dart";
import "data_emitter_types.dart";

const utilsImportAlias = "_gqlUtils";
const utilsPrefix = "$utilsImportAlias.";

class DataEmitterContext {
  final BuilderConfig config;
  final DocumentIR document;
  final Map<FragmentName, String> fragmentSourceUrls;
  final String? utilsUrl;

  final Set<String> extraImports = {};
  final Map<FragmentName, FragmentInfo> fragmentInfo = {};
  final Set<String> generatedClasses = {};
  final Set<String> generatedInterfaces = {};
  final Map<String, SelectionSetIR> fragmentInterfaceSelections = {};
  final Map<String, FragmentName> interfaceKeyToFragmentName = {};
  bool needsUtilsImport = false;

  DataEmitterContext({
    required this.config,
    required this.document,
    required this.fragmentSourceUrls,
    required this.utilsUrl,
  });
}

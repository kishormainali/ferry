import "package:build/build.dart";
import "package:pub_semver/pub_semver.dart";
import "package:yaml/yaml.dart";

const astExtension = ".ast.gql.dart";
const dataExtension = ".data.gql.dart";
const varExtension = ".var.gql.dart";
const reqExtension = ".req.gql.dart";
const schemaExtension = ".schema.gql.dart";
const utilsExtension = ".utils.gql.dart";

class BuilderConfig {
  final AssetId? schemaId;
  final bool shouldAddTypenames;
  final bool shouldGeneratePossibleTypes;
  final Map<String, TypeOverrideConfig> typeOverrides;
  final EnumFallbackConfig enumFallbackConfig;
  final String outputDir;
  final String sourceExtension;
  final InlineFragmentSpreadWhenExtensionConfig whenExtensionConfig;
  final DataClassConfig dataClassConfig;
  final TriStateValueConfig triStateOptionalsConfig;
  final bool format;
  final Version? formatterLanguageVersion;
  final OutputsConfig outputs;
  final bool generateCopyWith;
  final bool generateEquals;
  final bool generateHashCode;
  final bool generateToString;
  final bool generateDocs;

  factory BuilderConfig(Map<String, dynamic> config) {
    final root = _ConfigReader("options", config);

    final schemaValue = root.raw("schema");
    final schemaConfig = _toMap(schemaValue);
    if (schemaValue != null && schemaConfig.isEmpty) {
      throw ArgumentError.value(
        schemaValue,
        "schema",
        "Expected a map with keys like file, add_typenames",
      );
    }

    final schemaReader = _ConfigReader("schema", schemaConfig);
    final schemaFile = schemaReader.raw("file");
    final schemaFiles = schemaReader.raw("files");
    if (schemaFiles != null) {
      throw ArgumentError.value(
        schemaFiles,
        "schema.files",
        "Multiple schemas are no longer supported. Use schema.file.",
      );
    }

    final outputsReader = _ConfigReader("outputs", root.map("outputs"));
    final dataClassesReader =
        _ConfigReader("data_classes", root.map("data_classes"));
    final whenExtensionsReader = _ConfigReader(
      "data_classes.when_extensions",
      dataClassesReader.map("when_extensions"),
    );
    final utilsReader = _ConfigReader(
      "data_classes.utils",
      dataClassesReader.map("utils"),
    );
    final varsReader = _ConfigReader("vars", root.map("vars"));
    final requestsReader = _ConfigReader("requests", root.map("requests"));
    final formattingReader =
        _ConfigReader("formatting", root.map("formatting"));
    final enumsReader = _ConfigReader("enums", root.map("enums"));
    final enumsFallbackReader = _ConfigReader(
      "enums.fallback",
      enumsReader.map("fallback"),
    );
    final scalarsConfig = root.map("scalars");

    final outputDirValue = schemaReader.raw("output_dir");
    final outputDir =
        outputDirValue is String ? outputDirValue : "__generated__";
    final sourceExtensionValue = schemaReader.raw("source_extension");
    final sourceExtension =
        sourceExtensionValue is String ? sourceExtensionValue : ".graphql";

    final formatValue = formattingReader.raw("enabled");
    final formatterLanguageVersionValue =
        formattingReader.raw("language_version");

    final scalarWarnings = <String>[];
    final builderConfig = BuilderConfig._(
      schemaId: _parseSchemaId(schemaFile),
      shouldAddTypenames: _readBool(
        schemaReader.raw("add_typenames"),
        true,
      ),
      shouldGeneratePossibleTypes: _readBool(
        schemaReader.raw("generate_possible_types_map"),
        true,
      ),
      typeOverrides: _getTypeOverrides(scalarsConfig, scalarWarnings),
      enumFallbackConfig: _getEnumFallbackConfig(enumsFallbackReader),
      outputDir: outputDir,
      sourceExtension: sourceExtension,
      whenExtensionConfig: _getWhenExtensionConfig(whenExtensionsReader),
      dataClassConfig: _getDataClassConfig(dataClassesReader),
      triStateOptionalsConfig: _getTriStateOptionalsConfig(
        varsReader.raw("tristate_optionals"),
      ),
      format: _readBool(formatValue, true),
      formatterLanguageVersion: _getFormatterLanguageVersion(
        formatterLanguageVersionValue,
      ),
      outputs: _getOutputsConfig(outputsReader),
      generateCopyWith: _readBool(
        utilsReader.raw("copy_with"),
        false,
      ),
      generateEquals: _readBool(
        utilsReader.raw("equals"),
        false,
      ),
      generateHashCode: _readBool(
        utilsReader.raw("hash_code"),
        false,
      ),
      generateToString: _readBool(
        utilsReader.raw("to_string"),
        false,
      ),
      generateDocs: _readBool(
        dataClassesReader.raw("docs"),
        true,
      ),
    );

    final warnings = _collectWarnings(
      [
        schemaReader,
        outputsReader,
        formattingReader,
        enumsReader,
        enumsFallbackReader,
        dataClassesReader,
        whenExtensionsReader,
        utilsReader,
        varsReader,
        requestsReader,
        root,
      ],
      extra: scalarWarnings,
    );
    for (final warning in warnings) {
      log.warning(warning);
    }

    return builderConfig;
  }

  const BuilderConfig._({
    required this.schemaId,
    required this.shouldAddTypenames,
    required this.shouldGeneratePossibleTypes,
    required this.typeOverrides,
    required this.enumFallbackConfig,
    required this.outputDir,
    required this.sourceExtension,
    required this.whenExtensionConfig,
    required this.dataClassConfig,
    required this.triStateOptionalsConfig,
    required this.format,
    required this.formatterLanguageVersion,
    required this.outputs,
    required this.generateCopyWith,
    required this.generateEquals,
    required this.generateHashCode,
    required this.generateToString,
    required this.generateDocs,
  });
}

class OutputsConfig {
  final bool ast;
  final bool data;
  final bool vars;
  final bool req;
  final bool schema;

  const OutputsConfig({
    this.ast = true,
    this.data = true,
    this.vars = true,
    this.req = true,
    this.schema = true,
  });
}

class DataClassConfig {
  final bool reuseFragments;

  const DataClassConfig({
    required this.reuseFragments,
  });
}

class InlineFragmentSpreadWhenExtensionConfig {
  final bool generateWhenExtensionMethod;
  final bool generateMaybeWhenExtensionMethod;

  const InlineFragmentSpreadWhenExtensionConfig({
    required this.generateWhenExtensionMethod,
    required this.generateMaybeWhenExtensionMethod,
  });
}

class EnumFallbackConfig {
  final bool generateFallbackValuesGlobally;
  final String globalEnumFallbackName;
  final Map<String, String> fallbackValueMap;

  const EnumFallbackConfig({
    required this.generateFallbackValuesGlobally,
    required this.globalEnumFallbackName,
    required this.fallbackValueMap,
  });
}

class TypeOverrideConfig {
  final String? type;
  final String? import;
  final String? fromJsonFunctionName;
  final String? toJsonFunctionName;

  const TypeOverrideConfig({
    this.type,
    this.import,
    this.fromJsonFunctionName,
    this.toJsonFunctionName,
  });
}

enum TriStateValueConfig { onAllNullableFields, never }

AssetId? _parseSchemaId(Object? value) {
  if (value == null) return null;
  return AssetId.parse(value as String);
}

bool _readBool(Object? value, bool defaultValue) =>
    value is bool ? value : defaultValue;

OutputsConfig _getOutputsConfig(_ConfigReader reader) {
  if (reader.isEmpty) return const OutputsConfig();
  return OutputsConfig(
    ast: _readBool(reader.raw("ast"), true),
    data: _readBool(reader.raw("data"), true),
    vars: _readBool(reader.raw("vars"), true),
    req: _readBool(reader.raw("req"), true),
    schema: _readBool(reader.raw("schema"), true),
  );
}

Version? _getFormatterLanguageVersion(Object? raw) {
  if (raw == null) return null;

  String value;
  if (raw is String) {
    value = raw.trim();
  } else if (raw is num) {
    value = raw.toString();
  } else {
    throw ArgumentError.value(
      raw,
      "formatting.language_version",
      "Expected a string or number",
    );
  }

  final normalized = _normalizeVersionString(value);
  try {
    return Version.parse(normalized);
  } catch (error) {
    throw ArgumentError.value(
      raw,
      "formatting.language_version",
      "Invalid version string",
    );
  }
}

String _normalizeVersionString(String value) {
  final trimmed = value.trim();
  final numeric = RegExp(r"^\d+(\.\d+){0,2}$");
  if (!numeric.hasMatch(trimmed)) return trimmed;
  final parts = trimmed.split(".");
  if (parts.length == 1) return "${parts[0]}.0.0";
  if (parts.length == 2) return "${parts[0]}.${parts[1]}.0";
  return trimmed;
}

DataClassConfig _getDataClassConfig(_ConfigReader reader) {
  return DataClassConfig(
    reuseFragments: _readBool(reader.raw("reuse_fragments"), true),
  );
}

InlineFragmentSpreadWhenExtensionConfig _getWhenExtensionConfig(
  _ConfigReader reader,
) {
  if (reader.isEmpty) {
    return const InlineFragmentSpreadWhenExtensionConfig(
      generateMaybeWhenExtensionMethod: false,
      generateWhenExtensionMethod: false,
    );
  }
  return InlineFragmentSpreadWhenExtensionConfig(
    generateMaybeWhenExtensionMethod:
        _readBool(reader.raw("maybe_when"), false),
    generateWhenExtensionMethod: _readBool(reader.raw("when"), false),
  );
}

EnumFallbackConfig _getEnumFallbackConfig(_ConfigReader reader) {
  if (reader.isEmpty) {
    return const EnumFallbackConfig(
      fallbackValueMap: {},
      generateFallbackValuesGlobally: false,
      globalEnumFallbackName: "gUnknownEnumValue",
    );
  }

  return EnumFallbackConfig(
    globalEnumFallbackName:
        (reader.raw("name") ?? "gUnknownEnumValue") as String,
    generateFallbackValuesGlobally: reader.raw("global") == true,
    fallbackValueMap: _enumFallbackMap(reader.raw("per_enum")),
  );
}

Map<String, String> _enumFallbackMap(Object? enumFallbacks) {
  final map = _toMap(enumFallbacks);
  return Map<String, String>.fromEntries(
    map.entries.map(
      (entry) => MapEntry(entry.key, entry.value as String),
    ),
  );
}

TriStateValueConfig _getTriStateOptionalsConfig(Object? configValue) {
  if (configValue is bool) {
    return configValue
        ? TriStateValueConfig.onAllNullableFields
        : TriStateValueConfig.never;
  }

  return TriStateValueConfig.never;
}

Map<String, TypeOverrideConfig> _getTypeOverrides(
  Map<String, dynamic> overrides,
  List<String> warnings,
) {
  if (overrides.isEmpty) return {};

  return Map<String, TypeOverrideConfig>.fromEntries(
    overrides.entries.map((entry) {
      final reader = _ConfigReader("scalars.${entry.key}", _toMap(entry.value));
      final config = TypeOverrideConfig(
        type: reader.raw("type") as String?,
        import: reader.raw("import") as String?,
        fromJsonFunctionName: reader.raw("from_json") as String?,
        toJsonFunctionName: reader.raw("to_json") as String?,
      );
      warnings.addAll(reader.unknownWarnings());
      return MapEntry(entry.key, config);
    }),
  );
}

Map<String, dynamic> _toMap(Object? value) {
  if (value == null) return {};
  if (value is YamlMap) return Map<String, dynamic>.from(value);
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

List<String> _collectWarnings(
  Iterable<_ConfigReader> readers, {
  Iterable<String> extra = const [],
}) {
  return <String>[
    for (final reader in readers) ...reader.unknownWarnings(),
    ...extra,
  ];
}

class _ConfigReader {
  final String _context;
  final Map<String, dynamic> _map;
  final Set<String> _usedKeys = {};

  _ConfigReader(this._context, Map<String, dynamic> map) : _map = map;

  bool get isEmpty => _map.isEmpty;

  Object? raw(String key) {
    _usedKeys.add(key);
    return _map[key];
  }

  Map<String, dynamic> map(String key) {
    _usedKeys.add(key);
    return _toMap(_map[key]);
  }

  List<String> unknownWarnings() {
    if (_map.isEmpty) return const [];
    final unknown = _map.keys
        .whereType<String>()
        .where((key) => !_usedKeys.contains(key))
        .toList()
      ..sort();
    if (unknown.isEmpty) return const [];
    return [
      "Unknown config option(s) at $_context: ${unknown.join(', ')}",
    ];
  }
}

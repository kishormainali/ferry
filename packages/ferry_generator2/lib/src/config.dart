import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
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
  final List<AssetId>? schemaIds;
  final bool shouldAddTypenames;
  final bool shouldGeneratePossibleTypes;
  final Map<String, TypeOverrideConfig> typeOverrides;
  final EnumFallbackConfig enumFallbackConfig;
  final String outputDir;
  final String sourceExtension;
  final InlineFragmentSpreadWhenExtensionConfig whenExtensionConfig;
  final DataClassConfig dataClassConfig;
  final TriStateValueConfig triStateOptionalsConfig;
  final DataToJsonMode dataToJsonMode;
  final bool format;
  final Version? formatterLanguageVersion;
  final OutputsConfig outputs;
  final bool generateCopyWith;
  final bool generateEquals;
  final bool generateHashCode;
  final bool generateToString;
  final bool generateDocs;

  factory BuilderConfig(Map<String, dynamic> config) {
    final schemaValue = config["schema"];
    final schemaConfig = _toMap(schemaValue);
    final schemaFile = schemaConfig["file"] ??
        schemaConfig["schema"] ??
        (schemaValue is String ? schemaValue : null);
    final schemaFiles =
        schemaConfig["files"] ?? schemaConfig["schemas"] ?? config["schemas"];

    final outputsConfig = _toMap(config["outputs"]);
    final dataClassesConfig = _toMap(config["data_classes"]);
    final legacyDataClassConfig = _toMap(config["data_class_config"]);
    final resolvedDataClassesConfig = dataClassesConfig.isNotEmpty
        ? dataClassesConfig
        : legacyDataClassConfig;
    final whenExtensionsConfig = _toMap(
      dataClassesConfig["when_extensions"] ?? config["when_extensions"],
    );
    final utilsConfig = _toMap(dataClassesConfig["utils"]);
    final varsConfig = _toMap(config["vars"]);
    final requestsConfig = _toMap(config["requests"]);
    final formattingConfig = _toMap(config["formatting"]);
    final enumsConfig = _toMap(config["enums"]);
    final enumsFallbackConfig = _toMap(enumsConfig["fallback"]);
    final scalarsConfig = _toMap(config["scalars"]);
    final legacyOverrides = _toMap(config["type_overrides"]);

    _warnUnknownKeys(config, _topLevelKeys, "options");
    if (schemaConfig.isNotEmpty) {
      _warnUnknownKeys(schemaConfig, _schemaKeys, "schema");
    }
    if (outputsConfig.isNotEmpty) {
      _warnUnknownKeys(outputsConfig, _outputsKeys, "outputs");
    }
    if (formattingConfig.isNotEmpty) {
      _warnUnknownKeys(formattingConfig, _formattingKeys, "formatting");
    }
    if (enumsConfig.isNotEmpty) {
      _warnUnknownKeys(enumsConfig, _enumsKeys, "enums");
    }
    if (enumsFallbackConfig.isNotEmpty) {
      _warnUnknownKeys(
        enumsFallbackConfig,
        _enumFallbackKeys,
        "enums.fallback",
      );
    }
    if (dataClassesConfig.isNotEmpty) {
      _warnUnknownKeys(dataClassesConfig, _dataClassesKeys, "data_classes");
    }
    if (legacyDataClassConfig.isNotEmpty) {
      _warnUnknownKeys(
        legacyDataClassConfig,
        _legacyDataClassKeys,
        "data_class_config",
      );
    }
    if (whenExtensionsConfig.isNotEmpty) {
      _warnUnknownKeys(
        whenExtensionsConfig,
        _whenExtensionsKeys,
        dataClassesConfig.isNotEmpty
            ? "data_classes.when_extensions"
            : "when_extensions",
      );
    }
    if (utilsConfig.isNotEmpty) {
      _warnUnknownKeys(utilsConfig, _dataClassUtilsKeys, "data_classes.utils");
    }
    if (varsConfig.isNotEmpty) {
      _warnUnknownKeys(varsConfig, _varsKeys, "vars");
    }
    if (requestsConfig.isNotEmpty) {
      _warnUnknownKeys(requestsConfig, _requestsKeys, "requests");
    }
    if (scalarsConfig.isNotEmpty) {
      _warnUnknownScalarOverrides(scalarsConfig, "scalars");
    }
    if (legacyOverrides.isNotEmpty) {
      _warnUnknownScalarOverrides(legacyOverrides, "type_overrides");
    }

    final outputDirValue = schemaConfig["output_dir"] ?? config["output_dir"];
    final outputDir =
        outputDirValue is String ? outputDirValue : "__generated__";
    final sourceExtensionValue =
        schemaConfig["source_extension"] ?? config["source_extension"];
    final sourceExtension =
        sourceExtensionValue is String ? sourceExtensionValue : ".graphql";

    final formatValue = formattingConfig.isNotEmpty
        ? formattingConfig["enabled"]
        : config["format"];
    final formatterLanguageVersionValue =
        formattingConfig["language_version"] ??
            formattingConfig["languageVersion"] ??
            config["formatter_language_version"] ??
            config["formatterLanguageVersion"];

    return BuilderConfig._(
      schemaId: _parseSchemaId(schemaFile),
      schemaIds: _parseSchemaIds(schemaFiles),
      shouldAddTypenames: _readBool(
        schemaConfig["add_typenames"] ?? config["add_typenames"],
        true,
      ),
      shouldGeneratePossibleTypes: _readBool(
        schemaConfig["generate_possible_types_map"] ??
            config["generate_possible_types_map"],
        true,
      ),
      typeOverrides: _getTypeOverrides(
        scalarsConfig.isNotEmpty ? scalarsConfig : legacyOverrides,
      ),
      enumFallbackConfig: _getEnumFallbackConfig(
        fallbackConfig: enumsFallbackConfig,
        legacyConfig: config,
      ),
      outputDir: outputDir,
      sourceExtension: sourceExtension,
      whenExtensionConfig: _getWhenExtensionConfig(whenExtensionsConfig),
      dataClassConfig: _getDataClassConfig(resolvedDataClassesConfig),
      triStateOptionalsConfig: _getTriStateOptionalsConfig(
        varsConfig["tristate_optionals"] ?? config["tristate_optionals"],
      ),
      dataToJsonMode: getDataToJsonModeFromConfig(
        requestsConfig["data_to_json"] ??
            requestsConfig["dataToJson"] ??
            config["data_to_json"],
      ),
      format: _readBool(formatValue, true),
      formatterLanguageVersion: _getFormatterLanguageVersion(
        formatterLanguageVersionValue,
      ),
      outputs: _getOutputsConfig(outputsConfig),
      generateCopyWith: _readBool(
        utilsConfig["copy_with"] ?? config["generate_copy_with"],
        false,
      ),
      generateEquals: _readBool(
        utilsConfig["equals"] ?? config["generate_equals"],
        false,
      ),
      generateHashCode: _readBool(
        utilsConfig["hash_code"] ?? config["generate_hash_code"],
        false,
      ),
      generateToString: _readBool(
        utilsConfig["to_string"] ?? config["generate_to_string"],
        false,
      ),
      generateDocs: _readBool(
        resolvedDataClassesConfig["docs"] ?? config["generate_docs"],
        true,
      ),
    );
  }

  const BuilderConfig._({
    required this.schemaId,
    required this.schemaIds,
    required this.shouldAddTypenames,
    required this.shouldGeneratePossibleTypes,
    required this.typeOverrides,
    required this.enumFallbackConfig,
    required this.outputDir,
    required this.sourceExtension,
    required this.whenExtensionConfig,
    required this.dataClassConfig,
    required this.triStateOptionalsConfig,
    required this.dataToJsonMode,
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

enum DataToJsonMode {
  dynamicParam,
  typeSafe;

  Reference getDataToJsonParamType(Reference dataTypeRef) => switch (this) {
        DataToJsonMode.dynamicParam => refer("dynamic"),
        DataToJsonMode.typeSafe => dataTypeRef,
      };
}

AssetId? _parseSchemaId(Object? value) {
  if (value == null) return null;
  return AssetId.parse(value as String);
}

List<AssetId>? _parseSchemaIds(Object? value) {
  if (value == null) return null;
  final list = value is YamlList ? value : (value is List ? value : null);
  if (list == null) return null;
  return list.map((entry) => AssetId.parse(entry as String)).toList();
}

bool _readBool(Object? value, bool defaultValue) =>
    value is bool ? value : defaultValue;

OutputsConfig _getOutputsConfig(Map<String, dynamic> config) {
  if (config.isEmpty) return const OutputsConfig();
  return OutputsConfig(
    ast: _readBool(config["ast"], true),
    data: _readBool(config["data"], true),
    vars: _readBool(config["vars"], true),
    req: _readBool(config["req"], true),
    schema: _readBool(config["schema"], true),
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

DataClassConfig _getDataClassConfig(Map<String, dynamic> config) {
  return DataClassConfig(
    reuseFragments: _readBool(config["reuse_fragments"], true),
  );
}

InlineFragmentSpreadWhenExtensionConfig _getWhenExtensionConfig(
  Map<String, dynamic> config,
) {
  if (config.isEmpty) {
    return const InlineFragmentSpreadWhenExtensionConfig(
      generateMaybeWhenExtensionMethod: false,
      generateWhenExtensionMethod: false,
    );
  }
  return InlineFragmentSpreadWhenExtensionConfig(
    generateMaybeWhenExtensionMethod: _readBool(
      config["maybe_when"] ?? config["maybeWhen"],
      false,
    ),
    generateWhenExtensionMethod: _readBool(config["when"], false),
  );
}

EnumFallbackConfig _getEnumFallbackConfig({
  required Map<String, dynamic> fallbackConfig,
  required Map<String, dynamic> legacyConfig,
}) {
  if (fallbackConfig.isNotEmpty) {
    return EnumFallbackConfig(
      globalEnumFallbackName:
          (fallbackConfig["name"] ?? "gUnknownEnumValue") as String,
      generateFallbackValuesGlobally: fallbackConfig["global"] == true,
      fallbackValueMap: _enumFallbackMap(
        fallbackConfig["per_enum"] ?? fallbackConfig["perEnum"],
      ),
    );
  }

  if (legacyConfig.isNotEmpty) {
    return EnumFallbackConfig(
      globalEnumFallbackName: (legacyConfig["global_enum_fallback_name"] ??
          "gUnknownEnumValue") as String,
      generateFallbackValuesGlobally:
          legacyConfig["global_enum_fallbacks"] == true,
      fallbackValueMap: _enumFallbackMap(legacyConfig["enum_fallbacks"]),
    );
  }

  return const EnumFallbackConfig(
    fallbackValueMap: {},
    generateFallbackValuesGlobally: false,
    globalEnumFallbackName: "gUnknownEnumValue",
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

DataToJsonMode getDataToJsonModeFromConfig(Object? configValue) {
  const defaultMode = DataToJsonMode.typeSafe;

  return switch (configValue) {
    "type_safe" => DataToJsonMode.typeSafe,
    "dynamic_param" => DataToJsonMode.dynamicParam,
    null => defaultMode,
    _ => throw ArgumentError.value(
        configValue,
        "data_to_json",
        "Invalid value for data_to_json, expected one of: type_safe, dynamic_param",
      ),
  };
}

Map<String, TypeOverrideConfig> _getTypeOverrides(Object? overrides) {
  final map = _toMap(overrides);
  if (map.isEmpty) return {};

  return Map<String, TypeOverrideConfig>.fromEntries(
    map.entries.map((entry) {
      final overrideConfig = _toMap(entry.value);
      return MapEntry(
        entry.key,
        TypeOverrideConfig(
          type: (overrideConfig["type"] ?? overrideConfig["name"]) as String?,
          import: overrideConfig["import"] as String?,
          fromJsonFunctionName: overrideConfig["from_json"] as String? ??
              overrideConfig["fromJson"] as String?,
          toJsonFunctionName: overrideConfig["to_json"] as String? ??
              overrideConfig["toJson"] as String?,
        ),
      );
    }),
  );
}

Map<String, dynamic> _toMap(Object? value) {
  if (value == null) return {};
  if (value is YamlMap) return Map<String, dynamic>.from(value);
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

const _topLevelKeys = {
  "schema",
  "schemas",
  "outputs",
  "formatting",
  "enums",
  "data_classes",
  "vars",
  "requests",
  "scalars",
  // Legacy
  "add_typenames",
  "generate_possible_types_map",
  "type_overrides",
  "enum_fallbacks",
  "global_enum_fallbacks",
  "global_enum_fallback_name",
  "output_dir",
  "source_extension",
  "when_extensions",
  "data_class_config",
  "tristate_optionals",
  "data_to_json",
  "format",
  "formatter_language_version",
  "formatterLanguageVersion",
  "generate_copy_with",
  "generate_equals",
  "generate_hash_code",
  "generate_to_string",
  "generate_docs",
};

const _schemaKeys = {
  "file",
  "schema",
  "files",
  "schemas",
  "add_typenames",
  "generate_possible_types_map",
  "output_dir",
  "source_extension",
};

const _outputsKeys = {"ast", "data", "vars", "req", "schema"};

const _formattingKeys = {"enabled", "language_version", "languageVersion"};

const _enumsKeys = {"fallback"};

const _enumFallbackKeys = {"global", "name", "per_enum", "perEnum"};

const _dataClassesKeys = {
  "reuse_fragments",
  "when_extensions",
  "utils",
  "docs"
};

const _legacyDataClassKeys = {"reuse_fragments"};

const _whenExtensionsKeys = {"when", "maybe_when", "maybeWhen"};

const _dataClassUtilsKeys = {"copy_with", "equals", "hash_code", "to_string"};

const _varsKeys = {"tristate_optionals"};

const _requestsKeys = {"data_to_json", "dataToJson"};

const _scalarOverrideKeys = {
  "type",
  "name",
  "import",
  "from_json",
  "fromJson",
  "to_json",
  "toJson",
};

void _warnUnknownKeys(
  Map<String, dynamic> config,
  Set<String> allowedKeys,
  String context,
) {
  if (config.isEmpty) return;
  final unknown = config.keys
      .whereType<String>()
      .where((key) => !allowedKeys.contains(key))
      .toList()
    ..sort();
  if (unknown.isEmpty) return;
  log.warning("Unknown config option(s) at $context: ${unknown.join(', ')}");
}

void _warnUnknownScalarOverrides(
  Map<String, dynamic> overrides,
  String context,
) {
  for (final entry in overrides.entries) {
    final overrideConfig = _toMap(entry.value);
    if (overrideConfig.isEmpty) continue;
    _warnUnknownKeys(
      overrideConfig,
      _scalarOverrideKeys,
      "$context.${entry.key}",
    );
  }
}

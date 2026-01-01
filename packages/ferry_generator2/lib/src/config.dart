import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:pub_semver/pub_semver.dart";
import "package:yaml/yaml.dart";

const astExtension = ".ast.gql.dart";
const dataExtension = ".data.gql.dart";
const varExtension = ".var.gql.dart";
const reqExtension = ".req.gql.dart";
const schemaExtension = ".schema.gql.dart";

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
  final bool generateDocs;

  BuilderConfig(Map<String, dynamic> config)
      : schemaId = _parseSchemaId(config["schema"]),
        schemaIds = _parseSchemaIds(config["schemas"]),
        shouldAddTypenames = _readBool(config["add_typenames"], true),
        shouldGeneratePossibleTypes =
            _readBool(config["generate_possible_types_map"], true),
        typeOverrides = _getTypeOverrides(config["type_overrides"]),
        enumFallbackConfig = _getEnumFallbackConfig(config),
        outputDir = (config["output_dir"] as String?) ?? "__generated__",
        sourceExtension = (config["source_extension"] as String?) ?? ".graphql",
        whenExtensionConfig = _getWhenExtensionConfig(config),
        dataClassConfig = _getDataClassConfig(config),
        triStateOptionalsConfig = _getTriStateOptionalsConfig(config),
        dataToJsonMode = getDataToJsonModeFromConfig(config),
        format = _readBool(config["format"], true),
        formatterLanguageVersion = _getFormatterLanguageVersion(config),
        outputs = _getOutputsConfig(config),
        generateCopyWith = _readBool(config["generate_copy_with"], false),
        generateEquals = _readBool(config["generate_equals"], true),
        generateHashCode = _readBool(config["generate_hash_code"], true),
        generateDocs = _readBool(config["generate_docs"], true);
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
  final outputs = _toMap(config["outputs"]);
  if (outputs.isEmpty) return const OutputsConfig();
  return OutputsConfig(
    ast: _readBool(outputs["ast"], true),
    data: _readBool(outputs["data"], true),
    vars: _readBool(outputs["vars"], true),
    req: _readBool(outputs["req"], true),
    schema: _readBool(outputs["schema"], true),
  );
}

Version? _getFormatterLanguageVersion(Map<String, dynamic> config) {
  final raw = config["formatter_language_version"] ??
      config["formatterLanguageVersion"];
  if (raw == null) return null;

  String value;
  if (raw is String) {
    value = raw.trim();
  } else if (raw is num) {
    value = raw.toString();
  } else {
    throw ArgumentError.value(
      raw,
      "formatter_language_version",
      "Expected a string or number",
    );
  }

  final normalized = _normalizeVersionString(value);
  try {
    return Version.parse(normalized);
  } catch (error) {
    throw ArgumentError.value(
      raw,
      "formatter_language_version",
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
  final dataClassConfig = _toMap(config["data_class_config"]);
  return DataClassConfig(
    reuseFragments: _readBool(dataClassConfig["reuse_fragments"], true),
  );
}

InlineFragmentSpreadWhenExtensionConfig _getWhenExtensionConfig(
  Map<String, dynamic> config,
) {
  final whenExtensionConfig = _toMap(config["when_extensions"]);
  if (whenExtensionConfig.isEmpty) {
    return const InlineFragmentSpreadWhenExtensionConfig(
      generateMaybeWhenExtensionMethod: false,
      generateWhenExtensionMethod: false,
    );
  }
  return InlineFragmentSpreadWhenExtensionConfig(
    generateMaybeWhenExtensionMethod:
        _readBool(whenExtensionConfig["maybeWhen"], false),
    generateWhenExtensionMethod: _readBool(whenExtensionConfig["when"], false),
  );
}

EnumFallbackConfig _getEnumFallbackConfig(Map<String, dynamic>? config) {
  if (config == null) {
    return const EnumFallbackConfig(
      fallbackValueMap: {},
      generateFallbackValuesGlobally: false,
      globalEnumFallbackName: "gUnknownEnumValue",
    );
  }

  return EnumFallbackConfig(
    globalEnumFallbackName:
        (config["global_enum_fallback_name"] ?? "gUnknownEnumValue") as String,
    generateFallbackValuesGlobally: config["global_enum_fallbacks"] == true,
    fallbackValueMap: _enumFallbackMap(config["enum_fallbacks"]),
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

TriStateValueConfig _getTriStateOptionalsConfig(Map<String, dynamic>? config) {
  final Object? configValue = config?["tristate_optionals"];

  if (configValue is bool) {
    return configValue
        ? TriStateValueConfig.onAllNullableFields
        : TriStateValueConfig.never;
  }

  return TriStateValueConfig.never;
}

DataToJsonMode getDataToJsonModeFromConfig(Map<String, dynamic>? config) {
  final Object? configValue = config?["data_to_json"];

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
          type: overrideConfig["type"] as String?,
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

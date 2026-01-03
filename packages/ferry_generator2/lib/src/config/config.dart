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
  final bool emitFormatOff;

  factory BuilderConfig(Map<String, dynamic> config) {
    final warnings = _configSchema.unknownWarnings(config);
    for (final warning in warnings) {
      log.warning(warning);
    }

    final schemaConfig = _readMap(config["schema"], "schema");
    if (config["schema"] != null && schemaConfig.isEmpty) {
      throw ArgumentError.value(
        config["schema"],
        "schema",
        "Expected a map with keys like file, add_typenames",
      );
    }

    final schemaFile = _readString(schemaConfig["file"], "schema.file");
    final schemaFiles = schemaConfig["files"];
    if (schemaFiles != null) {
      throw ArgumentError.value(
        schemaFiles,
        "schema.files",
        "Multiple schemas are no longer supported. Use schema.file.",
      );
    }

    final outputsConfig = _readMap(config["outputs"], "outputs");
    final dataClassesConfig = _readMap(config["data_classes"], "data_classes");
    final whenExtensionsConfig = _readMap(
      dataClassesConfig["when_extensions"],
      "data_classes.when_extensions",
    );
    final utilsConfig =
        _readMap(dataClassesConfig["utils"], "data_classes.utils");
    final varsConfig = _readMap(config["vars"], "vars");
    final formattingConfig = _readMap(config["formatting"], "formatting");
    final enumsConfig = _readMap(config["enums"], "enums");
    final enumsFallbackConfig =
        _readMap(enumsConfig["fallback"], "enums.fallback");
    final scalarsConfig = _readMap(config["scalars"], "scalars");

    final outputDir = _readString(
          schemaConfig["output_dir"],
          "schema.output_dir",
        ) ??
        "__generated__";
    final sourceExtension = _readString(
          schemaConfig["source_extension"],
          "schema.source_extension",
        ) ??
        ".graphql";

    final formatValue = formattingConfig["enabled"];
    final formatterLanguageVersionValue = formattingConfig["language_version"];
    final format = _readBool(formatValue, true, "formatting.enabled");
    final formatterLanguageVersion =
        _getFormatterLanguageVersion(formatterLanguageVersionValue);
    final builderConfig = BuilderConfig._(
      schemaId: _parseSchemaId(schemaFile),
      shouldAddTypenames: _readBool(
        schemaConfig["add_typenames"],
        true,
        "schema.add_typenames",
      ),
      shouldGeneratePossibleTypes: _readBool(
        schemaConfig["generate_possible_types_map"],
        true,
        "schema.generate_possible_types_map",
      ),
      typeOverrides: _getTypeOverrides(scalarsConfig),
      enumFallbackConfig: _getEnumFallbackConfig(enumsFallbackConfig),
      outputDir: outputDir,
      sourceExtension: sourceExtension,
      whenExtensionConfig: _getWhenExtensionConfig(whenExtensionsConfig),
      dataClassConfig: _getDataClassConfig(dataClassesConfig),
      triStateOptionalsConfig: _getTriStateOptionalsConfig(
        varsConfig["tristate_optionals"],
        "vars.tristate_optionals",
      ),
      format: format,
      formatterLanguageVersion: formatterLanguageVersion,
      emitFormatOff: _readBool(
        formattingConfig["emit_format_off"],
        false,
        "formatting.emit_format_off",
      ),
      outputs: _getOutputsConfig(outputsConfig),
      generateCopyWith: _readBool(
        utilsConfig["copy_with"],
        false,
        "data_classes.utils.copy_with",
      ),
      generateEquals: _readBool(
        utilsConfig["equals"],
        false,
        "data_classes.utils.equals",
      ),
      generateHashCode: _readBool(
        utilsConfig["hash_code"],
        false,
        "data_classes.utils.hash_code",
      ),
      generateToString: _readBool(
        utilsConfig["to_string"],
        false,
        "data_classes.utils.to_string",
      ),
      generateDocs: _readBool(
        dataClassesConfig["docs"],
        true,
        "data_classes.docs",
      ),
    );
    _validateOutputs(builderConfig.outputs);
    if (!format && formatterLanguageVersion != null) {
      log.warning(
        "formatting.language_version is ignored when formatting.enabled is false.",
      );
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
    required this.emitFormatOff,
  });
}

void _validateOutputs(OutputsConfig outputs) {
  if (outputs.req && !outputs.ast) {
    throw StateError("outputs.req requires outputs.ast to be true.");
  }
  if (outputs.req && !outputs.data) {
    throw StateError("outputs.req requires outputs.data to be true.");
  }
  if (outputs.req && !outputs.vars) {
    throw StateError("outputs.req requires outputs.vars to be true.");
  }
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

bool _readBool(Object? value, bool defaultValue, String path) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  throw ArgumentError.value(value, path, "Expected a boolean");
}

String? _readString(Object? value, String path) {
  if (value == null) return null;
  if (value is String) return value;
  throw ArgumentError.value(value, path, "Expected a string");
}

Map<String, dynamic> _readMap(Object? value, String path) {
  if (value == null) return {};
  if (value is YamlMap) return Map<String, dynamic>.from(value);
  if (value is Map) return Map<String, dynamic>.from(value);
  throw ArgumentError.value(value, path, "Expected a map");
}

OutputsConfig _getOutputsConfig(Map<String, dynamic> config) {
  if (config.isEmpty) return const OutputsConfig();
  return OutputsConfig(
    ast: _readBool(config["ast"], true, "outputs.ast"),
    data: _readBool(config["data"], true, "outputs.data"),
    vars: _readBool(config["vars"], true, "outputs.vars"),
    req: _readBool(config["req"], true, "outputs.req"),
    schema: _readBool(config["schema"], true, "outputs.schema"),
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
    reuseFragments: _readBool(
      config["reuse_fragments"],
      true,
      "data_classes.reuse_fragments",
    ),
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
      config["maybe_when"],
      false,
      "data_classes.when_extensions.maybe_when",
    ),
    generateWhenExtensionMethod: _readBool(
      config["when"],
      false,
      "data_classes.when_extensions.when",
    ),
  );
}

EnumFallbackConfig _getEnumFallbackConfig(Map<String, dynamic> config) {
  if (config.isEmpty) {
    return const EnumFallbackConfig(
      fallbackValueMap: {},
      generateFallbackValuesGlobally: false,
      globalEnumFallbackName: "gUnknownEnumValue",
    );
  }

  return EnumFallbackConfig(
    globalEnumFallbackName: _readString(
          config["name"],
          "enums.fallback.name",
        ) ??
        "gUnknownEnumValue",
    generateFallbackValuesGlobally:
        _readBool(config["global"], false, "enums.fallback.global"),
    fallbackValueMap: _enumFallbackMap(config["per_enum"]),
  );
}

Map<String, String> _enumFallbackMap(Object? enumFallbacks) {
  if (enumFallbacks == null) return {};
  if (enumFallbacks is! Map && enumFallbacks is! YamlMap) {
    throw ArgumentError.value(
      enumFallbacks,
      "enums.fallback.per_enum",
      "Expected a map of enum names to fallback values",
    );
  }
  final map = _toMap(enumFallbacks);
  return Map<String, String>.fromEntries(map.entries.map((entry) {
    final key = entry.key;
    final value = entry.value;
    if (value is! String) {
      throw ArgumentError.value(
        value,
        "enums.fallback.per_enum.$key",
        "Enum fallback values must be strings",
      );
    }
    return MapEntry(key, value);
  }));
}

TriStateValueConfig _getTriStateOptionalsConfig(
  Object? configValue,
  String path,
) {
  if (configValue is bool) {
    return configValue
        ? TriStateValueConfig.onAllNullableFields
        : TriStateValueConfig.never;
  }
  if (configValue != null) {
    throw ArgumentError.value(configValue, path, "Expected a boolean");
  }

  return TriStateValueConfig.never;
}

Map<String, TypeOverrideConfig> _getTypeOverrides(
  Map<String, dynamic> overrides,
) {
  if (overrides.isEmpty) return {};

  return Map<String, TypeOverrideConfig>.fromEntries(overrides.entries.map(
    (entry) {
      final key = entry.key;
      final configMap = _readMap(entry.value, "scalars.$key");
      final config = TypeOverrideConfig(
        type: _readString(configMap["type"], "scalars.$key.type"),
        import: _readString(configMap["import"], "scalars.$key.import"),
        fromJsonFunctionName:
            _readString(configMap["from_json"], "scalars.$key.from_json"),
        toJsonFunctionName:
            _readString(configMap["to_json"], "scalars.$key.to_json"),
      );
      return MapEntry(key, config);
    },
  ));
}

Map<String, dynamic> _toMap(Object? value) {
  if (value == null) return {};
  if (value is YamlMap) return Map<String, dynamic>.from(value);
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

enum _ConfigValueType { boolean, string, stringOrNumber }

sealed class _ConfigField {
  const _ConfigField();
}

class _ConfigLeaf extends _ConfigField {
  final _ConfigValueType type;

  const _ConfigLeaf(this.type);
}

class _ConfigSection extends _ConfigField {
  final _ConfigSchema schema;

  const _ConfigSection(this.schema);
}

class _ConfigMapOf extends _ConfigField {
  final String context;
  final _ConfigSchema? valueSchema;

  const _ConfigMapOf({
    required this.context,
    this.valueSchema,
  });
}

class _ConfigSchema {
  final String context;
  final Map<String, _ConfigField> fields;

  const _ConfigSchema(this.context, this.fields);

  List<String> unknownWarnings(
    Map<String, dynamic> map, {
    String? contextOverride,
  }) {
    if (map.isEmpty) return const [];
    final resolvedContext = contextOverride ?? context;
    final warnings = <String>[];
    final unknown = map.keys
        .whereType<String>()
        .where((key) => !fields.containsKey(key))
        .toList()
      ..sort();
    if (unknown.isNotEmpty) {
      warnings.add(
        "Unknown config option(s) at $resolvedContext: ${unknown.join(', ')}",
      );
    }
    for (final entry in fields.entries) {
      final value = map[entry.key];
      if (value == null) continue;
      final field = entry.value;
      switch (field) {
        case _ConfigSection(:final schema):
          warnings.addAll(schema.unknownWarnings(_toMap(value)));
        case _ConfigMapOf(:final valueSchema, :final context):
          if (valueSchema == null) continue;
          final entries = _toMap(value).entries;
          for (final entry in entries) {
            warnings.addAll(
              valueSchema.unknownWarnings(
                _toMap(entry.value),
                contextOverride: "$context.${entry.key}",
              ),
            );
          }
        case _ConfigLeaf():
          break;
      }
    }
    return warnings;
  }
}

const _schemaSchema = _ConfigSchema("schema", {
  "file": _ConfigLeaf(_ConfigValueType.string),
  "files": _ConfigLeaf(_ConfigValueType.string),
  "add_typenames": _ConfigLeaf(_ConfigValueType.boolean),
  "generate_possible_types_map": _ConfigLeaf(_ConfigValueType.boolean),
  "output_dir": _ConfigLeaf(_ConfigValueType.string),
  "source_extension": _ConfigLeaf(_ConfigValueType.string),
});

const _outputsSchema = _ConfigSchema("outputs", {
  "ast": _ConfigLeaf(_ConfigValueType.boolean),
  "data": _ConfigLeaf(_ConfigValueType.boolean),
  "vars": _ConfigLeaf(_ConfigValueType.boolean),
  "req": _ConfigLeaf(_ConfigValueType.boolean),
  "schema": _ConfigLeaf(_ConfigValueType.boolean),
});

const _whenExtensionsSchema = _ConfigSchema("data_classes.when_extensions", {
  "when": _ConfigLeaf(_ConfigValueType.boolean),
  "maybe_when": _ConfigLeaf(_ConfigValueType.boolean),
});

const _utilsSchema = _ConfigSchema("data_classes.utils", {
  "copy_with": _ConfigLeaf(_ConfigValueType.boolean),
  "equals": _ConfigLeaf(_ConfigValueType.boolean),
  "hash_code": _ConfigLeaf(_ConfigValueType.boolean),
  "to_string": _ConfigLeaf(_ConfigValueType.boolean),
});

const _dataClassesSchema = _ConfigSchema("data_classes", {
  "reuse_fragments": _ConfigLeaf(_ConfigValueType.boolean),
  "docs": _ConfigLeaf(_ConfigValueType.boolean),
  "when_extensions": _ConfigSection(_whenExtensionsSchema),
  "utils": _ConfigSection(_utilsSchema),
});

const _varsSchema = _ConfigSchema("vars", {
  "tristate_optionals": _ConfigLeaf(_ConfigValueType.boolean),
});

const _formattingSchema = _ConfigSchema("formatting", {
  "enabled": _ConfigLeaf(_ConfigValueType.boolean),
  "language_version": _ConfigLeaf(_ConfigValueType.stringOrNumber),
  "emit_format_off": _ConfigLeaf(_ConfigValueType.boolean),
});

const _enumsFallbackSchema = _ConfigSchema("enums.fallback", {
  "global": _ConfigLeaf(_ConfigValueType.boolean),
  "name": _ConfigLeaf(_ConfigValueType.string),
  "per_enum": _ConfigMapOf(context: "enums.fallback.per_enum"),
});

const _enumsSchema = _ConfigSchema("enums", {
  "fallback": _ConfigSection(_enumsFallbackSchema),
});

const _scalarSchema = _ConfigSchema("scalars.<name>", {
  "type": _ConfigLeaf(_ConfigValueType.string),
  "import": _ConfigLeaf(_ConfigValueType.string),
  "from_json": _ConfigLeaf(_ConfigValueType.string),
  "to_json": _ConfigLeaf(_ConfigValueType.string),
});

const _configSchema = _ConfigSchema("options", {
  "schema": _ConfigSection(_schemaSchema),
  "outputs": _ConfigSection(_outputsSchema),
  "data_classes": _ConfigSection(_dataClassesSchema),
  "vars": _ConfigSection(_varsSchema),
  "formatting": _ConfigSection(_formattingSchema),
  "enums": _ConfigSection(_enumsSchema),
  "scalars": _ConfigMapOf(context: "scalars", valueSchema: _scalarSchema),
});

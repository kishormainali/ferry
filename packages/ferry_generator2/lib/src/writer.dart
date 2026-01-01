import "dart:async";

import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:dart_style/dart_style.dart";

import "allocator.dart";
import "config.dart";

final _defaultFormatterVersion = DartFormatter.latestShortStyleLanguageVersion;

DartFormatter _formatterFor(BuilderConfig config) => DartFormatter(
      languageVersion:
          config.formatterLanguageVersion ?? _defaultFormatterVersion,
    );

Future<void> writeLibrary({
  required AssetId outputId,
  required Library library,
  required BuildStep buildStep,
  required BuilderConfig config,
  required GeneratorAllocator allocator,
}) {
  final emitter = DartEmitter(
    allocator: allocator,
    orderDirectives: true,
    useNullSafetySyntax: true,
  );
  final generated = library.accept(emitter).toString();
  final formatted = _formatterFor(config).format(generated);

  return buildStep.writeAsString(
    outputId,
    "// GENERATED CODE - DO NOT MODIFY BY HAND\n"
    "// ignore_for_file: type=lint\n\n"
    "${config.format ? "" : "// dart format off\n\n"}"
    "$formatted",
  );
}

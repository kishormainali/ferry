import 'package:build/build.dart';
import 'package:ferry_generator2/src/config/config.dart';
import 'package:logging/logging.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  test('formatter language version accepts x.y', () {
    final config = BuilderConfig({
      'formatting': {
        'language_version': '3.4',
      },
    });

    expect(config.formatterLanguageVersion, Version(3, 4, 0));
  });

  test('formatter language version accepts numeric', () {
    final config = BuilderConfig({
      'formatting': {
        'language_version': 3.3,
      },
    });

    expect(config.formatterLanguageVersion, Version(3, 3, 0));
  });

  test('formatter language version accepts x.y.z', () {
    final config = BuilderConfig({
      'formatting': {
        'language_version': '3.6.1',
      },
    });

    expect(config.formatterLanguageVersion, Version(3, 6, 1));
  });

  test('per-enum fallback config parses', () {
    final config = BuilderConfig({
      'enums': {
        'fallback': {
          'per_enum': {
            'Episode': 'gUnknownEpisode',
          },
        },
      },
    });

    expect(
      config.enumFallbackConfig.fallbackValueMap['Episode'],
      'gUnknownEpisode',
    );
  });

  test('warns on unknown config entries', () async {
    final records = <LogRecord>[];
    final previousLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    final subscription = log.onRecord.listen(records.add);

    BuilderConfig({
      'schema': {
        'file': 'ferry_generator2|lib/schema.graphql',
        'add_typenames': true,
        'unknown': true,
      },
      'enums': {
        'fallback': {
          'per_enum': {
            'Episode': 'gUnknownEpisode',
          },
          'extra': true,
        },
        'extra': true,
      },
      'scalars': {
        'Date': {
          'type': 'CustomDate',
          'unknown': true,
        },
      },
      'unknown_top': true,
    });

    await subscription.cancel();
    Logger.root.level = previousLevel;

    final messages = records.map((record) => record.message).join('\n');
    expect(messages, contains('options: unknown_top'));
    expect(messages, contains('schema: unknown'));
    expect(messages, contains('enums: extra'));
    expect(messages, contains('enums.fallback: extra'));
    expect(messages, contains('scalars.Date: unknown'));
  });
}

import 'package:ferry_generator2/src/config.dart';
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
}

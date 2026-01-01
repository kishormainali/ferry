import 'package:ferry_generator2/src/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  test('formatter language version accepts x.y', () {
    final config = BuilderConfig({
      'formatter_language_version': '3.4',
    });

    expect(config.formatterLanguageVersion, Version(3, 4, 0));
  });

  test('formatter language version accepts numeric', () {
    final config = BuilderConfig({
      'formatter_language_version': 3.3,
    });

    expect(config.formatterLanguageVersion, Version(3, 3, 0));
  });

  test('formatter language version accepts x.y.z', () {
    final config = BuilderConfig({
      'formatter_language_version': '3.6.1',
    });

    expect(config.formatterLanguageVersion, Version(3, 6, 1));
  });
}

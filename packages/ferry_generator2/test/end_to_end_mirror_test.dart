import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:ferry_generator2/graphql_builder.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _package = 'end_to_end_test';
const _outputDir = '__generated__';
const _dataExtension = '.data.gql.dart';
const _varExtension = '.var.gql.dart';
const _reqExtension = '.req.gql.dart';
const _schemaExtension = '.schema.gql.dart';

void main() {
  late TestReaderWriter readerWriter;

  setUpAll(() async {
    final fixtureRoot = p.join(
      Directory.current.path,
      'test',
      'fixtures',
      'end_to_end_test',
    );
    final sourceAssets = await _loadGraphqlAssets(
      fixtureRoot,
      packageName: _package,
    );

    final builder = graphqlBuilder(
      BuilderOptions({
        'schema': {
          'file': 'end_to_end_test|lib/graphql/schema.graphql',
          'add_typenames': true,
        },
        'vars': {
          'tristate_optionals': true,
        },
        'data_classes': {
          'utils': {
            'copy_with': true,
            'equals': true,
            'hash_code': true,
            'to_string': true,
          },
        },
        'scalars': {
          'Date': {
            'type': 'CustomDate',
            'import': 'package:custom/date.dart',
            'from_json': 'customDateFromJson',
            'to_json': 'customDateToJson',
          },
        },
      }),
    );

    final result = await testBuilder(
      builder,
      sourceAssets,
      rootPackage: _package,
      generateFor: sourceAssets.keys.toSet(),
    );

    readerWriter = result.readerWriter;
  });

  test('schema output includes enums, inputs, possible types, tristate',
      () async {
    final contents = await _readOutput(
      readerWriter,
      'lib/graphql/schema.graphql',
      _schemaExtension,
    );

    expect(contents, contains('enum GEpisode'));
    expect(contents, contains('class GReviewInput'));
    expect(contents, contains('Value<String>'));
    expect(
        contents, contains('const Map<String, Set<String>> possibleTypesMap'));
    expect(contents, contains("'Character'"));
    expect(contents, contains("'SearchResult'"));
    expect(contents, contains("'Human'"));
    expect(contents, contains("'Droid'"));
    expect(contents, contains("'Starship'"));
  });

  test('per-enum fallback config emits enum-specific fallback', () async {
    final fixtureRoot = p.join(
      Directory.current.path,
      'test',
      'fixtures',
      'end_to_end_test',
    );
    final sourceAssets = await _loadGraphqlAssets(
      fixtureRoot,
      packageName: _package,
    );

    final builder = graphqlBuilder(
      BuilderOptions({
        'schema': {
          'file': 'end_to_end_test|lib/graphql/schema.graphql',
          'add_typenames': true,
        },
        'enums': {
          'fallback': {
            'per_enum': {
              'Episode': 'gUnknownEpisode',
            },
          },
        },
      }),
    );

    final result = await testBuilder(
      builder,
      sourceAssets,
      rootPackage: _package,
      generateFor: sourceAssets.keys.toSet(),
    );

    final contents = await _readOutput(
      result.readerWriter,
      'lib/graphql/schema.graphql',
      _schemaExtension,
    );

    expect(contents, contains('enum GEpisode'));
    expect(contents, contains('gUnknownEpisode'));
    expect(contents, contains('default:'));
    expect(contents, contains('return GEpisode.gUnknownEpisode;'));
  });

  test('aliases use response keys and alias fields', () async {
    final contents = await _readOutput(
      readerWriter,
      'lib/aliases/aliased_hero.graphql',
      _dataExtension,
    );

    expect(contents, contains('class GAliasedHeroData'));
    expect(contents, contains('empireHero'));
    expect(contents, contains('jediHero'));
    expect(contents, contains("json['from']"));
    expect(contents, contains("result['from']"));
  });

  test('alias fragment vars and data reuse', () async {
    final vars = await _readOutput(
      readerWriter,
      'lib/aliases/alias_var_fragment.graphql',
      _varExtension,
    );
    expect(vars, contains('class GPostsVars'));
    expect(vars, contains('class GPostFragmentVars'));
    expect(_countOccurrences(vars, 'final String userId;'), 2);

    final data = await _readOutput(
      readerWriter,
      'lib/aliases/alias_var_fragment.graphql',
      _dataExtension,
    );
    expect(data, contains('class GPostFragmentData'));
    expect(data, contains('isFavorited'));
    expect(data, contains('isLiked'));
    expect(data, isNot(contains('class GPostsData_posts')));
  });

  test('no-vars operation omits vars output and uses null vars in request',
      () async {
    final varsPath = _outputPath(
      'lib/no_vars/hero_no_vars.graphql',
      _varExtension,
    );
    final varsId = AssetId(_package, varsPath);
    expect(readerWriter.testing.exists(varsId), isFalse);

    final req = await _readOutput(
      readerWriter,
      'lib/no_vars/hero_no_vars.graphql',
      _reqExtension,
    );
    expect(req, contains('GHeroNoVarsData'));
    expect(req, contains('OperationRequest'));
    expect(req, contains('Null'));
    expect(req, contains('final Null vars = null;'));
    expect(req, contains('const <String, dynamic>{}'));
  });

  test('interface selections include inline fragment variants', () async {
    final contents = await _readOutput(
      readerWriter,
      'lib/interfaces/hero_for_episode.graphql',
      _dataExtension,
    );

    expect(contents, contains('sealed class GHeroForEpisodeData_hero'));
    expect(contents, contains('class GHeroForEpisodeData_hero__asDroid'));
    expect(contents, contains('class GHeroForEpisodeData_hero__unknown'));
    expect(contents, contains('implements GDroidFragment'));
  });

  test('nested duplicate fragments reuse child fragment data', () async {
    final contents = await _readOutput(
      readerWriter,
      'lib/fragments/nested_duplicate_fragments.graphql',
      _dataExtension,
    );

    expect(contents, contains('switch (json[\'__typename\'] as String)'));
    expect(contents, contains('class GSearchResultsQueryData_search__unknown'));
    expect(contents, contains('GFriendInfoData'));
    expect(contents, isNot(contains('class GCharacterDetailsData_friends')));
  });

  test('multiple fragments merge into a single selection class', () async {
    final contents = await _readOutput(
      readerWriter,
      'lib/fragments/multiple_fragments.graphql',
      _dataExtension,
    );

    expect(contents, contains('class GHeroWith2FragmentsData_hero'));
    expect(contents, contains('final String id;'));
    expect(contents, contains('final String name;'));
  });

  test('fragment variables propagate to fragment vars', () async {
    final vars = await _readOutput(
      readerWriter,
      'lib/fragments/hero_with_fragments.graphql',
      _varExtension,
    );

    expect(_countOccurrences(vars, 'Value<int> first'), 2);
    expect(vars, contains('class GcomparisonFieldsVars'));
    expect(vars, isNot(contains('class GheroDataVars')));

    final data = await _readOutput(
      readerWriter,
      'lib/fragments/hero_with_fragments.graphql',
      _dataExtension,
    );
    expect(data, contains('class GheroDataData'));
    expect(
        data,
        isNot(contains(
            'class GcomparisonFieldsData_friendsConnection_edges_node')));
  });

  test('list variables and input objects are typed correctly', () async {
    final listVars = await _readOutput(
      readerWriter,
      'lib/variables/list_argument.graphql',
      _varExtension,
    );
    expect(listVars, contains('Value<List<int>> stars'));
    expect(listVars, contains('final _i1.GEpisode episode;'));

    final createReviewVars = await _readOutput(
      readerWriter,
      'lib/variables/create_review.graphql',
      _varExtension,
    );
    expect(createReviewVars, contains('Value<_i1.GEpisode> episode'));
    expect(createReviewVars, contains('final _i1.GReviewInput review;'));

    final createCustomVars = await _readOutput(
      readerWriter,
      'lib/variables/create_custom_field.graphql',
      _varExtension,
    );
    expect(createCustomVars, contains('final _i1.GCustomFieldInput input;'));
  });

  test('custom scalar overrides appear in vars and data', () async {
    final vars = await _readOutput(
      readerWriter,
      'lib/scalars/review_with_date.graphql',
      _varExtension,
    );
    expect(vars, contains('Value<CustomDate> createdAt'));

    final data = await _readOutput(
      readerWriter,
      'lib/scalars/review_with_date.graphql',
      _dataExtension,
    );
    expect(data, contains('CustomDate'));
    expect(data, contains('customDateFromJson'));
    expect(data, contains('customDateToJson'));
  });

  test('request classes expose execRequest and parseData', () async {
    final req = await _readOutput(
      readerWriter,
      'lib/no_vars/hero_no_vars.graphql',
      _reqExtension,
    );
    expect(req, contains('class GHeroNoVarsReq'));
    expect(req, contains('Request get execRequest'));
    expect(req, contains('parseData'));
  });

  test('data classes include copyWith and overrides', () async {
    final contents = await _readOutput(
      readerWriter,
      'lib/interfaces/hero_for_episode.graphql',
      _dataExtension,
    );

    expect(contents, contains('copyWith'));
    expect(contents, contains('operator =='));
    expect(contents, contains('hashCode'));
    expect(contents, contains('toString'));
  });

  test('data classes omit utilities when disabled', () async {
    final fixtureRoot = p.join(
      Directory.current.path,
      'test',
      'fixtures',
      'end_to_end_test',
    );
    final sourceAssets = await _loadGraphqlAssets(
      fixtureRoot,
      packageName: _package,
    );

    final builder = graphqlBuilder(
      BuilderOptions({
        'schema': {
          'file': 'end_to_end_test|lib/graphql/schema.graphql',
          'add_typenames': true,
        },
        'vars': {
          'tristate_optionals': true,
        },
        'data_classes': {
          'utils': {
            'copy_with': false,
            'equals': false,
            'hash_code': false,
            'to_string': false,
          },
        },
      }),
    );

    final result = await testBuilder(
      builder,
      sourceAssets,
      rootPackage: _package,
      generateFor: {
        'end_to_end_test|lib/interfaces/hero_for_episode.graphql',
      },
    );

    final contents = await _readOutput(
      result.readerWriter,
      'lib/interfaces/hero_for_episode.graphql',
      _dataExtension,
    );

    expect(contents, isNot(contains('copyWith')));
    expect(contents, isNot(contains('operator ==')));
    expect(contents, isNot(contains('hashCode')));
    expect(contents, isNot(contains('toString')));
  });
}

Future<Map<String, Object>> _loadGraphqlAssets(
  String fixtureRoot, {
  required String packageName,
}) async {
  final assets = <String, Object>{};
  final libRoot = Directory(p.join(fixtureRoot, 'lib'));
  if (!await libRoot.exists()) {
    throw StateError('Missing fixture lib directory at ${libRoot.path}');
  }

  await for (final entity
      in libRoot.list(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.graphql')) {
      continue;
    }
    final relativePath = p.relative(entity.path, from: fixtureRoot);
    final assetPath = p.posix.joinAll(p.split(relativePath));
    assets['$packageName|$assetPath'] = await entity.readAsString();
  }

  if (assets.isEmpty) {
    throw StateError('No fixture GraphQL files found in $fixtureRoot');
  }

  return assets;
}

Future<String> _readOutput(
  TestReaderWriter readerWriter,
  String inputPath,
  String extension,
) {
  final outputPath = _outputPath(inputPath, extension);
  return readerWriter.readAsString(AssetId(_package, outputPath));
}

String _outputPath(String inputPath, String extension) {
  final dir = p.posix.dirname(inputPath);
  final fileName = p.posix.basenameWithoutExtension(inputPath);
  final generatedPath = p.posix.join(dir, _outputDir, '$fileName$extension');
  return p.posix.join(
    '.dart_tool',
    'build',
    'generated',
    _package,
    generatedPath,
  );
}

int _countOccurrences(String haystack, String needle) {
  var count = 0;
  var index = 0;
  while (true) {
    index = haystack.indexOf(needle, index);
    if (index == -1) {
      return count;
    }
    count++;
    index += needle.length;
  }
}

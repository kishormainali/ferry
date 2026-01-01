import 'dart:io';

import 'package:ferry_generator2_end_to_end/aliases/__generated__/alias_var_fragment.data.gql.dart';
import 'package:ferry_generator2_end_to_end/custom/date.dart';
import 'package:ferry_generator2_end_to_end/directives/__generated__/create_review_with_directives.req.gql.dart';
import 'package:ferry_generator2_end_to_end/directives/__generated__/create_review_with_directives.var.gql.dart';
import 'package:ferry_generator2_end_to_end/directives/__generated__/human_with_directives.data.gql.dart';
import 'package:ferry_generator2_end_to_end/directives/__generated__/human_with_directives.req.gql.dart';
import 'package:ferry_generator2_end_to_end/directives/__generated__/human_with_directives.var.gql.dart';
import 'package:ferry_generator2_end_to_end/fragments/__generated__/fragment_with_scalar_var.var.gql.dart';
import 'package:ferry_generator2_end_to_end/fragments/__generated__/hero_with_interface_subtyped_fragments.data.gql.dart';
import 'package:ferry_generator2_end_to_end/fragments/__generated__/nested_duplicate_fragments.data.gql.dart';
import 'package:ferry_generator2_end_to_end/fragments/__generated__/shared_fragment_queries.data.gql.dart';
import 'package:ferry_generator2_end_to_end/interfaces/__generated__/hero_for_episode.data.gql.dart';
import 'package:ferry_generator2_end_to_end/interfaces/__generated__/hero_for_episode.req.gql.dart';
import 'package:ferry_generator2_end_to_end/interfaces/__generated__/hero_for_episode.var.gql.dart';
import 'package:ferry_generator2_end_to_end/issue_610/__generated__/books.data.gql.dart';
import 'package:ferry_generator2_end_to_end/no_vars/__generated__/hero_no_vars.req.gql.dart';
import 'package:ferry_generator2_end_to_end/subscriptions/__generated__/review_added.data.gql.dart';
import 'package:ferry_generator2_end_to_end/subscriptions/__generated__/review_added.req.gql.dart';
import 'package:ferry_generator2_end_to_end/subscriptions/__generated__/review_added.var.gql.dart';
import 'package:ferry_generator2_end_to_end/scalars/__generated__/review_with_date.var.gql.dart';
import 'package:ferry_generator2_end_to_end/scalars/__generated__/review_with_date.req.gql.dart';
import 'package:ferry_generator2_end_to_end/scalars/__generated__/review_with_date.data.gql.dart';
import 'package:ferry_generator2_end_to_end/variables/__generated__/create_custom_field.data.gql.dart';
import 'package:ferry_generator2_end_to_end/variables/__generated__/create_custom_field.var.gql.dart';
import 'package:ferry_generator2_end_to_end/variables/__generated__/create_review.data.gql.dart';
import 'package:ferry_generator2_end_to_end/variables/__generated__/create_review.req.gql.dart';
import 'package:ferry_generator2_end_to_end/variables/__generated__/create_review.var.gql.dart';
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _schema;
import 'package:gql_tristate_value/gql_tristate_value.dart';
import 'package:test/test.dart';

void main() {
  test('issue 610 generated classes stay scoped', () async {
    final file = File('lib/issue_610/__generated__/books.data.gql.dart');
    final contents = await file.readAsString();

    expect(contents, contains('class GAuthorFragmentData__asPerson'));
    expect(contents, contains('class GAuthorFragmentData__asCompany'));
    expect(contents, contains('class GBookFragmentData__asTextbook'));
    expect(contents, contains('class GBookFragmentData__asColoringBook'));
    expect(contents, isNot(contains('GBookFragmentData__asPerson')));
    expect(contents, isNot(contains('GBookFragmentData__asCompany')));
    expect(contents, isNot(contains('class GBookFragmentData_author')));
    expect(contents, contains('GAuthorFragmentData'));
  });

  test('shared fragments reuse data classes across operations', () async {
    final file = File(
      'lib/fragments/__generated__/shared_fragment_queries.data.gql.dart',
    );
    final contents = await file.readAsString();

    expect(contents, contains('class GSharedBookFragmentData'));
    expect(contents, contains('class GSharedBooksAData'));
    expect(contents, contains('class GSharedBooksBData'));
    expect(contents, isNot(contains('class GSharedBooksAData_books')));
    expect(contents, isNot(contains('class GSharedBooksBData_books')));
  });

  test('interface fragments generate typed nested selections', () {
    final data = GHeroWithInterfaceSubTypedFragmentsData.fromJson({
      '__typename': 'Query',
      'hero': {
        '__typename': 'Human',
        'id': '1000',
        'name': 'Luke',
        'homePlanet': 'Tatooine',
        'friends': [
          {
            '__typename': 'Droid',
            'id': '2000',
            'name': 'R2-D2',
            'primaryFunction': 'Astromech',
          },
          {
            '__typename': 'Human',
            'id': '1001',
            'name': 'Han',
            'homePlanet': null,
          },
        ],
      },
    });

    final hero = data.hero;
    expect(hero, isA<GheroFieldsFragmentData__asHuman>());

    final friends = (hero as GheroFieldsFragmentData__asHuman).friends!;
    expect(friends, hasLength(2));
    expect(
      friends.first!,
      isA<GheroFieldsFragmentData__asHuman_friends__asDroid>(),
    );
    expect(
      friends.last!,
      isA<GheroFieldsFragmentData__asHuman_friends__asHuman>(),
    );
    expect(
      friends.first!,
      isA<GheroFieldsFragment__asHuman_friends>(),
    );
  });

  test('unknown fallback handles unexpected union members', () {
    final data = GSearchResultsQueryData.fromJson({
      '__typename': 'Query',
      'search': [
        {'__typename': 'Starship'},
      ],
    });

    final result = data.search!.first!;
    expect(result, isA<GSearchResultsQueryData_search__unknown>());
    expect(result.G__typename, 'Starship');
  });

  test('nested fragments round-trip through JSON', () {
    final input = {
      '__typename': 'Query',
      'search': [
        {
          '__typename': 'Human',
          'id': '1000',
          'name': 'Luke',
          'appearsIn': ['NEWHOPE'],
          'friends': [
            {
              '__typename': 'Human',
              'id': '1001',
              'name': 'Leia',
              'friendsConnection': {
                '__typename': 'FriendsConnection',
                'friends': [
                  {
                    '__typename': 'Human',
                    'id': '1002',
                    'name': 'Han',
                  },
                ],
              },
            },
          ],
        },
      ],
    };

    final data = GSearchResultsQueryData.fromJson(input);
    expect(data.toJson(), equals(input));
  });

  test('hero_for_episode data round-trips through JSON', () {
    final input = {
      '__typename': 'Query',
      'hero': {
        '__typename': 'Droid',
        'name': 'R2-D2',
        'friends': [
          {
            '__typename': 'Human',
            'name': 'Luke',
          },
        ],
        'primaryFunction': 'Astromech',
      },
    };

    final data = GHeroForEpisodeData.fromJson(input);
    expect(data.toJson(), equals(input));
  });

  test('fragment reuse keeps selection types compact', () {
    final data = GPostsData.fromJson({
      '__typename': 'Query',
      'posts': [
        {
          '__typename': 'Post',
          'id': 'post-1',
          'isFavorited': {
            '__typename': 'PostLikes',
            'totalCount': 2,
          },
          'isLiked': {
            '__typename': 'PostFavorites',
            'totalCount': 1,
          },
        },
      ],
    });

    final fragment = data.posts!.first!;
    expect(fragment, isA<GPostFragmentData>());
    expect(fragment.isFavorited?.totalCount, 2);
    expect(fragment.isLiked?.totalCount, 1);
  });

  test('issue 610 fragments stay scoped to author selections', () {
    final input = {
      '__typename': 'Query',
      'books': [
        {
          '__typename': 'Textbook',
          'title': 'GraphQL 101',
          'courses': ['Intro'],
          'author': {
            '__typename': 'Person',
            'displayName': 'Ada Lovelace',
            'firstName': 'Ada',
            'lastName': 'Lovelace',
          },
        },
      ],
    };
    final data = GGetBooksData.fromJson(input);
    expect(data.toJson(), equals(input));

    final book = data.books.first;
    expect(book, isA<GBookFragmentData__asTextbook>());
    expect(book.author, isA<GAuthorFragmentData__asPerson>());

    final author = book.author as GAuthorFragmentData__asPerson;
    expect(author.displayName, 'Ada Lovelace');
    expect(author.firstName, 'Ada');
    expect(author.lastName, 'Lovelace');
  });

  test('shared fragment reuse across operations', () {
    final input = {
      '__typename': 'Query',
      'books': [
        {
          '__typename': 'Textbook',
          'title': 'GraphQL 101',
          'courses': ['Intro'],
          'author': {
            '__typename': 'Person',
            'displayName': 'Ada Lovelace',
            'firstName': 'Ada',
            'lastName': 'Lovelace',
          },
        },
      ],
    };

    final first = GSharedBooksAData.fromJson(input);
    final second = GSharedBooksBData.fromJson(input);
    expect(first.books.first, isA<GSharedBookFragmentData>());
    expect(second.books.first, isA<GSharedBookFragmentData>());
    expect(first.toJson(), equals(input));
    expect(second.toJson(), equals(input));
  });

  test('create review mutation round-trips and vars serialize', () {
    final input = {
      '__typename': 'Mutation',
      'createReview': {
        '__typename': 'Review',
        'episode': 'JEDI',
        'stars': 5,
        'commentary': 'Great',
      },
    };

    final data = GCreateReviewData.fromJson(input);
    expect(data.toJson(), equals(input));

    final vars = GCreateReviewVars(
      episode: Value.present(_schema.GEpisode.JEDI),
      review: _schema.GReviewInput(
        stars: 5,
        commentary: Value.present('Great'),
      ),
    );
    final varsJson = vars.toJson();
    expect(
        varsJson,
        equals({
          'episode': 'JEDI',
          'review': {'stars': 5, 'commentary': 'Great'}
        }));
    expect(GCreateReviewVars.fromJson(varsJson).toJson(), equals(varsJson));

    final req = GCreateReviewReq(vars: vars);
    expect(req.execRequest.variables, equals(varsJson));
    expect(req.dataToJson(GCreateReviewData.fromJson(input)), equals(input));
  });

  test('review input omits absent optional fields', () {
    final input = _schema.GReviewInput(stars: 4);
    expect(input.toJson(), equals({'stars': 4}));
  });

  test('review added subscription round-trips and vars serialize', () {
    final input = {
      '__typename': 'Subscription',
      'reviewAdded': {
        '__typename': 'Review',
        'episode': 'EMPIRE',
        'stars': 4,
        'commentary': 'Nice',
      },
    };

    final data = GReviewAddedData.fromJson(input);
    expect(data.toJson(), equals(input));

    final vars = GReviewAddedVars(episode: _schema.GEpisode.EMPIRE);
    final varsJson = vars.toJson();
    expect(varsJson, equals({'episode': 'EMPIRE'}));
    expect(GReviewAddedVars.fromJson(varsJson).toJson(), equals(varsJson));

    final req = GReviewAddedReq(vars: vars);
    expect(req.execRequest.variables, equals(varsJson));
    expect(req.dataToJson(GReviewAddedData.fromJson(input)), equals(input));
  });

  test('operation request parseData and vars serialize', () {
    final request = GHeroNoVarsReq();
    expect(request.vars, isNull);
    expect(request.varsToJson(), equals(<String, dynamic>{}));
    expect(request.execRequest.variables, equals(<String, dynamic>{}));

    final input = {
      '__typename': 'Query',
      'hero': {
        '__typename': 'Droid',
        'id': '2001',
        'name': 'R2-D2',
      },
    };
    final parsed = request.parseData(input)!;
    expect(request.dataToJson(parsed), equals(input));
  });

  test('operation vars round-trip and execRequest variables', () {
    final vars = GHeroForEpisodeVars(ep: _schema.GEpisode.EMPIRE);
    final request = GHeroForEpisodeReq(vars: vars);

    final json = vars.toJson();
    expect(json, equals({'ep': 'EMPIRE'}));
    expect(GHeroForEpisodeVars.fromJson(json).toJson(), equals(json));
    expect(request.execRequest.variables, equals(json));
  });

  test('directive vars serialize and include input objects', () {
    final json = {
      'episode': 'JEDI',
      'review': {'stars': 5},
      'includeReview': true,
      'skipCommentary': false,
    };
    final vars = GCreateReviewWithDirectivesVars.fromJson(json);
    expect(vars.toJson(), equals(json));

    final req = GCreateReviewWithDirectivesReq(vars: vars);
    expect(req.execRequest.variables, equals(json));
  });

  test('human directives vars round-trip in requests', () {
    final json = {'includeName': true, 'skipId': false};
    final vars = GHumanWithDirectivesVars.fromJson(json);
    expect(vars.toJson(), equals(json));

    final req = GHumanWithDirectivesReq(vars: vars);
    expect(req.execRequest.variables, equals(json));
  });

  test('when and maybeWhen dispatch by typename', () {
    final data = GHeroForEpisodeData.fromJson({
      '__typename': 'Query',
      'hero': {
        '__typename': 'Droid',
        'name': 'R2-D2',
        'friends': [],
        'primaryFunction': 'Astromech',
      },
    });

    final hero = data.hero!;
    final selected = hero.when<String>(
      droid: (droid) => droid.primaryFunction ?? 'unknown',
      orElse: () => 'other',
    );
    expect(selected, 'Astromech');

    final maybe = hero.maybeWhen<String>(
      droid: null,
      orElse: () => 'fallback',
    );
    expect(maybe, 'fallback');
  });

  test('custom scalar overrides serialize via helpers', () {
    final vars = GReviewWithDateVars(
      episode: Value.present(_schema.GEpisode.JEDI),
      review: const _schema.GReviewInput(stars: 5),
      createdAt: Value.present(CustomDate(DateTime.utc(2020, 1, 1))),
    );

    final json = vars.toJson();
    expect(json['episode'], 'JEDI');
    expect(json['createdAt'], '2020-01-01T00:00:00.000Z');
  });

  test('vars deserialize and serialize with custom scalars', () {
    final input = {
      'episode': 'JEDI',
      'review': {
        'stars': 4,
      },
      'createdAt': '2020-01-02T03:04:05.000Z',
    };

    final vars = GReviewWithDateVars.fromJson(input);
    expect(vars.toJson(), equals(input));
  });

  test('scalar overrides map CustomField to String', () {
    final data = GCreateCustomFieldData.fromJson({
      '__typename': 'Mutation',
      'createCustomField': 'payload-1',
    });
    expect(data.createCustomField, 'payload-1');
    expect(
        data.toJson(),
        equals({
          '__typename': 'Mutation',
          'createCustomField': 'payload-1',
        }));

    final vars = GCreateCustomFieldVars(
      input: _schema.GCustomFieldInput(
        id: 'custom-1',
        customField: Value.present('custom-1'),
      ),
    );
    final varsJson = vars.toJson();
    expect(
      varsJson,
      equals({
        'input': {
          'id': 'custom-1',
          'customField': 'custom-1',
        },
      }),
    );
    expect(
        GCreateCustomFieldVars.fromJson(varsJson).toJson(), equals(varsJson));
  });

  test('scalar overrides map Json to Map<String, dynamic>', () {
    final vars = GPostsWithFixedVariableVars(
      filter: Value.present({
        'premium': true,
        'tags': ['starter', 'beta'],
      }),
    );

    expect(vars.filter, isA<Value<Map<String, dynamic>>>());

    final varsJson = vars.toJson();
    expect(
      varsJson,
      equals({
        'filter': {
          'premium': true,
          'tags': ['starter', 'beta'],
        },
      }),
    );

    final parsed = GPostsWithFixedVariableVars.fromJson(varsJson);
    expect(parsed.filter.isPresent, isTrue);
    expect(
      parsed.filter.requireValue,
      equals({
        'premium': true,
        'tags': ['starter', 'beta'],
      }),
    );
  });

  test('review_with_date mutation round-trips and req serialize', () {
    final input = {
      '__typename': 'Mutation',
      'createReview': {
        '__typename': 'Review',
        'episode': 'JEDI',
        'stars': 5,
        'commentary': 'Nice',
        'createdAt': '2020-01-02T03:04:05.000Z',
        'seenOn': ['2020-01-01T00:00:00.000Z'],
        'custom': ['foo'],
      },
    };

    final data = GReviewWithDateData.fromJson(input);
    expect(data.toJson(), equals(input));

    final vars = GReviewWithDateVars.fromJson({
      'episode': 'JEDI',
      'review': {'stars': 5},
      'createdAt': '2020-01-02T03:04:05.000Z',
    });
    final req = GReviewWithDateReq(vars: vars);
    expect(req.execRequest.variables, equals(vars.toJson()));
    expect(req.dataToJson(data), equals(input));
  });

  test('enum fallback returns global unknown value', () {
    expect(
      _schema.GEpisode.fromJson('SURPRISE'),
      _schema.GEpisode.gUnknownEnumValue,
    );
  });

  test('absent optional vars are omitted from JSON', () {
    final vars = GReviewWithDateVars(
      review: const _schema.GReviewInput(stars: 3),
    );

    final json = vars.toJson();
    expect(json.containsKey('episode'), isFalse);
    expect(json.containsKey('createdAt'), isFalse);
    expect(json['review'], isA<Map<String, dynamic>>());
  });

  test('conditional directives allow nullable fields', () {
    final data = GHumanWithDirectivesData.fromJson({
      '__typename': 'Query',
      'human': {
        '__typename': 'Human',
      },
    });

    final human = data.human!;
    expect(human.id, isNull);
    expect(human.name, isNull);
  });
}

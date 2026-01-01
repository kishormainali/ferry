@TestOn('vm')

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:ferry_generator2/graphql_builder.dart';
import 'package:test/test.dart';

const _package = 'ferry_generator2';
const _schemaPath = '$_package|lib/schema.graphql';
const _queryPath = '$_package|lib/queries.graphql';
const _dataPath =
    '.dart_tool/build/generated/$_package/lib/__generated__/queries.data.gql.dart';

const _schema = r'''
schema {
  query: Query
}

type Result {
  result: String
}

type Query {
  result: Result!
}
''';

const _query = r'''
query ResultQuery {
  result {
    result
  }
}
''';

void main() {
  test('prefixes local vars to avoid result field collisions', () async {
    final assets = <String, String>{
      _schemaPath: _schema,
      _queryPath: _query,
    };

    final builder = graphqlBuilder(
      BuilderOptions({
        'schema': {
          'file': _schemaPath,
        },
      }),
    );

    final result = await testBuilder(
      builder,
      assets,
      rootPackage: _package,
      generateFor: {_queryPath},
    );

    expect(result.succeeded, isTrue);
    final data = await result.readerWriter.readAsString(
      AssetId(_package, _dataPath),
    );
    expect(data, contains(r'final _$result ='));
    expect(data, contains(r'final _$resultValue = this.result;'));
  });
}

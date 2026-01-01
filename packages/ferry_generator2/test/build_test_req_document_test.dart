@TestOn('vm')

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:ferry_generator2/graphql_builder.dart';
import 'package:test/test.dart';

const _package = 'ferry_generator2';
const _schemaPath = '$_package|lib/schema.graphql';
const _queryPath = '$_package|lib/queries.graphql';
const _reqPath =
    '.dart_tool/build/generated/$_package/lib/__generated__/queries.req.gql.dart';

const _schema = r'''
schema {
  query: Query
}

type Author {
  name: String!
}

type Book {
  title: String!
  author: Author!
}

type Query {
  books: [Book!]!
}
''';

const _document = r'''
fragment TitleFields on Book {
  title
}

fragment AuthorFields on Author {
  name
}

fragment TitleWithAuthor on Book {
  ...TitleFields
  author {
    ...AuthorFields
  }
}

query BooksA {
  books {
    ...TitleFields
  }
}

query BooksB {
  books {
    ...TitleWithAuthor
  }
}
''';

void main() {
  test('request documents include only needed definitions', () async {
    final assets = <String, String>{
      _schemaPath: _schema,
      _queryPath: _document,
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
    final reqContents = await result.readerWriter.readAsString(
      AssetId(_package, _reqPath),
    );

    final booksABlock = _classBlock(reqContents, 'GBooksAReq');
    expect(booksABlock, contains('BooksA'));
    expect(booksABlock, contains('TitleFields'));
    expect(booksABlock, isNot(contains('BooksB')));
    expect(booksABlock, isNot(contains('AuthorFields')));
    expect(booksABlock, isNot(contains('TitleWithAuthor')));

    final booksBBlock = _classBlock(reqContents, 'GBooksBReq');
    expect(booksBBlock, contains('BooksB'));
    expect(booksBBlock, contains('TitleWithAuthor'));
    expect(booksBBlock, contains('TitleFields'));
    expect(booksBBlock, contains('AuthorFields'));
    expect(booksBBlock, isNot(contains('BooksA')));
  });
}

String _classBlock(String contents, String className) {
  final start = contents.indexOf('class $className');
  if (start == -1) {
    throw StateError('Missing class $className in request output');
  }
  final next = contents.indexOf('class G', start + 1);
  final end = next == -1 ? contents.length : next;
  return contents.substring(start, end);
}

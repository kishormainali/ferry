@TestOn('vm')

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:ferry_generator2/graphql_builder.dart';
import 'package:test/test.dart';

const _package = 'ferry_generator2';
const _schemaPath = '$_package|lib/schema.graphql';
const _fragmentPath = '$_package|lib/fragments.graphql';
const _queryPath = '$_package|lib/queries.graphql';

const _fragmentDataPath =
    '$_package|lib/__generated__/fragments.data.gql.dart';
const _queryVarPath = '$_package|lib/__generated__/queries.var.gql.dart';
const _queryReqPath = '$_package|lib/__generated__/queries.req.gql.dart';

const _schema = r'''
schema {
  query: Query
}

interface Author {
  displayName: String!
}

type Person implements Author {
  displayName: String!
  firstName: String!
  lastName: String!
}

type Company implements Author {
  displayName: String!
  name: String!
}

interface Book {
  title: String!
  author: Author!
}

type Textbook implements Book {
  title: String!
  author: Author!
  courses: [String!]!
}

type ColoringBook implements Book {
  title: String!
  author: Author!
  colors: [String!]!
}

input BookFilter {
  author: String
  tagIds: [ID!]
}

type Query {
  books: [Book!]!
  book(id: ID, filter: BookFilter): Book
}
''';

const _fragments = r'''
fragment AuthorFragment on Author {
  displayName
  ... on Person {
    firstName
    lastName
  }
  ... on Company {
    name
  }
}

fragment BookFragment on Book {
  author {
    ...AuthorFragment
  }
  title
  ... on Textbook {
    courses
  }
  ... on ColoringBook {
    colors
  }
}
''';

const _queries = r'''
#import "fragments.graphql"

query Books {
  books {
    ...BookFragment
  }
}

query BookById($id: ID, $filter: BookFilter) {
  book(id: $id, filter: $filter) {
    ...BookFragment
  }
}
''';

class _Scenario {
  final String name;
  final Map<String, Object?> config;
  final bool expectTristate;
  final bool expectWhenExtensions;

  const _Scenario({
    required this.name,
    required this.config,
    required this.expectTristate,
    required this.expectWhenExtensions,
  });
}

class _ResolvedLibraries {
  final LibraryElement fragmentsData;
  final LibraryElement vars;
  final LibraryElement req;

  const _ResolvedLibraries({
    required this.fragmentsData,
    required this.vars,
    required this.req,
  });
}

void main() {
  final baseConfig = <String, Object?>{
    'schema': _schemaPath,
    'add_typenames': true,
  };

  final scenarios = <_Scenario>[
    _Scenario(
      name: 'tristate + when + type_safe',
      config: {
        ...baseConfig,
        'tristate_optionals': true,
        'data_to_json': 'type_safe',
        'when_extensions': {
          'when': true,
          'maybeWhen': true,
        },
      },
      expectTristate: true,
      expectWhenExtensions: true,
    ),
    _Scenario(
      name: 'no tristate + no when + type_safe',
      config: {
        ...baseConfig,
        'tristate_optionals': false,
        'data_to_json': 'type_safe',
      },
      expectTristate: false,
      expectWhenExtensions: false,
    ),
  ];

  for (final scenario in scenarios) {
    test('analysis: ${scenario.name}', () async {
      final sources = await _runBuilder(scenario.config);
      final resolved = await _resolveGeneratedLibraries(sources);

      await _expectNoErrors(resolved.fragmentsData);
      await _expectNoErrors(resolved.vars);
      await _expectNoErrors(resolved.req);

      _expectIssue610Typing(resolved.fragmentsData);
      _expectWhenExtensions(
        resolved.fragmentsData,
        expectWhenExtensions: scenario.expectWhenExtensions,
      );
      _expectVarTypes(
        resolved.vars,
        expectTristate: scenario.expectTristate,
      );
      _expectReqGenerics(resolved.req);
      _expectDataToJsonSignature(resolved.req);
    });
  }
}

Future<Map<String, String>> _runBuilder(Map<String, Object?> config) async {
  final sourceAssets = <String, String>{
    _schemaPath: _schema,
    _fragmentPath: _fragments,
    _queryPath: _queries,
  };

  final builder = graphqlBuilder(BuilderOptions(config.cast<String, dynamic>()));

  final result = await testBuilder(
    builder,
    sourceAssets,
    rootPackage: _package,
    generateFor: {
      _schemaPath,
      _fragmentPath,
      _queryPath,
    },
  );

  return _extractGeneratedDartSources(result.readerWriter, _package);
}

Map<String, String> _extractGeneratedDartSources(
  TestReaderWriter readerWriter,
  String package,
) {
  final outputs = <String, String>{};
  final prefix = '.dart_tool/build/generated/$package/';
  for (final asset in readerWriter.testing.assets) {
    if (!asset.path.startsWith(prefix) || !asset.path.endsWith('.dart')) {
      continue;
    }
    final logicalPath = asset.path.substring(prefix.length);
    final logicalId = AssetId(package, logicalPath);
    outputs[logicalId.toString()] = readerWriter.testing.readString(asset);
  }

  if (outputs.isEmpty) {
    throw StateError('No generated Dart outputs found.');
  }

  return outputs;
}

Future<_ResolvedLibraries> _resolveGeneratedLibraries(
  Map<String, String> sources,
) async {
  return resolveSources(
    sources,
    (resolver) async {
      final fragmentsData = await resolver.libraryFor(
        AssetId.parse(_fragmentDataPath),
      );
      final vars = await resolver.libraryFor(AssetId.parse(_queryVarPath));
      final req = await resolver.libraryFor(AssetId.parse(_queryReqPath));
      return _ResolvedLibraries(
        fragmentsData: fragmentsData,
        vars: vars,
        req: req,
      );
    },
    rootPackage: _package,
    readAllSourcesFromFilesystem: true,
  );
}

Future<void> _expectNoErrors(LibraryElement library) async {
  final sourcePath = library.firstFragment.source.fullName;
  final result = await library.session.getErrors(sourcePath);
  if (result is ErrorsResult) {
    final errors =
        result.diagnostics
            .where(
              (diagnostic) =>
                  diagnostic.diagnosticCode.severity ==
                  DiagnosticSeverity.ERROR,
            )
            .toList();
    expect(errors, isEmpty, reason: errors.join('\n'));
  }
}

void _expectIssue610Typing(LibraryElement library) {
  final classNames = library.classes.map((element) => element.name).toSet();
  expect(classNames.contains('GBookFragmentData__asPerson'), isFalse);
  expect(classNames.contains('GBookFragmentData__asCompany'), isFalse);

  final authorBase = _classByName(library, 'GAuthorFragmentData');
  expect(authorBase.isSealed, isTrue);

  final authorPerson = _classByName(library, 'GAuthorFragmentData__asPerson');
  expect(authorPerson.supertype?.element.name, 'GAuthorFragmentData');

  final authorCompany = _classByName(library, 'GAuthorFragmentData__asCompany');
  expect(authorCompany.supertype?.element.name, 'GAuthorFragmentData');

  final authorUnknown = _classByName(library, 'GAuthorFragmentData__unknown');
  expect(authorUnknown.supertype?.element.name, 'GAuthorFragmentData');

  final bookBase = _classByName(library, 'GBookFragmentData');
  expect(bookBase.isSealed, isTrue);

  final authorField = bookBase.getField('author');
  expect(authorField, isNotNull);
  _expectInterfaceType(
    authorField!.type,
    name: 'GAuthorFragmentData',
    nullable: false,
  );

  final bookUnknown = _classByName(library, 'GBookFragmentData__unknown');
  expect(bookUnknown.supertype?.element.name, 'GBookFragmentData');
}

void _expectWhenExtensions(
  LibraryElement library, {
  required bool expectWhenExtensions,
}) {
  final extensionNames =
      library.extensions.map((element) => element.name).toSet();
  if (expectWhenExtensions) {
    expect(extensionNames, contains('GAuthorFragmentDataWhenExtension'));
    expect(extensionNames, contains('GBookFragmentDataWhenExtension'));
  } else {
    expect(
      extensionNames.contains('GAuthorFragmentDataWhenExtension'),
      isFalse,
    );
    expect(
      extensionNames.contains('GBookFragmentDataWhenExtension'),
      isFalse,
    );
  }
}

void _expectVarTypes(
  LibraryElement library, {
  required bool expectTristate,
}) {
  final varsClass = _classByName(library, 'GBookByIdVars');
  final idField = varsClass.getField('id');
  final filterField = varsClass.getField('filter');
  expect(idField, isNotNull);
  expect(filterField, isNotNull);

  if (expectTristate) {
    _expectValueType(idField!.type, innerName: 'String');
    _expectValueType(filterField!.type, innerName: 'GBookFilter');
  } else {
    _expectNullableInterfaceType(idField!.type, name: 'String');
    _expectNullableInterfaceType(filterField!.type, name: 'GBookFilter');
  }
}

void _expectReqGenerics(LibraryElement library) {
  final reqClass = _classByName(library, 'GBookByIdReq');
  final opInterface = reqClass.interfaces.firstWhere(
    (interfaceType) => interfaceType.element.name == 'OperationRequest',
  );
  expect(opInterface.typeArguments.length, 2);
  _expectInterfaceType(
    opInterface.typeArguments[0],
    name: 'GBookByIdData',
    nullable: false,
  );
  _expectInterfaceType(
    opInterface.typeArguments[1],
    name: 'GBookByIdVars',
    nullable: false,
  );
}

void _expectDataToJsonSignature(LibraryElement library) {
  final reqClass = _classByName(library, 'GBookByIdReq');
  final method = reqClass.getMethod('dataToJson');
  expect(method, isNotNull);
  final parameter = method!.formalParameters.single;
  final type = parameter.type;
  _expectInterfaceType(type, name: 'GBookByIdData', nullable: false);
}

ClassElement _classByName(LibraryElement library, String name) {
  return library.classes.firstWhere(
    (element) => element.name == name,
    orElse: () => throw StateError('Missing class $name'),
  );
}

void _expectInterfaceType(
  DartType type, {
  required String name,
  required bool nullable,
}) {
  final interfaceType = type is InterfaceType ? type : null;
  if (interfaceType == null) {
    throw StateError('Expected $name to be an interface type.');
  }
  expect(interfaceType.element.name, name);
  expect(
    interfaceType.nullabilitySuffix,
    nullable ? NullabilitySuffix.question : NullabilitySuffix.none,
  );
}

void _expectNullableInterfaceType(
  DartType type, {
  required String name,
}) {
  _expectInterfaceType(type, name: name, nullable: true);
}

void _expectValueType(
  DartType type, {
  required String innerName,
}) {
  final interfaceType = type is InterfaceType ? type : null;
  if (interfaceType == null) {
    throw StateError('Expected Value<$innerName> to be an interface type.');
  }
  expect(interfaceType.element.name, 'Value');
  expect(interfaceType.typeArguments.length, 1);
  final innerType = interfaceType.typeArguments.first;
  _expectInterfaceType(innerType, name: innerName, nullable: false);
}

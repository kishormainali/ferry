// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/issue_610/__generated__/books.ast.gql.dart'
    as _i5;
import 'package:ferry_generator2_end_to_end/issue_610/__generated__/books.data.gql.dart'
    as _i2;
import 'package:gql/ast.dart' as _i4;
import 'package:gql_exec/gql_exec.dart' as _i3;

class GGetBooksReq implements _i1.OperationRequest<_i2.GGetBooksData, Null> {
  GGetBooksReq({
    _i3.Operation? operation,
    this.requestId,
    this.updateResult,
    this.optimisticResponse,
    this.updateCacheHandlerKey,
    this.updateCacheHandlerContext,
    this.fetchPolicy,
    this.executeOnListen = true,
    this.context,
  }) : operation = operation ?? _operation;

  final Null vars = null;

  final _i3.Operation operation;

  final String? requestId;

  final _i2.GGetBooksData? Function(
    _i2.GGetBooksData?,
    _i2.GGetBooksData?,
  )? updateResult;

  final _i2.GGetBooksData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i3.Context? context;

  static const _i4.DocumentNode _document = _i4.DocumentNode(definitions: [
    _i5.AuthorFragment,
    _i5.BookFragment,
    _i5.GetBooks,
  ]);

  static final _i3.Operation _operation = _i3.Operation(
    document: _document,
    operationName: 'GetBooks',
  );

  _i3.Request get execRequest => _i3.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i3.Context(),
      );

  _i2.GGetBooksData? parseData(Map<String, dynamic> json) =>
      _i2.GGetBooksData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GGetBooksData data) => data.toJson();

  _i1.OperationRequest<_i2.GGetBooksData, Null> transformOperation(
      _i3.Operation Function(_i3.Operation) transform) {
    return GGetBooksReq(
      operation: transform(operation),
      requestId: requestId,
      updateResult: updateResult,
      optimisticResponse: optimisticResponse,
      updateCacheHandlerKey: updateCacheHandlerKey,
      updateCacheHandlerContext: updateCacheHandlerContext,
      fetchPolicy: fetchPolicy,
      executeOnListen: executeOnListen,
      context: context,
    );
  }
}

class GAuthorFragmentReq
    implements _i1.FragmentRequest<_i2.GAuthorFragmentData, Null> {
  GAuthorFragmentReq({
    _i4.DocumentNode? document,
    this.fragmentName = 'AuthorFragment',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final Null vars = null;

  final _i4.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static const _i4.DocumentNode _document =
      _i4.DocumentNode(definitions: [_i5.AuthorFragment]);

  _i2.GAuthorFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GAuthorFragmentData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GAuthorFragmentData data) =>
      data.toJson();
}

class GBookFragmentReq
    implements _i1.FragmentRequest<_i2.GBookFragmentData, Null> {
  GBookFragmentReq({
    _i4.DocumentNode? document,
    this.fragmentName = 'BookFragment',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final Null vars = null;

  final _i4.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static const _i4.DocumentNode _document = _i4.DocumentNode(definitions: [
    _i5.AuthorFragment,
    _i5.BookFragment,
  ]);

  _i2.GBookFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GBookFragmentData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GBookFragmentData data) => data.toJson();
}

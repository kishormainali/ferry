// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/shared_fragment_queries.ast.gql.dart'
    as _i4;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/shared_fragment_queries.data.gql.dart'
    as _i2;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/shared_fragment_queries.var.gql.dart'
    as _i5;
import 'package:gql/ast.dart' as _i6;
import 'package:gql_exec/gql_exec.dart' as _i3;

class GSharedBooksAReq
    implements _i1.OperationRequest<_i2.GSharedBooksAData, Null> {
  GSharedBooksAReq({
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

  final _i2.GSharedBooksAData? Function(
    _i2.GSharedBooksAData?,
    _i2.GSharedBooksAData?,
  )? updateResult;

  final _i2.GSharedBooksAData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i3.Context? context;

  static final _i3.Operation _operation = _i3.Operation(
    document: _i4.document,
    operationName: 'SharedBooksA',
  );

  _i3.Request get execRequest => _i3.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i3.Context(),
      );

  _i2.GSharedBooksAData? parseData(Map<String, dynamic> json) =>
      _i2.GSharedBooksAData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GSharedBooksAData data) => data.toJson();

  _i1.OperationRequest<_i2.GSharedBooksAData, Null> transformOperation(
      _i3.Operation Function(_i3.Operation) transform) {
    return GSharedBooksAReq(
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

class GSharedBooksBReq
    implements _i1.OperationRequest<_i2.GSharedBooksBData, Null> {
  GSharedBooksBReq({
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

  final _i2.GSharedBooksBData? Function(
    _i2.GSharedBooksBData?,
    _i2.GSharedBooksBData?,
  )? updateResult;

  final _i2.GSharedBooksBData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i3.Context? context;

  static final _i3.Operation _operation = _i3.Operation(
    document: _i4.document,
    operationName: 'SharedBooksB',
  );

  _i3.Request get execRequest => _i3.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i3.Context(),
      );

  _i2.GSharedBooksBData? parseData(Map<String, dynamic> json) =>
      _i2.GSharedBooksBData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GSharedBooksBData data) => data.toJson();

  _i1.OperationRequest<_i2.GSharedBooksBData, Null> transformOperation(
      _i3.Operation Function(_i3.Operation) transform) {
    return GSharedBooksBReq(
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

class GSharedAuthorFragmentReq
    implements
        _i1.FragmentRequest<_i2.GSharedAuthorFragmentData,
            _i5.GSharedAuthorFragmentVars> {
  GSharedAuthorFragmentReq({
    required this.vars,
    _i6.DocumentNode? document,
    this.fragmentName = 'SharedAuthorFragment',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final _i5.GSharedAuthorFragmentVars vars;

  final _i6.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static final _i6.DocumentNode _document = _i4.document;

  _i2.GSharedAuthorFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GSharedAuthorFragmentData.fromJson(json);

  Map<String, dynamic> varsToJson() => vars.toJson();

  Map<String, dynamic> dataToJson(_i2.GSharedAuthorFragmentData data) =>
      data.toJson();
}

class GSharedBookFragmentReq
    implements
        _i1.FragmentRequest<_i2.GSharedBookFragmentData,
            _i5.GSharedBookFragmentVars> {
  GSharedBookFragmentReq({
    required this.vars,
    _i6.DocumentNode? document,
    this.fragmentName = 'SharedBookFragment',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final _i5.GSharedBookFragmentVars vars;

  final _i6.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static final _i6.DocumentNode _document = _i4.document;

  _i2.GSharedBookFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GSharedBookFragmentData.fromJson(json);

  Map<String, dynamic> varsToJson() => vars.toJson();

  Map<String, dynamic> dataToJson(_i2.GSharedBookFragmentData data) =>
      data.toJson();
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/aliases/__generated__/alias_var_fragment.ast.gql.dart'
    as _i6;
import 'package:ferry_generator2_end_to_end/aliases/__generated__/alias_var_fragment.data.gql.dart'
    as _i2;
import 'package:ferry_generator2_end_to_end/aliases/__generated__/alias_var_fragment.var.gql.dart'
    as _i3;
import 'package:gql/ast.dart' as _i5;
import 'package:gql_exec/gql_exec.dart' as _i4;

class GPostsReq
    implements _i1.OperationRequest<_i2.GPostsData, _i3.GPostsVars> {
  GPostsReq({
    required this.vars,
    _i4.Operation? operation,
    this.requestId,
    this.updateResult,
    this.optimisticResponse,
    this.updateCacheHandlerKey,
    this.updateCacheHandlerContext,
    this.fetchPolicy,
    this.executeOnListen = true,
    this.context,
  }) : operation = operation ?? _operation;

  final _i3.GPostsVars vars;

  final _i4.Operation operation;

  final String? requestId;

  final _i2.GPostsData? Function(
    _i2.GPostsData?,
    _i2.GPostsData?,
  )? updateResult;

  final _i2.GPostsData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i4.Context? context;

  static const _i5.DocumentNode _document = _i5.DocumentNode(definitions: [
    _i6.PostFragment,
    _i6.Posts,
  ]);

  static final _i4.Operation _operation = _i4.Operation(
    document: _document,
    operationName: 'Posts',
  );

  _i4.Request get execRequest => _i4.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i4.Context(),
      );

  _i2.GPostsData? parseData(Map<String, dynamic> json) =>
      _i2.GPostsData.fromJson(json);

  Map<String, dynamic> varsToJson() => vars.toJson();

  Map<String, dynamic> dataToJson(_i2.GPostsData data) => data.toJson();

  _i1.OperationRequest<_i2.GPostsData, _i3.GPostsVars> transformOperation(
      _i4.Operation Function(_i4.Operation) transform) {
    return GPostsReq(
      vars: vars,
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

class GPostFragmentReq
    implements
        _i1.FragmentRequest<_i2.GPostFragmentData, _i3.GPostFragmentVars> {
  GPostFragmentReq({
    required this.vars,
    _i5.DocumentNode? document,
    this.fragmentName = 'PostFragment',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final _i3.GPostFragmentVars vars;

  final _i5.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static const _i5.DocumentNode _document =
      _i5.DocumentNode(definitions: [_i6.PostFragment]);

  _i2.GPostFragmentData? parseData(Map<String, dynamic> json) =>
      _i2.GPostFragmentData.fromJson(json);

  Map<String, dynamic> varsToJson() => vars.toJson();

  Map<String, dynamic> dataToJson(_i2.GPostFragmentData data) => data.toJson();
}

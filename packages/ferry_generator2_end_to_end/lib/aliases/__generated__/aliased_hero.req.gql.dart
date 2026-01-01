// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/aliases/__generated__/aliased_hero.ast.gql.dart'
    as _i4;
import 'package:ferry_generator2_end_to_end/aliases/__generated__/aliased_hero.data.gql.dart'
    as _i2;
import 'package:gql_exec/gql_exec.dart' as _i3;

class GAliasedHeroReq
    implements _i1.OperationRequest<_i2.GAliasedHeroData, Null> {
  GAliasedHeroReq({
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

  final _i2.GAliasedHeroData? Function(
    _i2.GAliasedHeroData?,
    _i2.GAliasedHeroData?,
  )? updateResult;

  final _i2.GAliasedHeroData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i3.Context? context;

  static final _i3.Operation _operation = _i3.Operation(
    document: _i4.document,
    operationName: 'AliasedHero',
  );

  _i3.Request get execRequest => _i3.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i3.Context(),
      );

  _i2.GAliasedHeroData? parseData(Map<String, dynamic> json) =>
      _i2.GAliasedHeroData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GAliasedHeroData data) => data.toJson();

  _i1.OperationRequest<_i2.GAliasedHeroData, Null> transformOperation(
      _i3.Operation Function(_i3.Operation) transform) {
    return GAliasedHeroReq(
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

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/no_vars/__generated__/hero_no_vars.ast.gql.dart'
    as _i5;
import 'package:ferry_generator2_end_to_end/no_vars/__generated__/hero_no_vars.data.gql.dart'
    as _i2;
import 'package:gql/ast.dart' as _i4;
import 'package:gql_exec/gql_exec.dart' as _i3;

class GHeroNoVarsReq
    implements _i1.OperationRequest<_i2.GHeroNoVarsData, Null> {
  GHeroNoVarsReq({
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

  final _i2.GHeroNoVarsData? Function(
    _i2.GHeroNoVarsData?,
    _i2.GHeroNoVarsData?,
  )? updateResult;

  final _i2.GHeroNoVarsData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i3.Context? context;

  static final _i4.DocumentNode _document =
      _i4.DocumentNode(definitions: [_i5.HeroNoVars]);

  static final _i3.Operation _operation = _i3.Operation(
    document: _document,
    operationName: 'HeroNoVars',
  );

  _i3.Request get execRequest => _i3.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i3.Context(),
      );

  _i2.GHeroNoVarsData? parseData(Map<String, dynamic> json) =>
      _i2.GHeroNoVarsData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GHeroNoVarsData data) => data.toJson();

  _i1.OperationRequest<_i2.GHeroNoVarsData, Null> transformOperation(
      _i3.Operation Function(_i3.Operation) transform) {
    return GHeroNoVarsReq(
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

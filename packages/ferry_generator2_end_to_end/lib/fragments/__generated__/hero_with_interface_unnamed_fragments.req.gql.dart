// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/hero_with_interface_unnamed_fragments.ast.gql.dart'
    as _i5;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/hero_with_interface_unnamed_fragments.data.gql.dart'
    as _i2;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/hero_with_interface_unnamed_fragments.var.gql.dart'
    as _i3;
import 'package:gql_exec/gql_exec.dart' as _i4;

class GHeroWithInterfaceUnnamedFragmentsReq
    implements
        _i1.OperationRequest<_i2.GHeroWithInterfaceUnnamedFragmentsData,
            _i3.GHeroWithInterfaceUnnamedFragmentsVars> {
  GHeroWithInterfaceUnnamedFragmentsReq({
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

  final _i3.GHeroWithInterfaceUnnamedFragmentsVars vars;

  final _i4.Operation operation;

  final String? requestId;

  final _i2.GHeroWithInterfaceUnnamedFragmentsData? Function(
    _i2.GHeroWithInterfaceUnnamedFragmentsData?,
    _i2.GHeroWithInterfaceUnnamedFragmentsData?,
  )? updateResult;

  final _i2.GHeroWithInterfaceUnnamedFragmentsData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i4.Context? context;

  static final _i4.Operation _operation = _i4.Operation(
    document: _i5.document,
    operationName: 'HeroWithInterfaceUnnamedFragments',
  );

  _i4.Request get execRequest => _i4.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i4.Context(),
      );

  _i2.GHeroWithInterfaceUnnamedFragmentsData? parseData(
          Map<String, dynamic> json) =>
      _i2.GHeroWithInterfaceUnnamedFragmentsData.fromJson(json);

  Map<String, dynamic> varsToJson() => vars.toJson();

  Map<String, dynamic> dataToJson(
          _i2.GHeroWithInterfaceUnnamedFragmentsData data) =>
      data.toJson();

  _i1.OperationRequest<_i2.GHeroWithInterfaceUnnamedFragmentsData,
          _i3.GHeroWithInterfaceUnnamedFragmentsVars>
      transformOperation(_i4.Operation Function(_i4.Operation) transform) {
    return GHeroWithInterfaceUnnamedFragmentsReq(
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

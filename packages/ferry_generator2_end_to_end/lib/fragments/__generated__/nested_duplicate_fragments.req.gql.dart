// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/nested_duplicate_fragments.ast.gql.dart'
    as _i5;
import 'package:ferry_generator2_end_to_end/fragments/__generated__/nested_duplicate_fragments.data.gql.dart'
    as _i2;
import 'package:gql/ast.dart' as _i4;
import 'package:gql_exec/gql_exec.dart' as _i3;

class GSearchResultsQueryReq
    implements _i1.OperationRequest<_i2.GSearchResultsQueryData, Null> {
  GSearchResultsQueryReq({
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

  final _i2.GSearchResultsQueryData? Function(
    _i2.GSearchResultsQueryData?,
    _i2.GSearchResultsQueryData?,
  )? updateResult;

  final _i2.GSearchResultsQueryData? optimisticResponse;

  final String? updateCacheHandlerKey;

  final Map<String, dynamic>? updateCacheHandlerContext;

  final _i1.FetchPolicy? fetchPolicy;

  final bool executeOnListen;

  final _i3.Context? context;

  static const _i4.DocumentNode _document = _i4.DocumentNode(definitions: [
    _i5.SearchResultsQuery,
    _i5.CharacterDetails,
    _i5.FriendInfo,
    _i5.CharacterBasic,
  ]);

  static final _i3.Operation _operation = _i3.Operation(
    document: _document,
    operationName: 'SearchResultsQuery',
  );

  _i3.Request get execRequest => _i3.Request(
        operation: operation,
        variables: varsToJson(),
        context: context ?? const _i3.Context(),
      );

  _i2.GSearchResultsQueryData? parseData(Map<String, dynamic> json) =>
      _i2.GSearchResultsQueryData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GSearchResultsQueryData data) =>
      data.toJson();

  _i1.OperationRequest<_i2.GSearchResultsQueryData, Null> transformOperation(
      _i3.Operation Function(_i3.Operation) transform) {
    return GSearchResultsQueryReq(
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

class GCharacterDetailsReq
    implements _i1.FragmentRequest<_i2.GCharacterDetailsData, Null> {
  GCharacterDetailsReq({
    _i4.DocumentNode? document,
    this.fragmentName = 'CharacterDetails',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final Null vars = null;

  final _i4.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static const _i4.DocumentNode _document = _i4.DocumentNode(definitions: [
    _i5.CharacterDetails,
    _i5.FriendInfo,
    _i5.CharacterBasic,
  ]);

  _i2.GCharacterDetailsData? parseData(Map<String, dynamic> json) =>
      _i2.GCharacterDetailsData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GCharacterDetailsData data) =>
      data.toJson();
}

class GFriendInfoReq implements _i1.FragmentRequest<_i2.GFriendInfoData, Null> {
  GFriendInfoReq({
    _i4.DocumentNode? document,
    this.fragmentName = 'FriendInfo',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final Null vars = null;

  final _i4.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static const _i4.DocumentNode _document = _i4.DocumentNode(definitions: [
    _i5.FriendInfo,
    _i5.CharacterBasic,
  ]);

  _i2.GFriendInfoData? parseData(Map<String, dynamic> json) =>
      _i2.GFriendInfoData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GFriendInfoData data) => data.toJson();
}

class GCharacterBasicReq
    implements _i1.FragmentRequest<_i2.GCharacterBasicData, Null> {
  GCharacterBasicReq({
    _i4.DocumentNode? document,
    this.fragmentName = 'CharacterBasic',
    this.idFields = const <String, dynamic>{},
  }) : document = document ?? _document;

  final Null vars = null;

  final _i4.DocumentNode document;

  final String? fragmentName;

  final Map<String, dynamic> idFields;

  static const _i4.DocumentNode _document =
      _i4.DocumentNode(definitions: [_i5.CharacterBasic]);

  _i2.GCharacterBasicData? parseData(Map<String, dynamic> json) =>
      _i2.GCharacterBasicData.fromJson(json);

  Map<String, dynamic> varsToJson() => const <String, dynamic>{};

  Map<String, dynamic> dataToJson(_i2.GCharacterBasicData data) =>
      data.toJson();
}

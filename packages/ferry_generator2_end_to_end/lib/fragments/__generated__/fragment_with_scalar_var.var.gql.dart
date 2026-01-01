// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:gql_tristate_value/gql_tristate_value.dart';

class GPostsWithFixedVariableVars {
  const GPostsWithFixedVariableVars({this.filter = const Value.absent()});

  factory GPostsWithFixedVariableVars.fromJson(Map<String, dynamic> json) {
    return GPostsWithFixedVariableVars(
        filter: json.containsKey('filter')
            ? Value.present(json['filter'] == null
                ? null
                : (json['filter'] as Map<String, dynamic>))
            : Value.absent());
  }

  final Value<Map<String, dynamic>> filter;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$filterValue = this.filter;
    if (_$filterValue.isPresent) {
      final _$filterRequired = _$filterValue.requireValue;
      _$result['filter'] = _$filterRequired == null ? null : _$filterRequired;
    }
    return _$result;
  }
}

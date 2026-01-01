// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:gql_tristate_value/gql_tristate_value.dart';

class GHeroWithFragmentsVars {
  const GHeroWithFragmentsVars({this.first = const Value.absent()});

  factory GHeroWithFragmentsVars.fromJson(Map<String, dynamic> json) {
    return GHeroWithFragmentsVars(
        first: json.containsKey('first')
            ? Value.present(
                json['first'] == null ? null : (json['first'] as int))
            : Value.absent());
  }

  final Value<int> first;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$firstValue = this.first;
    if (_$firstValue.isPresent) {
      final _$firstRequired = _$firstValue.requireValue;
      _$result['first'] = _$firstRequired == null ? null : _$firstRequired;
    }
    return _$result;
  }
}

class GcomparisonFieldsVars {
  const GcomparisonFieldsVars({this.first = const Value.absent()});

  factory GcomparisonFieldsVars.fromJson(Map<String, dynamic> json) {
    return GcomparisonFieldsVars(
        first: json.containsKey('first')
            ? Value.present(
                json['first'] == null ? null : (json['first'] as int))
            : Value.absent());
  }

  final Value<int> first;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$firstValue = this.first;
    if (_$firstValue.isPresent) {
      final _$firstRequired = _$firstValue.requireValue;
      _$result['first'] = _$firstRequired == null ? null : _$firstRequired;
    }
    return _$result;
  }
}

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
    final result = <String, dynamic>{};
    final firstValue = first;
    if (firstValue.isPresent) {
      final firstRequired = firstValue.requireValue;
      result['first'] = firstRequired == null ? null : firstRequired;
    }
    return result;
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
    final result = <String, dynamic>{};
    final firstValue = first;
    if (firstValue.isPresent) {
      final firstRequired = firstValue.requireValue;
      result['first'] = firstRequired == null ? null : firstRequired;
    }
    return result;
  }
}

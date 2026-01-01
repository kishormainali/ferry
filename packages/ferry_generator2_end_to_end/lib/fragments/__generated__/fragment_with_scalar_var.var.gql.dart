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
    final result = <String, dynamic>{};
    final filterValue = filter;
    if (filterValue.isPresent) {
      final filterRequired = filterValue.requireValue;
      result['filter'] = filterRequired == null ? null : filterRequired;
    }
    return result;
  }
}

class GPostFragmentForUser1Vars {
  const GPostFragmentForUser1Vars();

  factory GPostFragmentForUser1Vars.fromJson(Map<String, dynamic> json) {
    return GPostFragmentForUser1Vars();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    return result;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

class GCreateCustomFieldVars {
  const GCreateCustomFieldVars({required this.input});

  factory GCreateCustomFieldVars.fromJson(Map<String, dynamic> json) {
    return GCreateCustomFieldVars(
        input: _i1.GCustomFieldInput.fromJson(
            (json['input'] as Map<String, dynamic>)));
  }

  final _i1.GCustomFieldInput input;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$inputValue = this.input;
    _$result['input'] = _$inputValue.toJson();
    return _$result;
  }
}

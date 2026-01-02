// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:gql_tristate_value/gql_tristate_value.dart';

class GSearchWithDefaultVars {
  const GSearchWithDefaultVars({this.text = const Value.absent()});

  factory GSearchWithDefaultVars.fromJson(Map<String, dynamic> json) {
    return GSearchWithDefaultVars(
        text: json.containsKey('text')
            ? Value.present(
                json['text'] == null ? null : (json['text'] as String))
            : Value.absent());
  }

  final Value<String> text;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$textValue = this.text;
    if (_$textValue.isPresent) {
      final _$textRequired = _$textValue.requireValue;
      _$result['text'] = _$textRequired == null ? null : _$textRequired;
    }
    return _$result;
  }
}

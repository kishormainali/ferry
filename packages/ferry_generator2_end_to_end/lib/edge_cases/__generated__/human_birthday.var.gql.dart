// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHumanBirthdayVars {
  const GHumanBirthdayVars({required this.id});

  factory GHumanBirthdayVars.fromJson(Map<String, dynamic> json) {
    return GHumanBirthdayVars(id: (json['id'] as String));
  }

  final String id;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$idValue = this.id;
    _$result['id'] = _$idValue;
    return _$result;
  }
}

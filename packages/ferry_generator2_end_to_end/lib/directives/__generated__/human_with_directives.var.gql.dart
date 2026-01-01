// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHumanWithDirectivesVars {
  const GHumanWithDirectivesVars({
    required this.includeName,
    required this.skipId,
  });

  factory GHumanWithDirectivesVars.fromJson(Map<String, dynamic> json) {
    return GHumanWithDirectivesVars(
      includeName: (json['includeName'] as bool),
      skipId: (json['skipId'] as bool),
    );
  }

  final bool includeName;

  final bool skipId;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$includeNameValue = this.includeName;
    _$result['includeName'] = _$includeNameValue;
    final _$skipIdValue = this.skipId;
    _$result['skipId'] = _$skipIdValue;
    return _$result;
  }
}

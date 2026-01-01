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
    final result = <String, dynamic>{};
    final includeNameValue = includeName;
    result['includeName'] = includeNameValue;
    final skipIdValue = skipId;
    result['skipId'] = skipIdValue;
    return result;
  }
}

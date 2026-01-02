// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHeroFragmentDirectivesVars {
  const GHeroFragmentDirectivesVars({
    required this.includeFrag,
    required this.skipName,
  });

  factory GHeroFragmentDirectivesVars.fromJson(Map<String, dynamic> json) {
    return GHeroFragmentDirectivesVars(
      includeFrag: (json['includeFrag'] as bool),
      skipName: (json['skipName'] as bool),
    );
  }

  final bool includeFrag;

  final bool skipName;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$includeFragValue = this.includeFrag;
    _$result['includeFrag'] = _$includeFragValue;
    final _$skipNameValue = this.skipName;
    _$result['skipName'] = _$skipNameValue;
    return _$result;
  }
}

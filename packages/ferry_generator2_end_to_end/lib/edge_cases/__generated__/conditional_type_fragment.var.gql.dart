// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHeroConditionalTypeFragmentVars {
  const GHeroConditionalTypeFragmentVars({required this.includeHuman});

  factory GHeroConditionalTypeFragmentVars.fromJson(Map<String, dynamic> json) {
    return GHeroConditionalTypeFragmentVars(
        includeHuman: (json['includeHuman'] as bool));
  }

  final bool includeHuman;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$includeHumanValue = this.includeHuman;
    _$result['includeHuman'] = _$includeHumanValue;
    return _$result;
  }
}

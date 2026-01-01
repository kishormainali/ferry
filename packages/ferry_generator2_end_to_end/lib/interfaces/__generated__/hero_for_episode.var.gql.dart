// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

class GHeroForEpisodeVars {
  const GHeroForEpisodeVars({required this.ep});

  factory GHeroForEpisodeVars.fromJson(Map<String, dynamic> json) {
    return GHeroForEpisodeVars(
        ep: _i1.GEpisode.fromJson((json['ep'] as String)));
  }

  final _i1.GEpisode ep;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final epValue = ep;
    result['ep'] = epValue.toJson();
    return result;
  }
}

class GDroidFragmentVars {
  const GDroidFragmentVars();

  factory GDroidFragmentVars.fromJson(Map<String, dynamic> json) {
    return GDroidFragmentVars();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    return result;
  }
}

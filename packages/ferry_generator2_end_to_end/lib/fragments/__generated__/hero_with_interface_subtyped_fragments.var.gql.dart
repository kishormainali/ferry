// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

class GHeroWithInterfaceSubTypedFragmentsVars {
  const GHeroWithInterfaceSubTypedFragmentsVars({required this.episode});

  factory GHeroWithInterfaceSubTypedFragmentsVars.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceSubTypedFragmentsVars(
        episode: _i1.GEpisode.fromJson((json['episode'] as String)));
  }

  final _i1.GEpisode episode;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$episodeValue = this.episode;
    _$result['episode'] = _$episodeValue.toJson();
    return _$result;
  }
}

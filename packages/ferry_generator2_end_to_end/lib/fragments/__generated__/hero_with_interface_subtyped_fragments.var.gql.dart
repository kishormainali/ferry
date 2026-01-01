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
    final result = <String, dynamic>{};
    final episodeValue = episode;
    result['episode'] = episodeValue.toJson();
    return result;
  }
}

class GheroFieldsFragmentVars {
  const GheroFieldsFragmentVars();

  factory GheroFieldsFragmentVars.fromJson(Map<String, dynamic> json) {
    return GheroFieldsFragmentVars();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    return result;
  }
}

class GhumanFieldsFragmentVars {
  const GhumanFieldsFragmentVars();

  factory GhumanFieldsFragmentVars.fromJson(Map<String, dynamic> json) {
    return GhumanFieldsFragmentVars();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    return result;
  }
}

class GdroidFieldsFragmentVars {
  const GdroidFieldsFragmentVars();

  factory GdroidFieldsFragmentVars.fromJson(Map<String, dynamic> json) {
    return GdroidFieldsFragmentVars();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    return result;
  }
}

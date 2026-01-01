// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;
import 'package:gql_tristate_value/gql_tristate_value.dart';

class GreviewsWithListArgumentVars {
  const GreviewsWithListArgumentVars({
    required this.episode,
    this.stars = const Value.absent(),
  });

  factory GreviewsWithListArgumentVars.fromJson(Map<String, dynamic> json) {
    return GreviewsWithListArgumentVars(
      episode: _i1.GEpisode.fromJson((json['episode'] as String)),
      stars: json.containsKey('stars')
          ? Value.present(json['stars'] == null
              ? null
              : (json['stars'] as List<dynamic>)
                  .map((e) => (e as int))
                  .toList())
          : Value.absent(),
    );
  }

  final _i1.GEpisode episode;

  final Value<List<int>> stars;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final episodeValue = episode;
    result['episode'] = episodeValue.toJson();
    final starsValue = stars;
    if (starsValue.isPresent) {
      final starsRequired = starsValue.requireValue;
      result['stars'] =
          starsRequired == null ? null : starsRequired.map((e) => e).toList();
    }
    return result;
  }
}

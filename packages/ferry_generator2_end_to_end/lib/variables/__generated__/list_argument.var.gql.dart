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
              : List<int>.from((json['stars'] as List<dynamic>)))
          : Value.absent(),
    );
  }

  final _i1.GEpisode episode;

  final Value<List<int>> stars;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$episodeValue = this.episode;
    _$result['episode'] = _$episodeValue.toJson();
    final _$starsValue = this.stars;
    if (_$starsValue.isPresent) {
      final _$starsRequired = _$starsValue.requireValue;
      _$result['stars'] = _$starsRequired == null
          ? null
          : _$starsRequired.map((_$e) => _$e).toList();
    }
    return _$result;
  }
}

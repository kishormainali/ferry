// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/custom/date.dart';
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;
import 'package:gql_tristate_value/gql_tristate_value.dart';

class GReviewWithDateVars {
  const GReviewWithDateVars({
    this.episode = const Value.absent(),
    required this.review,
    this.createdAt = const Value.absent(),
  });

  factory GReviewWithDateVars.fromJson(Map<String, dynamic> json) {
    return GReviewWithDateVars(
      episode: json.containsKey('episode')
          ? Value.present(json['episode'] == null
              ? null
              : _i1.GEpisode.fromJson((json['episode'] as String)))
          : Value.absent(),
      review:
          _i1.GReviewInput.fromJson((json['review'] as Map<String, dynamic>)),
      createdAt: json.containsKey('createdAt')
          ? Value.present(json['createdAt'] == null
              ? null
              : customDateFromJson(json['createdAt']))
          : Value.absent(),
    );
  }

  final Value<_i1.GEpisode> episode;

  final _i1.GReviewInput review;

  final Value<CustomDate> createdAt;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final episodeValue = episode;
    if (episodeValue.isPresent) {
      final episodeRequired = episodeValue.requireValue;
      result['episode'] =
          episodeRequired == null ? null : episodeRequired.toJson();
    }
    final reviewValue = review;
    result['review'] = reviewValue.toJson();
    final createdAtValue = createdAt;
    if (createdAtValue.isPresent) {
      final createdAtRequired = createdAtValue.requireValue;
      result['createdAt'] = createdAtRequired == null
          ? null
          : customDateToJson(createdAtRequired);
    }
    return result;
  }
}

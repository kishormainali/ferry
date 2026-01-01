// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;
import 'package:gql_tristate_value/gql_tristate_value.dart';

class GCreateReviewWithDirectivesVars {
  const GCreateReviewWithDirectivesVars({
    this.episode = const Value.absent(),
    required this.review,
    required this.includeReview,
    required this.skipCommentary,
  });

  factory GCreateReviewWithDirectivesVars.fromJson(Map<String, dynamic> json) {
    return GCreateReviewWithDirectivesVars(
      episode: json.containsKey('episode')
          ? Value.present(json['episode'] == null
              ? null
              : _i1.GEpisode.fromJson((json['episode'] as String)))
          : Value.absent(),
      review:
          _i1.GReviewInput.fromJson((json['review'] as Map<String, dynamic>)),
      includeReview: (json['includeReview'] as bool),
      skipCommentary: (json['skipCommentary'] as bool),
    );
  }

  final Value<_i1.GEpisode> episode;

  final _i1.GReviewInput review;

  final bool includeReview;

  final bool skipCommentary;

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
    final includeReviewValue = includeReview;
    result['includeReview'] = includeReviewValue;
    final skipCommentaryValue = skipCommentary;
    result['skipCommentary'] = skipCommentaryValue;
    return result;
  }
}

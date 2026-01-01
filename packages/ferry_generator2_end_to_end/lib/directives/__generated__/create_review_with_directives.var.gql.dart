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
    final _$result = <String, dynamic>{};
    final _$episodeValue = this.episode;
    if (_$episodeValue.isPresent) {
      final _$episodeRequired = _$episodeValue.requireValue;
      _$result['episode'] =
          _$episodeRequired == null ? null : _$episodeRequired.toJson();
    }
    final _$reviewValue = this.review;
    _$result['review'] = _$reviewValue.toJson();
    final _$includeReviewValue = this.includeReview;
    _$result['includeReview'] = _$includeReviewValue;
    final _$skipCommentaryValue = this.skipCommentary;
    _$result['skipCommentary'] = _$skipCommentaryValue;
    return _$result;
  }
}

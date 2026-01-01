// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

class GCreateReviewWithDirectivesData {
  const GCreateReviewWithDirectivesData({
    this.createReview,
    required this.G__typename,
  });

  factory GCreateReviewWithDirectivesData.fromJson(Map<String, dynamic> json) {
    return GCreateReviewWithDirectivesData(
      createReview: json['createReview'] == null
          ? null
          : GCreateReviewWithDirectivesData_createReview.fromJson(
              (json['createReview'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GCreateReviewWithDirectivesData_createReview? createReview;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final createReviewValue = createReview;
    result['createReview'] =
        createReviewValue == null ? null : createReviewValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GCreateReviewWithDirectivesData_createReview {
  const GCreateReviewWithDirectivesData_createReview({
    this.episode,
    required this.stars,
    this.commentary,
    required this.G__typename,
  });

  factory GCreateReviewWithDirectivesData_createReview.fromJson(
      Map<String, dynamic> json) {
    return GCreateReviewWithDirectivesData_createReview(
      episode: json['episode'] == null
          ? null
          : _i1.GEpisode.fromJson((json['episode'] as String)),
      stars: (json['stars'] as int),
      commentary:
          json['commentary'] == null ? null : (json['commentary'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final _i1.GEpisode? episode;

  final int stars;

  final String? commentary;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final episodeValue = episode;
    result['episode'] = episodeValue == null ? null : episodeValue.toJson();
    result['stars'] = stars;
    final commentaryValue = commentary;
    result['commentary'] = commentaryValue == null ? null : commentaryValue;
    result['__typename'] = G__typename;
    return result;
  }
}

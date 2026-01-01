// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

class GReviewAddedData {
  const GReviewAddedData({
    this.reviewAdded,
    required this.G__typename,
  });

  factory GReviewAddedData.fromJson(Map<String, dynamic> json) {
    return GReviewAddedData(
      reviewAdded: json['reviewAdded'] == null
          ? null
          : GReviewAddedData_reviewAdded.fromJson(
              (json['reviewAdded'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GReviewAddedData_reviewAdded? reviewAdded;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final reviewAddedValue = reviewAdded;
    result['reviewAdded'] =
        reviewAddedValue == null ? null : reviewAddedValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GReviewAddedData_reviewAdded {
  const GReviewAddedData_reviewAdded({
    this.episode,
    required this.stars,
    this.commentary,
    required this.G__typename,
  });

  factory GReviewAddedData_reviewAdded.fromJson(Map<String, dynamic> json) {
    return GReviewAddedData_reviewAdded(
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

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/custom/date.dart';
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

class GReviewWithDateData {
  const GReviewWithDateData({
    this.createReview,
    required this.G__typename,
  });

  factory GReviewWithDateData.fromJson(Map<String, dynamic> json) {
    return GReviewWithDateData(
      createReview: json['createReview'] == null
          ? null
          : GReviewWithDateData_createReview.fromJson(
              (json['createReview'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GReviewWithDateData_createReview? createReview;

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

class GReviewWithDateData_createReview {
  const GReviewWithDateData_createReview({
    this.episode,
    required this.stars,
    this.commentary,
    this.createdAt,
    required this.seenOn,
    required this.custom,
    required this.G__typename,
  });

  factory GReviewWithDateData_createReview.fromJson(Map<String, dynamic> json) {
    return GReviewWithDateData_createReview(
      episode: json['episode'] == null
          ? null
          : _i1.GEpisode.fromJson((json['episode'] as String)),
      stars: (json['stars'] as int),
      commentary:
          json['commentary'] == null ? null : (json['commentary'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : customDateFromJson(json['createdAt']),
      seenOn: (json['seenOn'] as List<dynamic>)
          .map((e) => customDateFromJson(e))
          .toList(),
      custom:
          (json['custom'] as List<dynamic>).map((e) => (e as String)).toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final _i1.GEpisode? episode;

  final int stars;

  final String? commentary;

  final CustomDate? createdAt;

  final List<CustomDate> seenOn;

  final List<String> custom;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final episodeValue = episode;
    result['episode'] = episodeValue == null ? null : episodeValue.toJson();
    result['stars'] = stars;
    final commentaryValue = commentary;
    result['commentary'] = commentaryValue == null ? null : commentaryValue;
    final createdAtValue = createdAt;
    result['createdAt'] =
        createdAtValue == null ? null : customDateToJson(createdAtValue);
    result['seenOn'] = seenOn.map((e) => customDateToJson(e)).toList();
    result['custom'] = custom.map((e) => e).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

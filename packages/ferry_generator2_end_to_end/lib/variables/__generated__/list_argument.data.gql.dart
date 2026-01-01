// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.utils.gql.dart'
    as _gqlUtils;

class GreviewsWithListArgumentData {
  const GreviewsWithListArgumentData({
    this.reviews,
    required this.G__typename,
  });

  factory GreviewsWithListArgumentData.fromJson(Map<String, dynamic> json) {
    return GreviewsWithListArgumentData(
      reviews: json['reviews'] == null
          ? null
          : (json['reviews'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GreviewsWithListArgumentData_reviews.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GreviewsWithListArgumentData_reviews?>? reviews;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final reviewsValue = reviews;
    result['reviews'] = reviewsValue == null
        ? null
        : reviewsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GreviewsWithListArgumentData copyWith({
    List<GreviewsWithListArgumentData_reviews?>? reviews,
    bool reviewsIsSet = false,
    String? G__typename,
  }) {
    return GreviewsWithListArgumentData(
      reviews: reviewsIsSet ? reviews : this.reviews,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GreviewsWithListArgumentData &&
            _gqlUtils.listEquals(reviews, other.reviews) &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, _gqlUtils.listHash(reviews), G__typename);
  }

  @override
  String toString() {
    return 'GreviewsWithListArgumentData(reviews: $reviews, G__typename: $G__typename)';
  }
}

class GreviewsWithListArgumentData_reviews {
  const GreviewsWithListArgumentData_reviews({
    this.episode,
    required this.G__typename,
  });

  factory GreviewsWithListArgumentData_reviews.fromJson(
      Map<String, dynamic> json) {
    return GreviewsWithListArgumentData_reviews(
      episode: json['episode'] == null
          ? null
          : _i1.GEpisode.fromJson((json['episode'] as String)),
      G__typename: (json['__typename'] as String),
    );
  }

  final _i1.GEpisode? episode;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final episodeValue = episode;
    result['episode'] = episodeValue == null ? null : episodeValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GreviewsWithListArgumentData_reviews copyWith({
    _i1.GEpisode? episode,
    bool episodeIsSet = false,
    String? G__typename,
  }) {
    return GreviewsWithListArgumentData_reviews(
      episode: episodeIsSet ? episode : this.episode,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GreviewsWithListArgumentData_reviews &&
            episode == other.episode &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, episode, G__typename);
  }

  @override
  String toString() {
    return 'GreviewsWithListArgumentData_reviews(episode: $episode, G__typename: $G__typename)';
  }
}

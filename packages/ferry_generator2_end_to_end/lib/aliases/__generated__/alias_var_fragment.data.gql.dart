// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

abstract class GPostFragment {
  String get id;
  GPostFragment_isFavorited? get isFavorited;
  GPostFragment_isLiked? get isLiked;
  String get G__typename;
}

abstract class GPostFragment_isFavorited {
  int get totalCount;
  String get G__typename;
}

abstract class GPostFragment_isLiked {
  int get totalCount;
  String get G__typename;
}

class GPostFragmentData implements GPostFragment {
  const GPostFragmentData({
    required this.id,
    this.isFavorited,
    this.isLiked,
    required this.G__typename,
  });

  factory GPostFragmentData.fromJson(Map<String, dynamic> json) {
    return GPostFragmentData(
      id: (json['id'] as String),
      isFavorited: json['isFavorited'] == null
          ? null
          : GPostFragmentData_isFavorited.fromJson(
              (json['isFavorited'] as Map<String, dynamic>)),
      isLiked: json['isLiked'] == null
          ? null
          : GPostFragmentData_isLiked.fromJson(
              (json['isLiked'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final GPostFragmentData_isFavorited? isFavorited;

  final GPostFragmentData_isLiked? isLiked;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    final isFavoritedValue = isFavorited;
    result['isFavorited'] =
        isFavoritedValue == null ? null : isFavoritedValue.toJson();
    final isLikedValue = isLiked;
    result['isLiked'] = isLikedValue == null ? null : isLikedValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GPostFragmentData copyWith({
    String? id,
    GPostFragmentData_isFavorited? isFavorited,
    bool isFavoritedIsSet = false,
    GPostFragmentData_isLiked? isLiked,
    bool isLikedIsSet = false,
    String? G__typename,
  }) {
    return GPostFragmentData(
      id: id ?? this.id,
      isFavorited: isFavoritedIsSet ? isFavorited : this.isFavorited,
      isLiked: isLikedIsSet ? isLiked : this.isLiked,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostFragmentData &&
            id == other.id &&
            isFavorited == other.isFavorited &&
            isLiked == other.isLiked &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, id, isFavorited, isLiked, G__typename]);
  }

  @override
  String toString() {
    return 'GPostFragmentData(id: $id, isFavorited: $isFavorited, isLiked: $isLiked, G__typename: $G__typename)';
  }
}

class GPostFragmentData_isFavorited implements GPostFragment_isFavorited {
  const GPostFragmentData_isFavorited({
    required this.totalCount,
    required this.G__typename,
  });

  factory GPostFragmentData_isFavorited.fromJson(Map<String, dynamic> json) {
    return GPostFragmentData_isFavorited(
      totalCount: (json['totalCount'] as int),
      G__typename: (json['__typename'] as String),
    );
  }

  final int totalCount;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['totalCount'] = totalCount;
    result['__typename'] = G__typename;
    return result;
  }

  GPostFragmentData_isFavorited copyWith({
    int? totalCount,
    String? G__typename,
  }) {
    return GPostFragmentData_isFavorited(
      totalCount: totalCount ?? this.totalCount,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostFragmentData_isFavorited &&
            totalCount == other.totalCount &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, totalCount, G__typename]);
  }

  @override
  String toString() {
    return 'GPostFragmentData_isFavorited(totalCount: $totalCount, G__typename: $G__typename)';
  }
}

class GPostFragmentData_isLiked implements GPostFragment_isLiked {
  const GPostFragmentData_isLiked({
    required this.totalCount,
    required this.G__typename,
  });

  factory GPostFragmentData_isLiked.fromJson(Map<String, dynamic> json) {
    return GPostFragmentData_isLiked(
      totalCount: (json['totalCount'] as int),
      G__typename: (json['__typename'] as String),
    );
  }

  final int totalCount;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['totalCount'] = totalCount;
    result['__typename'] = G__typename;
    return result;
  }

  GPostFragmentData_isLiked copyWith({
    int? totalCount,
    String? G__typename,
  }) {
    return GPostFragmentData_isLiked(
      totalCount: totalCount ?? this.totalCount,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostFragmentData_isLiked &&
            totalCount == other.totalCount &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, totalCount, G__typename]);
  }

  @override
  String toString() {
    return 'GPostFragmentData_isLiked(totalCount: $totalCount, G__typename: $G__typename)';
  }
}

class GPostsData {
  const GPostsData({
    this.posts,
    required this.G__typename,
  });

  factory GPostsData.fromJson(Map<String, dynamic> json) {
    return GPostsData(
      posts: json['posts'] == null
          ? null
          : (json['posts'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GPostFragmentData.fromJson((e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GPostFragmentData?>? posts;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final postsValue = posts;
    result['posts'] = postsValue == null
        ? null
        : postsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GPostsData copyWith({
    List<GPostFragmentData?>? posts,
    bool postsIsSet = false,
    String? G__typename,
  }) {
    return GPostsData(
      posts: postsIsSet ? posts : this.posts,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostsData &&
            posts == other.posts &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, posts, G__typename]);
  }

  @override
  String toString() {
    return 'GPostsData(posts: $posts, G__typename: $G__typename)';
  }
}

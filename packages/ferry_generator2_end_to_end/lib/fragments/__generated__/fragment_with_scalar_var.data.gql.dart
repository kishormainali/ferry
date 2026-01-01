// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

abstract class GPostFragmentForUser1 {
  String get id;
  GPostFragmentForUser1_favoritedUsers? get favoritedUsers;
  String get G__typename;
}

abstract class GPostFragmentForUser1_favoritedUsers {
  int get totalCount;
  String get G__typename;
}

class GPostFragmentForUser1Data implements GPostFragmentForUser1 {
  const GPostFragmentForUser1Data({
    required this.id,
    this.favoritedUsers,
    required this.G__typename,
  });

  factory GPostFragmentForUser1Data.fromJson(Map<String, dynamic> json) {
    return GPostFragmentForUser1Data(
      id: (json['id'] as String),
      favoritedUsers: json['favoritedUsers'] == null
          ? null
          : GPostFragmentForUser1Data_favoritedUsers.fromJson(
              (json['favoritedUsers'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final GPostFragmentForUser1Data_favoritedUsers? favoritedUsers;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    final favoritedUsersValue = favoritedUsers;
    result['favoritedUsers'] =
        favoritedUsersValue == null ? null : favoritedUsersValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GPostFragmentForUser1Data copyWith({
    String? id,
    GPostFragmentForUser1Data_favoritedUsers? favoritedUsers,
    bool favoritedUsersIsSet = false,
    String? G__typename,
  }) {
    return GPostFragmentForUser1Data(
      id: id ?? this.id,
      favoritedUsers:
          favoritedUsersIsSet ? favoritedUsers : this.favoritedUsers,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostFragmentForUser1Data &&
            id == other.id &&
            favoritedUsers == other.favoritedUsers &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, id, favoritedUsers, G__typename]);
  }

  @override
  String toString() {
    return 'GPostFragmentForUser1Data(id: $id, favoritedUsers: $favoritedUsers, G__typename: $G__typename)';
  }
}

class GPostFragmentForUser1Data_favoritedUsers
    implements GPostFragmentForUser1_favoritedUsers {
  const GPostFragmentForUser1Data_favoritedUsers({
    required this.totalCount,
    required this.G__typename,
  });

  factory GPostFragmentForUser1Data_favoritedUsers.fromJson(
      Map<String, dynamic> json) {
    return GPostFragmentForUser1Data_favoritedUsers(
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

  GPostFragmentForUser1Data_favoritedUsers copyWith({
    int? totalCount,
    String? G__typename,
  }) {
    return GPostFragmentForUser1Data_favoritedUsers(
      totalCount: totalCount ?? this.totalCount,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostFragmentForUser1Data_favoritedUsers &&
            totalCount == other.totalCount &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, totalCount, G__typename]);
  }

  @override
  String toString() {
    return 'GPostFragmentForUser1Data_favoritedUsers(totalCount: $totalCount, G__typename: $G__typename)';
  }
}

class GPostsWithFixedVariableData {
  const GPostsWithFixedVariableData({
    this.posts,
    required this.G__typename,
  });

  factory GPostsWithFixedVariableData.fromJson(Map<String, dynamic> json) {
    return GPostsWithFixedVariableData(
      posts: json['posts'] == null
          ? null
          : (json['posts'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GPostFragmentForUser1Data.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GPostFragmentForUser1Data?>? posts;

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

  GPostsWithFixedVariableData copyWith({
    List<GPostFragmentForUser1Data?>? posts,
    bool postsIsSet = false,
    String? G__typename,
  }) {
    return GPostsWithFixedVariableData(
      posts: postsIsSet ? posts : this.posts,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GPostsWithFixedVariableData &&
            posts == other.posts &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, posts, G__typename]);
  }

  @override
  String toString() {
    return 'GPostsWithFixedVariableData(posts: $posts, G__typename: $G__typename)';
  }
}

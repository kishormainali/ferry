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
}

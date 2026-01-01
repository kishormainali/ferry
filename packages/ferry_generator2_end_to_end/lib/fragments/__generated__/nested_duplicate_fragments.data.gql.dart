// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

abstract class GCharacterDetails {
  String get id;
  String get name;
  List<GFriendInfo?>? get friends;
  List<_i1.GEpisode?> get appearsIn;
  String get G__typename;
}

class GCharacterDetailsData implements GCharacterDetails {
  const GCharacterDetailsData({
    required this.id,
    required this.name,
    this.friends,
    required this.appearsIn,
    required this.G__typename,
  });

  factory GCharacterDetailsData.fromJson(Map<String, dynamic> json) {
    return GCharacterDetailsData(
      id: (json['id'] as String),
      name: (json['name'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GFriendInfoData.fromJson((e as Map<String, dynamic>)))
              .toList(),
      appearsIn: (json['appearsIn'] as List<dynamic>)
          .map((e) => e == null ? null : _i1.GEpisode.fromJson((e as String)))
          .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final String name;

  final List<GFriendInfoData?>? friends;

  final List<_i1.GEpisode?> appearsIn;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['name'] = name;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['appearsIn'] =
        appearsIn.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

abstract class GFriendInfo {
  String get id;
  String get name;
  GFriendInfo_friendsConnection get friendsConnection;
  String get G__typename;
}

abstract class GFriendInfo_friendsConnection {
  List<GCharacterBasic?>? get friends;
  String get G__typename;
}

class GFriendInfoData implements GFriendInfo {
  const GFriendInfoData({
    required this.id,
    required this.name,
    required this.friendsConnection,
    required this.G__typename,
  });

  factory GFriendInfoData.fromJson(Map<String, dynamic> json) {
    return GFriendInfoData(
      id: (json['id'] as String),
      name: (json['name'] as String),
      friendsConnection: GFriendInfoData_friendsConnection.fromJson(
          (json['friendsConnection'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final String name;

  final GFriendInfoData_friendsConnection friendsConnection;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['name'] = name;
    result['friendsConnection'] = friendsConnection.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GFriendInfoData_friendsConnection
    implements GFriendInfo_friendsConnection {
  const GFriendInfoData_friendsConnection({
    this.friends,
    required this.G__typename,
  });

  factory GFriendInfoData_friendsConnection.fromJson(
      Map<String, dynamic> json) {
    return GFriendInfoData_friendsConnection(
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GCharacterBasicData.fromJson((e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GCharacterBasicData?>? friends;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

abstract class GCharacterBasic {
  String get id;
  String get name;
  String get G__typename;
}

class GCharacterBasicData implements GCharacterBasic {
  const GCharacterBasicData({
    required this.id,
    required this.name,
    required this.G__typename,
  });

  factory GCharacterBasicData.fromJson(Map<String, dynamic> json) {
    return GCharacterBasicData(
      id: (json['id'] as String),
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final String name;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['name'] = name;
    result['__typename'] = G__typename;
    return result;
  }
}

class GSearchResultsQueryData {
  const GSearchResultsQueryData({
    this.search,
    required this.G__typename,
  });

  factory GSearchResultsQueryData.fromJson(Map<String, dynamic> json) {
    return GSearchResultsQueryData(
      search: json['search'] == null
          ? null
          : (json['search'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GSearchResultsQueryData_search.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GSearchResultsQueryData_search?>? search;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final searchValue = search;
    result['search'] = searchValue == null
        ? null
        : searchValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

sealed class GSearchResultsQueryData_search {
  const GSearchResultsQueryData_search({required this.G__typename});

  factory GSearchResultsQueryData_search.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Human':
        return GSearchResultsQueryData_search__asHuman.fromJson(json);
      case 'Droid':
        return GSearchResultsQueryData_search__asDroid.fromJson(json);
      default:
        return GSearchResultsQueryData_search__unknown.fromJson(json);
    }
  }

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['__typename'] = G__typename;
    return result;
  }
}

extension GSearchResultsQueryData_searchWhenExtension
    on GSearchResultsQueryData_search {
  _T when<_T>({
    required _T Function(GSearchResultsQueryData_search__asHuman) human,
    required _T Function(GSearchResultsQueryData_search__asDroid) droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human(this as GSearchResultsQueryData_search__asHuman);
      case 'Droid':
        return droid(this as GSearchResultsQueryData_search__asDroid);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GSearchResultsQueryData_search__asHuman)? human,
    _T Function(GSearchResultsQueryData_search__asDroid)? droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human == null
            ? orElse()
            : human(this as GSearchResultsQueryData_search__asHuman);
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(this as GSearchResultsQueryData_search__asDroid);
      default:
        return orElse();
    }
  }
}

class GSearchResultsQueryData_search__asHuman
    extends GSearchResultsQueryData_search implements GCharacterDetails {
  const GSearchResultsQueryData_search__asHuman({
    required G__typename,
    required this.id,
    required this.name,
    this.friends,
    required this.appearsIn,
  }) : super(G__typename: G__typename);

  factory GSearchResultsQueryData_search__asHuman.fromJson(
      Map<String, dynamic> json) {
    return GSearchResultsQueryData_search__asHuman(
      G__typename: (json['__typename'] as String),
      id: (json['id'] as String),
      name: (json['name'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GFriendInfoData.fromJson((e as Map<String, dynamic>)))
              .toList(),
      appearsIn: (json['appearsIn'] as List<dynamic>)
          .map((e) => e == null ? null : _i1.GEpisode.fromJson((e as String)))
          .toList(),
    );
  }

  final String id;

  final String name;

  final List<GFriendInfoData?>? friends;

  final List<_i1.GEpisode?> appearsIn;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    result['id'] = id;
    result['name'] = name;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['appearsIn'] =
        appearsIn.map((e) => e == null ? null : e.toJson()).toList();
    return result;
  }
}

class GSearchResultsQueryData_search__asDroid
    extends GSearchResultsQueryData_search implements GCharacterDetails {
  const GSearchResultsQueryData_search__asDroid({
    required G__typename,
    required this.id,
    required this.name,
    this.friends,
    required this.appearsIn,
  }) : super(G__typename: G__typename);

  factory GSearchResultsQueryData_search__asDroid.fromJson(
      Map<String, dynamic> json) {
    return GSearchResultsQueryData_search__asDroid(
      G__typename: (json['__typename'] as String),
      id: (json['id'] as String),
      name: (json['name'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GFriendInfoData.fromJson((e as Map<String, dynamic>)))
              .toList(),
      appearsIn: (json['appearsIn'] as List<dynamic>)
          .map((e) => e == null ? null : _i1.GEpisode.fromJson((e as String)))
          .toList(),
    );
  }

  final String id;

  final String name;

  final List<GFriendInfoData?>? friends;

  final List<_i1.GEpisode?> appearsIn;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    result['id'] = id;
    result['name'] = name;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['appearsIn'] =
        appearsIn.map((e) => e == null ? null : e.toJson()).toList();
    return result;
  }
}

class GSearchResultsQueryData_search__unknown
    extends GSearchResultsQueryData_search {
  const GSearchResultsQueryData_search__unknown({required G__typename})
      : super(G__typename: G__typename);

  factory GSearchResultsQueryData_search__unknown.fromJson(
      Map<String, dynamic> json) {
    return GSearchResultsQueryData_search__unknown(
        G__typename: (json['__typename'] as String));
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

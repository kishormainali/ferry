// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

abstract class GheroData {
  String get name;
  String get G__typename;
}

class GheroDataData implements GheroData {
  const GheroDataData({
    required this.name,
    required this.G__typename,
  });

  factory GheroDataData.fromJson(Map<String, dynamic> json) {
    return GheroDataData(
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final String name;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['name'] = name;
    result['__typename'] = G__typename;
    return result;
  }
}

abstract class GcomparisonFields {
  String get id;
  String get name;
  String get G__typename;
  GcomparisonFields_friendsConnection get friendsConnection;
}

abstract class GcomparisonFields_friendsConnection {
  int? get totalCount;
  List<GcomparisonFields_friendsConnection_edges?>? get edges;
  String get G__typename;
}

abstract class GcomparisonFields_friendsConnection_edges {
  GheroData? get node;
  String get G__typename;
}

class GcomparisonFieldsData implements GcomparisonFields, GheroData {
  const GcomparisonFieldsData({
    required this.id,
    required this.name,
    required this.G__typename,
    required this.friendsConnection,
  });

  factory GcomparisonFieldsData.fromJson(Map<String, dynamic> json) {
    return GcomparisonFieldsData(
      id: (json['id'] as String),
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
      friendsConnection: GcomparisonFieldsData_friendsConnection.fromJson(
          (json['friendsConnection'] as Map<String, dynamic>)),
    );
  }

  final String id;

  final String name;

  final String G__typename;

  final GcomparisonFieldsData_friendsConnection friendsConnection;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['name'] = name;
    result['__typename'] = G__typename;
    result['friendsConnection'] = friendsConnection.toJson();
    return result;
  }
}

class GcomparisonFieldsData_friendsConnection
    implements GcomparisonFields_friendsConnection {
  const GcomparisonFieldsData_friendsConnection({
    this.totalCount,
    this.edges,
    required this.G__typename,
  });

  factory GcomparisonFieldsData_friendsConnection.fromJson(
      Map<String, dynamic> json) {
    return GcomparisonFieldsData_friendsConnection(
      totalCount:
          json['totalCount'] == null ? null : (json['totalCount'] as int),
      edges: json['edges'] == null
          ? null
          : (json['edges'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GcomparisonFieldsData_friendsConnection_edges.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final int? totalCount;

  final List<GcomparisonFieldsData_friendsConnection_edges?>? edges;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final totalCountValue = totalCount;
    result['totalCount'] = totalCountValue == null ? null : totalCountValue;
    final edgesValue = edges;
    result['edges'] = edgesValue == null
        ? null
        : edgesValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

class GcomparisonFieldsData_friendsConnection_edges
    implements GcomparisonFields_friendsConnection_edges {
  const GcomparisonFieldsData_friendsConnection_edges({
    this.node,
    required this.G__typename,
  });

  factory GcomparisonFieldsData_friendsConnection_edges.fromJson(
      Map<String, dynamic> json) {
    return GcomparisonFieldsData_friendsConnection_edges(
      node: json['node'] == null
          ? null
          : GheroDataData.fromJson((json['node'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GheroDataData? node;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final nodeValue = node;
    result['node'] = nodeValue == null ? null : nodeValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GHeroWithFragmentsData {
  const GHeroWithFragmentsData({
    this.hero,
    required this.G__typename,
  });

  factory GHeroWithFragmentsData.fromJson(Map<String, dynamic> json) {
    return GHeroWithFragmentsData(
      hero: json['hero'] == null
          ? null
          : GcomparisonFieldsData.fromJson(
              (json['hero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GcomparisonFieldsData? hero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final heroValue = hero;
    result['hero'] = heroValue == null ? null : heroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

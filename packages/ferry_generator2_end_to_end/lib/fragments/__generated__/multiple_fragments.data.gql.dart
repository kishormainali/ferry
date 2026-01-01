// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

abstract class GheroName {
  String get name;
  String get G__typename;
}

class GheroNameData implements GheroName {
  const GheroNameData({
    required this.name,
    required this.G__typename,
  });

  factory GheroNameData.fromJson(Map<String, dynamic> json) {
    return GheroNameData(
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

abstract class GheroId {
  String get id;
  String get G__typename;
}

class GheroIdData implements GheroId {
  const GheroIdData({
    required this.id,
    required this.G__typename,
  });

  factory GheroIdData.fromJson(Map<String, dynamic> json) {
    return GheroIdData(
      id: (json['id'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['__typename'] = G__typename;
    return result;
  }
}

class GHeroWith2FragmentsData {
  const GHeroWith2FragmentsData({
    this.hero,
    required this.G__typename,
  });

  factory GHeroWith2FragmentsData.fromJson(Map<String, dynamic> json) {
    return GHeroWith2FragmentsData(
      hero: json['hero'] == null
          ? null
          : GHeroWith2FragmentsData_hero.fromJson(
              (json['hero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GHeroWith2FragmentsData_hero? hero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final heroValue = hero;
    result['hero'] = heroValue == null ? null : heroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GHeroWith2FragmentsData_hero implements GheroName, GheroId {
  const GHeroWith2FragmentsData_hero({
    required this.name,
    required this.G__typename,
    required this.id,
  });

  factory GHeroWith2FragmentsData_hero.fromJson(Map<String, dynamic> json) {
    return GHeroWith2FragmentsData_hero(
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
      id: (json['id'] as String),
    );
  }

  final String name;

  final String G__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['name'] = name;
    result['__typename'] = G__typename;
    result['id'] = id;
    return result;
  }
}

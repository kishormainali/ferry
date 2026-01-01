// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHeroNoVarsData {
  const GHeroNoVarsData({
    this.hero,
    required this.G__typename,
  });

  factory GHeroNoVarsData.fromJson(Map<String, dynamic> json) {
    return GHeroNoVarsData(
      hero: json['hero'] == null
          ? null
          : GHeroNoVarsData_hero.fromJson(
              (json['hero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GHeroNoVarsData_hero? hero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final heroValue = hero;
    result['hero'] = heroValue == null ? null : heroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GHeroNoVarsData copyWith({
    GHeroNoVarsData_hero? hero,
    bool heroIsSet = false,
    String? G__typename,
  }) {
    return GHeroNoVarsData(
      hero: heroIsSet ? hero : this.hero,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHeroNoVarsData &&
            hero == other.hero &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, hero, G__typename]);
  }

  @override
  String toString() {
    return 'GHeroNoVarsData(hero: $hero, G__typename: $G__typename)';
  }
}

class GHeroNoVarsData_hero {
  const GHeroNoVarsData_hero({
    required this.id,
    required this.name,
    required this.G__typename,
  });

  factory GHeroNoVarsData_hero.fromJson(Map<String, dynamic> json) {
    return GHeroNoVarsData_hero(
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

  GHeroNoVarsData_hero copyWith({
    String? id,
    String? name,
    String? G__typename,
  }) {
    return GHeroNoVarsData_hero(
      id: id ?? this.id,
      name: name ?? this.name,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHeroNoVarsData_hero &&
            id == other.id &&
            name == other.name &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, id, name, G__typename]);
  }

  @override
  String toString() {
    return 'GHeroNoVarsData_hero(id: $id, name: $name, G__typename: $G__typename)';
  }
}

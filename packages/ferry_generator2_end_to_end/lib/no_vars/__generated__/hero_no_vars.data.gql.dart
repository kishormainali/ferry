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
}

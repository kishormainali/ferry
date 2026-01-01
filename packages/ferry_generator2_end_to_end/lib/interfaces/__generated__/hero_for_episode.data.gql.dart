// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

abstract class GDroidFragment {
  String? get primaryFunction;
  String get G__typename;
}

class GDroidFragmentData implements GDroidFragment {
  const GDroidFragmentData({
    this.primaryFunction,
    required this.G__typename,
  });

  factory GDroidFragmentData.fromJson(Map<String, dynamic> json) {
    return GDroidFragmentData(
      primaryFunction: json['primaryFunction'] == null
          ? null
          : (json['primaryFunction'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final String? primaryFunction;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final primaryFunctionValue = primaryFunction;
    result['primaryFunction'] =
        primaryFunctionValue == null ? null : primaryFunctionValue;
    result['__typename'] = G__typename;
    return result;
  }

  GDroidFragmentData copyWith({
    String? primaryFunction,
    bool primaryFunctionIsSet = false,
    String? G__typename,
  }) {
    return GDroidFragmentData(
      primaryFunction:
          primaryFunctionIsSet ? primaryFunction : this.primaryFunction,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GDroidFragmentData &&
            primaryFunction == other.primaryFunction &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, primaryFunction, G__typename]);
  }

  @override
  String toString() {
    return 'GDroidFragmentData(primaryFunction: $primaryFunction, G__typename: $G__typename)';
  }
}

class GHeroForEpisodeData {
  const GHeroForEpisodeData({
    this.hero,
    required this.G__typename,
  });

  factory GHeroForEpisodeData.fromJson(Map<String, dynamic> json) {
    return GHeroForEpisodeData(
      hero: json['hero'] == null
          ? null
          : GHeroForEpisodeData_hero.fromJson(
              (json['hero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GHeroForEpisodeData_hero? hero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final heroValue = hero;
    result['hero'] = heroValue == null ? null : heroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GHeroForEpisodeData copyWith({
    GHeroForEpisodeData_hero? hero,
    bool heroIsSet = false,
    String? G__typename,
  }) {
    return GHeroForEpisodeData(
      hero: heroIsSet ? hero : this.hero,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHeroForEpisodeData &&
            hero == other.hero &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, hero, G__typename]);
  }

  @override
  String toString() {
    return 'GHeroForEpisodeData(hero: $hero, G__typename: $G__typename)';
  }
}

sealed class GHeroForEpisodeData_hero {
  const GHeroForEpisodeData_hero({
    required this.name,
    this.friends,
    required this.G__typename,
  });

  factory GHeroForEpisodeData_hero.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Droid':
        return GHeroForEpisodeData_hero__asDroid.fromJson(json);
      default:
        return GHeroForEpisodeData_hero__unknown.fromJson(json);
    }
  }

  final String name;

  final List<GHeroForEpisodeData_hero_friends?>? friends;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['name'] = name;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

extension GHeroForEpisodeData_heroWhenExtension on GHeroForEpisodeData_hero {
  _T when<_T>({
    required _T Function(GHeroForEpisodeData_hero__asDroid) droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Droid':
        return droid(this as GHeroForEpisodeData_hero__asDroid);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GHeroForEpisodeData_hero__asDroid)? droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(this as GHeroForEpisodeData_hero__asDroid);
      default:
        return orElse();
    }
  }
}

class GHeroForEpisodeData_hero_friends {
  const GHeroForEpisodeData_hero_friends({
    required this.name,
    required this.G__typename,
  });

  factory GHeroForEpisodeData_hero_friends.fromJson(Map<String, dynamic> json) {
    return GHeroForEpisodeData_hero_friends(
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

  GHeroForEpisodeData_hero_friends copyWith({
    String? name,
    String? G__typename,
  }) {
    return GHeroForEpisodeData_hero_friends(
      name: name ?? this.name,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHeroForEpisodeData_hero_friends &&
            name == other.name &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, name, G__typename]);
  }

  @override
  String toString() {
    return 'GHeroForEpisodeData_hero_friends(name: $name, G__typename: $G__typename)';
  }
}

class GHeroForEpisodeData_hero__asDroid extends GHeroForEpisodeData_hero
    implements GDroidFragment {
  const GHeroForEpisodeData_hero__asDroid({
    required name,
    friends,
    required G__typename,
    this.primaryFunction,
  }) : super(name: name, friends: friends, G__typename: G__typename);

  factory GHeroForEpisodeData_hero__asDroid.fromJson(
      Map<String, dynamic> json) {
    return GHeroForEpisodeData_hero__asDroid(
      name: (json['name'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GHeroForEpisodeData_hero_friends.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
      primaryFunction: json['primaryFunction'] == null
          ? null
          : (json['primaryFunction'] as String),
    );
  }

  final String? primaryFunction;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['name'] = name;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    final primaryFunctionValue = primaryFunction;
    result['primaryFunction'] =
        primaryFunctionValue == null ? null : primaryFunctionValue;
    return result;
  }

  GHeroForEpisodeData_hero__asDroid copyWith({
    String? name,
    List<GHeroForEpisodeData_hero_friends?>? friends,
    bool friendsIsSet = false,
    String? G__typename,
    String? primaryFunction,
    bool primaryFunctionIsSet = false,
  }) {
    return GHeroForEpisodeData_hero__asDroid(
      name: name ?? this.name,
      friends: friendsIsSet ? friends : this.friends,
      G__typename: G__typename ?? this.G__typename,
      primaryFunction:
          primaryFunctionIsSet ? primaryFunction : this.primaryFunction,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHeroForEpisodeData_hero__asDroid &&
            name == other.name &&
            friends == other.friends &&
            G__typename == other.G__typename &&
            primaryFunction == other.primaryFunction);
  }

  @override
  int get hashCode {
    return Object.hashAll(
        [runtimeType, name, friends, G__typename, primaryFunction]);
  }

  @override
  String toString() {
    return 'GHeroForEpisodeData_hero__asDroid(name: $name, friends: $friends, G__typename: $G__typename, primaryFunction: $primaryFunction)';
  }
}

class GHeroForEpisodeData_hero__unknown extends GHeroForEpisodeData_hero {
  const GHeroForEpisodeData_hero__unknown({
    required name,
    friends,
    required G__typename,
  }) : super(name: name, friends: friends, G__typename: G__typename);

  factory GHeroForEpisodeData_hero__unknown.fromJson(
      Map<String, dynamic> json) {
    return GHeroForEpisodeData_hero__unknown(
      name: (json['name'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GHeroForEpisodeData_hero_friends.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['name'] = name;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GHeroForEpisodeData_hero__unknown copyWith({
    String? name,
    List<GHeroForEpisodeData_hero_friends?>? friends,
    bool friendsIsSet = false,
    String? G__typename,
  }) {
    return GHeroForEpisodeData_hero__unknown(
      name: name ?? this.name,
      friends: friendsIsSet ? friends : this.friends,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHeroForEpisodeData_hero__unknown &&
            name == other.name &&
            friends == other.friends &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, name, friends, G__typename]);
  }

  @override
  String toString() {
    return 'GHeroForEpisodeData_hero__unknown(name: $name, friends: $friends, G__typename: $G__typename)';
  }
}

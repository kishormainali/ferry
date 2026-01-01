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
}

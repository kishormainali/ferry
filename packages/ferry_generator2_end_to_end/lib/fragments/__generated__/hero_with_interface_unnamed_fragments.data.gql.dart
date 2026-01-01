// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHeroWithInterfaceUnnamedFragmentsData {
  const GHeroWithInterfaceUnnamedFragmentsData({
    this.hero,
    required this.G__typename,
  });

  factory GHeroWithInterfaceUnnamedFragmentsData.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData(
      hero: json['hero'] == null
          ? null
          : GHeroWithInterfaceUnnamedFragmentsData_hero.fromJson(
              (json['hero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GHeroWithInterfaceUnnamedFragmentsData_hero? hero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final heroValue = hero;
    result['hero'] = heroValue == null ? null : heroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

sealed class GHeroWithInterfaceUnnamedFragmentsData_hero {
  const GHeroWithInterfaceUnnamedFragmentsData_hero({
    required this.id,
    required this.name,
    required this.G__typename,
  });

  factory GHeroWithInterfaceUnnamedFragmentsData_hero.fromJson(
      Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Human':
        return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman.fromJson(
            json);
      case 'Droid':
        return GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid.fromJson(
            json);
      default:
        return GHeroWithInterfaceUnnamedFragmentsData_hero__unknown.fromJson(
            json);
    }
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

extension GHeroWithInterfaceUnnamedFragmentsData_heroWhenExtension
    on GHeroWithInterfaceUnnamedFragmentsData_hero {
  _T when<_T>({
    required _T Function(GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman)
        human,
    required _T Function(GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid)
        droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human(
            this as GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman);
      case 'Droid':
        return droid(
            this as GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman)? human,
    _T Function(GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid)? droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human == null
            ? orElse()
            : human(
                this as GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman);
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(
                this as GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid);
      default:
        return orElse();
    }
  }
}

class GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman
    extends GHeroWithInterfaceUnnamedFragmentsData_hero {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman({
    required id,
    required name,
    required G__typename,
    this.homePlanet,
    this.friends,
  }) : super(id: id, name: name, G__typename: G__typename);

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman(
      id: (json['id'] as String),
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
      homePlanet:
          json['homePlanet'] == null ? null : (json['homePlanet'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends
                      .fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  final String? homePlanet;

  final List<GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends?>?
      friends;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['id'] = id;
    result['name'] = name;
    result['__typename'] = G__typename;
    final homePlanetValue = homePlanet;
    result['homePlanet'] = homePlanetValue == null ? null : homePlanetValue;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    return result;
  }
}

sealed class GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends(
      {required this.G__typename});

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends.fromJson(
      Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Human':
        return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman
            .fromJson(json);
      case 'Droid':
        return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid
            .fromJson(json);
      default:
        return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__unknown
            .fromJson(json);
    }
  }

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['__typename'] = G__typename;
    return result;
  }
}

extension GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friendsWhenExtension
    on GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends {
  _T when<_T>({
    required _T Function(
            GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman)
        human,
    required _T Function(
            GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid)
        droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human(this
            as GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman);
      case 'Droid':
        return droid(this
            as GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(
            GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman)?
        human,
    _T Function(
            GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid)?
        droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human == null
            ? orElse()
            : human(this
                as GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman);
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(this
                as GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid);
      default:
        return orElse();
    }
  }
}

class GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman
    extends GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman({
    required G__typename,
    required this.id,
    required this.name,
    this.homePlanet,
  }) : super(G__typename: G__typename);

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asHuman(
      G__typename: (json['__typename'] as String),
      id: (json['id'] as String),
      name: (json['name'] as String),
      homePlanet:
          json['homePlanet'] == null ? null : (json['homePlanet'] as String),
    );
  }

  final String id;

  final String name;

  final String? homePlanet;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    result['id'] = id;
    result['name'] = name;
    final homePlanetValue = homePlanet;
    result['homePlanet'] = homePlanetValue == null ? null : homePlanetValue;
    return result;
  }
}

class GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid
    extends GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid({
    required G__typename,
    required this.id,
    required this.name,
    this.primaryFunction,
  }) : super(G__typename: G__typename);

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__asDroid(
      G__typename: (json['__typename'] as String),
      id: (json['id'] as String),
      name: (json['name'] as String),
      primaryFunction: json['primaryFunction'] == null
          ? null
          : (json['primaryFunction'] as String),
    );
  }

  final String id;

  final String name;

  final String? primaryFunction;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    result['id'] = id;
    result['name'] = name;
    final primaryFunctionValue = primaryFunction;
    result['primaryFunction'] =
        primaryFunctionValue == null ? null : primaryFunctionValue;
    return result;
  }
}

class GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__unknown
    extends GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__unknown(
      {required G__typename})
      : super(G__typename: G__typename);

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__unknown.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData_hero__asHuman_friends__unknown(
        G__typename: (json['__typename'] as String));
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid
    extends GHeroWithInterfaceUnnamedFragmentsData_hero {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid({
    required id,
    required name,
    required G__typename,
    this.primaryFunction,
  }) : super(id: id, name: name, G__typename: G__typename);

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData_hero__asDroid(
      id: (json['id'] as String),
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
      primaryFunction: json['primaryFunction'] == null
          ? null
          : (json['primaryFunction'] as String),
    );
  }

  final String? primaryFunction;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['id'] = id;
    result['name'] = name;
    result['__typename'] = G__typename;
    final primaryFunctionValue = primaryFunction;
    result['primaryFunction'] =
        primaryFunctionValue == null ? null : primaryFunctionValue;
    return result;
  }
}

class GHeroWithInterfaceUnnamedFragmentsData_hero__unknown
    extends GHeroWithInterfaceUnnamedFragmentsData_hero {
  const GHeroWithInterfaceUnnamedFragmentsData_hero__unknown({
    required id,
    required name,
    required G__typename,
  }) : super(id: id, name: name, G__typename: G__typename);

  factory GHeroWithInterfaceUnnamedFragmentsData_hero__unknown.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceUnnamedFragmentsData_hero__unknown(
      id: (json['id'] as String),
      name: (json['name'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['id'] = id;
    result['name'] = name;
    result['__typename'] = G__typename;
    return result;
  }
}

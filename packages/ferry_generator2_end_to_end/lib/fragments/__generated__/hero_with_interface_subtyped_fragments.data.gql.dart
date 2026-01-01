// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

abstract class GheroFieldsFragment {
  String get id;
  String get name;
  String get G__typename;
}

abstract class GheroFieldsFragment__asHuman implements GheroFieldsFragment {
  String? get homePlanet;
  List<GheroFieldsFragment__asHuman_friends?>? get friends;
  String get G__typename;
}

abstract class GheroFieldsFragment__asHuman_friends {
  String get G__typename;
}

abstract class GheroFieldsFragment__asDroid implements GheroFieldsFragment {
  String? get primaryFunction;
  String get G__typename;
}

sealed class GheroFieldsFragmentData implements GheroFieldsFragment {
  const GheroFieldsFragmentData({
    required this.id,
    required this.name,
    required this.G__typename,
  });

  factory GheroFieldsFragmentData.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Human':
        return GheroFieldsFragmentData__asHuman.fromJson(json);
      case 'Droid':
        return GheroFieldsFragmentData__asDroid.fromJson(json);
      default:
        return GheroFieldsFragmentData__unknown.fromJson(json);
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

extension GheroFieldsFragmentDataWhenExtension on GheroFieldsFragmentData {
  _T when<_T>({
    required _T Function(GheroFieldsFragmentData__asHuman) human,
    required _T Function(GheroFieldsFragmentData__asDroid) droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human(this as GheroFieldsFragmentData__asHuman);
      case 'Droid':
        return droid(this as GheroFieldsFragmentData__asDroid);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GheroFieldsFragmentData__asHuman)? human,
    _T Function(GheroFieldsFragmentData__asDroid)? droid,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Human':
        return human == null
            ? orElse()
            : human(this as GheroFieldsFragmentData__asHuman);
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(this as GheroFieldsFragmentData__asDroid);
      default:
        return orElse();
    }
  }
}

class GheroFieldsFragmentData__asHuman extends GheroFieldsFragmentData
    implements
        GheroFieldsFragment,
        GhumanFieldsFragment,
        GheroFieldsFragment__asHuman {
  const GheroFieldsFragmentData__asHuman({
    required id,
    required name,
    required G__typename,
    this.homePlanet,
    this.friends,
  }) : super(id: id, name: name, G__typename: G__typename);

  factory GheroFieldsFragmentData__asHuman.fromJson(Map<String, dynamic> json) {
    return GheroFieldsFragmentData__asHuman(
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
                  : GheroFieldsFragmentData__asHuman_friends.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
    );
  }

  final String? homePlanet;

  final List<GheroFieldsFragmentData__asHuman_friends?>? friends;

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

sealed class GheroFieldsFragmentData__asHuman_friends
    implements
        GhumanFieldsFragment_friends,
        GheroFieldsFragment__asHuman_friends {
  const GheroFieldsFragmentData__asHuman_friends({required this.G__typename});

  factory GheroFieldsFragmentData__asHuman_friends.fromJson(
      Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Droid':
        return GheroFieldsFragmentData__asHuman_friends__asDroid.fromJson(json);
      case 'Human':
        return GheroFieldsFragmentData__asHuman_friends__asHuman.fromJson(json);
      default:
        return GheroFieldsFragmentData__asHuman_friends__unknown.fromJson(json);
    }
  }

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['__typename'] = G__typename;
    return result;
  }
}

extension GheroFieldsFragmentData__asHuman_friendsWhenExtension
    on GheroFieldsFragmentData__asHuman_friends {
  _T when<_T>({
    required _T Function(GheroFieldsFragmentData__asHuman_friends__asDroid)
        droid,
    required _T Function(GheroFieldsFragmentData__asHuman_friends__asHuman)
        human,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Droid':
        return droid(this as GheroFieldsFragmentData__asHuman_friends__asDroid);
      case 'Human':
        return human(this as GheroFieldsFragmentData__asHuman_friends__asHuman);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GheroFieldsFragmentData__asHuman_friends__asDroid)? droid,
    _T Function(GheroFieldsFragmentData__asHuman_friends__asHuman)? human,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(this as GheroFieldsFragmentData__asHuman_friends__asDroid);
      case 'Human':
        return human == null
            ? orElse()
            : human(this as GheroFieldsFragmentData__asHuman_friends__asHuman);
      default:
        return orElse();
    }
  }
}

class GheroFieldsFragmentData__asHuman_friends__asDroid
    extends GheroFieldsFragmentData__asHuman_friends
    implements
        GhumanFieldsFragment_friends,
        GheroFieldsFragment__asHuman_friends,
        GdroidFieldsFragment {
  const GheroFieldsFragmentData__asHuman_friends__asDroid({
    required G__typename,
    required this.id,
    required this.name,
    this.primaryFunction,
  }) : super(G__typename: G__typename);

  factory GheroFieldsFragmentData__asHuman_friends__asDroid.fromJson(
      Map<String, dynamic> json) {
    return GheroFieldsFragmentData__asHuman_friends__asDroid(
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

class GheroFieldsFragmentData__asHuman_friends__asHuman
    extends GheroFieldsFragmentData__asHuman_friends
    implements
        GhumanFieldsFragment_friends,
        GheroFieldsFragment__asHuman_friends {
  const GheroFieldsFragmentData__asHuman_friends__asHuman({
    required G__typename,
    required this.id,
    required this.name,
    this.homePlanet,
  }) : super(G__typename: G__typename);

  factory GheroFieldsFragmentData__asHuman_friends__asHuman.fromJson(
      Map<String, dynamic> json) {
    return GheroFieldsFragmentData__asHuman_friends__asHuman(
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

class GheroFieldsFragmentData__asHuman_friends__unknown
    extends GheroFieldsFragmentData__asHuman_friends
    implements
        GhumanFieldsFragment_friends,
        GheroFieldsFragment__asHuman_friends {
  const GheroFieldsFragmentData__asHuman_friends__unknown(
      {required G__typename})
      : super(G__typename: G__typename);

  factory GheroFieldsFragmentData__asHuman_friends__unknown.fromJson(
      Map<String, dynamic> json) {
    return GheroFieldsFragmentData__asHuman_friends__unknown(
        G__typename: (json['__typename'] as String));
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GheroFieldsFragmentData__asDroid extends GheroFieldsFragmentData
    implements
        GheroFieldsFragment,
        GdroidFieldsFragment,
        GheroFieldsFragment__asDroid {
  const GheroFieldsFragmentData__asDroid({
    required id,
    required name,
    required G__typename,
    this.primaryFunction,
  }) : super(id: id, name: name, G__typename: G__typename);

  factory GheroFieldsFragmentData__asDroid.fromJson(Map<String, dynamic> json) {
    return GheroFieldsFragmentData__asDroid(
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

class GheroFieldsFragmentData__unknown extends GheroFieldsFragmentData
    implements GheroFieldsFragment {
  const GheroFieldsFragmentData__unknown({
    required id,
    required name,
    required G__typename,
  }) : super(id: id, name: name, G__typename: G__typename);

  factory GheroFieldsFragmentData__unknown.fromJson(Map<String, dynamic> json) {
    return GheroFieldsFragmentData__unknown(
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

abstract class GhumanFieldsFragment {
  String? get homePlanet;
  List<GhumanFieldsFragment_friends?>? get friends;
  String get G__typename;
}

abstract class GhumanFieldsFragment_friends {
  String get G__typename;
}

class GhumanFieldsFragmentData implements GhumanFieldsFragment {
  const GhumanFieldsFragmentData({
    this.homePlanet,
    this.friends,
    required this.G__typename,
  });

  factory GhumanFieldsFragmentData.fromJson(Map<String, dynamic> json) {
    return GhumanFieldsFragmentData(
      homePlanet:
          json['homePlanet'] == null ? null : (json['homePlanet'] as String),
      friends: json['friends'] == null
          ? null
          : (json['friends'] as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : GhumanFieldsFragmentData_friends.fromJson(
                      (e as Map<String, dynamic>)))
              .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final String? homePlanet;

  final List<GhumanFieldsFragmentData_friends?>? friends;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final homePlanetValue = homePlanet;
    result['homePlanet'] = homePlanetValue == null ? null : homePlanetValue;
    final friendsValue = friends;
    result['friends'] = friendsValue == null
        ? null
        : friendsValue.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }
}

sealed class GhumanFieldsFragmentData_friends
    implements GhumanFieldsFragment_friends {
  const GhumanFieldsFragmentData_friends({required this.G__typename});

  factory GhumanFieldsFragmentData_friends.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Droid':
        return GhumanFieldsFragmentData_friends__asDroid.fromJson(json);
      case 'Human':
        return GhumanFieldsFragmentData_friends__asHuman.fromJson(json);
      default:
        return GhumanFieldsFragmentData_friends__unknown.fromJson(json);
    }
  }

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['__typename'] = G__typename;
    return result;
  }
}

extension GhumanFieldsFragmentData_friendsWhenExtension
    on GhumanFieldsFragmentData_friends {
  _T when<_T>({
    required _T Function(GhumanFieldsFragmentData_friends__asDroid) droid,
    required _T Function(GhumanFieldsFragmentData_friends__asHuman) human,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Droid':
        return droid(this as GhumanFieldsFragmentData_friends__asDroid);
      case 'Human':
        return human(this as GhumanFieldsFragmentData_friends__asHuman);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GhumanFieldsFragmentData_friends__asDroid)? droid,
    _T Function(GhumanFieldsFragmentData_friends__asHuman)? human,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Droid':
        return droid == null
            ? orElse()
            : droid(this as GhumanFieldsFragmentData_friends__asDroid);
      case 'Human':
        return human == null
            ? orElse()
            : human(this as GhumanFieldsFragmentData_friends__asHuman);
      default:
        return orElse();
    }
  }
}

class GhumanFieldsFragmentData_friends__asDroid
    extends GhumanFieldsFragmentData_friends
    implements GhumanFieldsFragment_friends, GdroidFieldsFragment {
  const GhumanFieldsFragmentData_friends__asDroid({
    required G__typename,
    required this.id,
    required this.name,
    this.primaryFunction,
  }) : super(G__typename: G__typename);

  factory GhumanFieldsFragmentData_friends__asDroid.fromJson(
      Map<String, dynamic> json) {
    return GhumanFieldsFragmentData_friends__asDroid(
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

class GhumanFieldsFragmentData_friends__asHuman
    extends GhumanFieldsFragmentData_friends
    implements GhumanFieldsFragment_friends {
  const GhumanFieldsFragmentData_friends__asHuman({
    required G__typename,
    required this.id,
    required this.name,
    this.homePlanet,
  }) : super(G__typename: G__typename);

  factory GhumanFieldsFragmentData_friends__asHuman.fromJson(
      Map<String, dynamic> json) {
    return GhumanFieldsFragmentData_friends__asHuman(
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

class GhumanFieldsFragmentData_friends__unknown
    extends GhumanFieldsFragmentData_friends
    implements GhumanFieldsFragment_friends {
  const GhumanFieldsFragmentData_friends__unknown({required G__typename})
      : super(G__typename: G__typename);

  factory GhumanFieldsFragmentData_friends__unknown.fromJson(
      Map<String, dynamic> json) {
    return GhumanFieldsFragmentData_friends__unknown(
        G__typename: (json['__typename'] as String));
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

abstract class GdroidFieldsFragment {
  String? get primaryFunction;
  String get G__typename;
}

class GdroidFieldsFragmentData implements GdroidFieldsFragment {
  const GdroidFieldsFragmentData({
    this.primaryFunction,
    required this.G__typename,
  });

  factory GdroidFieldsFragmentData.fromJson(Map<String, dynamic> json) {
    return GdroidFieldsFragmentData(
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

class GHeroWithInterfaceSubTypedFragmentsData {
  const GHeroWithInterfaceSubTypedFragmentsData({
    this.hero,
    required this.G__typename,
  });

  factory GHeroWithInterfaceSubTypedFragmentsData.fromJson(
      Map<String, dynamic> json) {
    return GHeroWithInterfaceSubTypedFragmentsData(
      hero: json['hero'] == null
          ? null
          : GheroFieldsFragmentData.fromJson(
              (json['hero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GheroFieldsFragmentData? hero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final heroValue = hero;
    result['hero'] = heroValue == null ? null : heroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

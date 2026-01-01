// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.utils.gql.dart'
    as _gqlUtils;

class GAliasedHeroData {
  const GAliasedHeroData({
    this.empireHero,
    this.jediHero,
    required this.G__typename,
  });

  factory GAliasedHeroData.fromJson(Map<String, dynamic> json) {
    return GAliasedHeroData(
      empireHero: json['empireHero'] == null
          ? null
          : GAliasedHeroData_empireHero.fromJson(
              (json['empireHero'] as Map<String, dynamic>)),
      jediHero: json['jediHero'] == null
          ? null
          : GAliasedHeroData_jediHero.fromJson(
              (json['jediHero'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GAliasedHeroData_empireHero? empireHero;

  final GAliasedHeroData_jediHero? jediHero;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final empireHeroValue = empireHero;
    result['empireHero'] =
        empireHeroValue == null ? null : empireHeroValue.toJson();
    final jediHeroValue = jediHero;
    result['jediHero'] = jediHeroValue == null ? null : jediHeroValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GAliasedHeroData copyWith({
    GAliasedHeroData_empireHero? empireHero,
    bool empireHeroIsSet = false,
    GAliasedHeroData_jediHero? jediHero,
    bool jediHeroIsSet = false,
    String? G__typename,
  }) {
    return GAliasedHeroData(
      empireHero: empireHeroIsSet ? empireHero : this.empireHero,
      jediHero: jediHeroIsSet ? jediHero : this.jediHero,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GAliasedHeroData &&
            empireHero == other.empireHero &&
            jediHero == other.jediHero &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, empireHero, jediHero, G__typename);
  }

  @override
  String toString() {
    return 'GAliasedHeroData(empireHero: $empireHero, jediHero: $jediHero, G__typename: $G__typename)';
  }
}

class GAliasedHeroData_empireHero {
  const GAliasedHeroData_empireHero({
    required this.id,
    required this.name,
    required this.from,
    required this.G__typename,
  });

  factory GAliasedHeroData_empireHero.fromJson(Map<String, dynamic> json) {
    return GAliasedHeroData_empireHero(
      id: (json['id'] as String),
      name: (json['name'] as String),
      from: (json['from'] as List<dynamic>)
          .map((e) => e == null ? null : _i1.GEpisode.fromJson((e as String)))
          .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final String name;

  final List<_i1.GEpisode?> from;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['name'] = name;
    result['from'] = from.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GAliasedHeroData_empireHero copyWith({
    String? id,
    String? name,
    List<_i1.GEpisode?>? from,
    String? G__typename,
  }) {
    return GAliasedHeroData_empireHero(
      id: id ?? this.id,
      name: name ?? this.name,
      from: from ?? this.from,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GAliasedHeroData_empireHero &&
            id == other.id &&
            name == other.name &&
            _gqlUtils.listEquals(from, other.from) &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, id, name, _gqlUtils.listHash(from), G__typename);
  }

  @override
  String toString() {
    return 'GAliasedHeroData_empireHero(id: $id, name: $name, from: $from, G__typename: $G__typename)';
  }
}

class GAliasedHeroData_jediHero {
  const GAliasedHeroData_jediHero({
    required this.id,
    required this.name,
    required this.from,
    required this.G__typename,
  });

  factory GAliasedHeroData_jediHero.fromJson(Map<String, dynamic> json) {
    return GAliasedHeroData_jediHero(
      id: (json['id'] as String),
      name: (json['name'] as String),
      from: (json['from'] as List<dynamic>)
          .map((e) => e == null ? null : _i1.GEpisode.fromJson((e as String)))
          .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final String id;

  final String name;

  final List<_i1.GEpisode?> from;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['id'] = id;
    result['name'] = name;
    result['from'] = from.map((e) => e == null ? null : e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GAliasedHeroData_jediHero copyWith({
    String? id,
    String? name,
    List<_i1.GEpisode?>? from,
    String? G__typename,
  }) {
    return GAliasedHeroData_jediHero(
      id: id ?? this.id,
      name: name ?? this.name,
      from: from ?? this.from,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GAliasedHeroData_jediHero &&
            id == other.id &&
            name == other.name &&
            _gqlUtils.listEquals(from, other.from) &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, id, name, _gqlUtils.listHash(from), G__typename);
  }

  @override
  String toString() {
    return 'GAliasedHeroData_jediHero(id: $id, name: $name, from: $from, G__typename: $G__typename)';
  }
}

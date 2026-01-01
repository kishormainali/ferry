// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.schema.gql.dart'
    as _i1;

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
}

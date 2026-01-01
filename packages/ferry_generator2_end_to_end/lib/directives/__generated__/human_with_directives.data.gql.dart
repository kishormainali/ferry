// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHumanWithDirectivesData {
  const GHumanWithDirectivesData({
    this.human,
    required this.G__typename,
  });

  factory GHumanWithDirectivesData.fromJson(Map<String, dynamic> json) {
    return GHumanWithDirectivesData(
      human: json['human'] == null
          ? null
          : GHumanWithDirectivesData_human.fromJson(
              (json['human'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GHumanWithDirectivesData_human? human;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final humanValue = human;
    result['human'] = humanValue == null ? null : humanValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GHumanWithDirectivesData_human {
  const GHumanWithDirectivesData_human({
    this.id,
    this.name,
    required this.G__typename,
  });

  factory GHumanWithDirectivesData_human.fromJson(Map<String, dynamic> json) {
    return GHumanWithDirectivesData_human(
      id: json['id'] == null ? null : (json['id'] as String),
      name: json['name'] == null ? null : (json['name'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final String? id;

  final String? name;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final idValue = id;
    result['id'] = idValue == null ? null : idValue;
    final nameValue = name;
    result['name'] = nameValue == null ? null : nameValue;
    result['__typename'] = G__typename;
    return result;
  }
}

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

  GHumanWithDirectivesData copyWith({
    GHumanWithDirectivesData_human? human,
    bool humanIsSet = false,
    String? G__typename,
  }) {
    return GHumanWithDirectivesData(
      human: humanIsSet ? human : this.human,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHumanWithDirectivesData &&
            human == other.human &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hashAll([runtimeType, human, G__typename]);
  }

  @override
  String toString() {
    return 'GHumanWithDirectivesData(human: $human, G__typename: $G__typename)';
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

  GHumanWithDirectivesData_human copyWith({
    String? id,
    bool idIsSet = false,
    String? name,
    bool nameIsSet = false,
    String? G__typename,
  }) {
    return GHumanWithDirectivesData_human(
      id: idIsSet ? id : this.id,
      name: nameIsSet ? name : this.name,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GHumanWithDirectivesData_human &&
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
    return 'GHumanWithDirectivesData_human(id: $id, name: $name, G__typename: $G__typename)';
  }
}

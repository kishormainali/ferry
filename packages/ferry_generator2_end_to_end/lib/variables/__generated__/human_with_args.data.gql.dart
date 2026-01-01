// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GHumanWithArgsData {
  const GHumanWithArgsData({
    this.human,
    required this.G__typename,
  });

  factory GHumanWithArgsData.fromJson(Map<String, dynamic> json) {
    return GHumanWithArgsData(
      human: json['human'] == null
          ? null
          : GHumanWithArgsData_human.fromJson(
              (json['human'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  final GHumanWithArgsData_human? human;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final humanValue = human;
    result['human'] = humanValue == null ? null : humanValue.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

class GHumanWithArgsData_human {
  const GHumanWithArgsData_human({
    required this.name,
    this.height,
    required this.G__typename,
  });

  factory GHumanWithArgsData_human.fromJson(Map<String, dynamic> json) {
    return GHumanWithArgsData_human(
      name: (json['name'] as String),
      height: json['height'] == null ? null : (json['height'] as double),
      G__typename: (json['__typename'] as String),
    );
  }

  final String name;

  final double? height;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['name'] = name;
    final heightValue = height;
    result['height'] = heightValue == null ? null : heightValue;
    result['__typename'] = G__typename;
    return result;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GPostsVars {
  const GPostsVars({required this.userId});

  factory GPostsVars.fromJson(Map<String, dynamic> json) {
    return GPostsVars(userId: (json['userId'] as String));
  }

  final String userId;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$userIdValue = this.userId;
    _$result['userId'] = _$userIdValue;
    return _$result;
  }
}

class GPostFragmentVars {
  const GPostFragmentVars({required this.userId});

  factory GPostFragmentVars.fromJson(Map<String, dynamic> json) {
    return GPostFragmentVars(userId: (json['userId'] as String));
  }

  final String userId;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$userIdValue = this.userId;
    _$result['userId'] = _$userIdValue;
    return _$result;
  }
}

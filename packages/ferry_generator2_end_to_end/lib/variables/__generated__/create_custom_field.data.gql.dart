// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

class GCreateCustomFieldData {
  const GCreateCustomFieldData({
    this.createCustomField,
    required this.G__typename,
  });

  factory GCreateCustomFieldData.fromJson(Map<String, dynamic> json) {
    return GCreateCustomFieldData(
      createCustomField: json['createCustomField'] == null
          ? null
          : (json['createCustomField'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  final String? createCustomField;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final createCustomFieldValue = createCustomField;
    result['createCustomField'] =
        createCustomFieldValue == null ? null : createCustomFieldValue;
    result['__typename'] = G__typename;
    return result;
  }
}

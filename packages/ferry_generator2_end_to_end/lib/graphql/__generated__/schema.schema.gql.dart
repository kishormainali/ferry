// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:ferry_generator2_end_to_end/custom/date.dart';
import 'package:gql_tristate_value/gql_tristate_value.dart';

enum GEpisode {
  NEWHOPE,
  EMPIRE,
  JEDI,
  gUnknownEnumValue;

  static GEpisode fromJson(String value) {
    switch (value) {
      case r'NEWHOPE':
        return GEpisode.NEWHOPE;
      case r'EMPIRE':
        return GEpisode.EMPIRE;
      case r'JEDI':
        return GEpisode.JEDI;
      default:
        return GEpisode.gUnknownEnumValue;
    }
  }

  String toJson() {
    switch (this) {
      case GEpisode.NEWHOPE:
        return r'NEWHOPE';
      case GEpisode.EMPIRE:
        return r'EMPIRE';
      case GEpisode.JEDI:
        return r'JEDI';
      case GEpisode.gUnknownEnumValue:
        return r'gUnknownEnumValue';
    }
  }
}

enum GLengthUnit {
  METER,
  FOOT,
  gUnknownEnumValue;

  static GLengthUnit fromJson(String value) {
    switch (value) {
      case r'METER':
        return GLengthUnit.METER;
      case r'FOOT':
        return GLengthUnit.FOOT;
      default:
        return GLengthUnit.gUnknownEnumValue;
    }
  }

  String toJson() {
    switch (this) {
      case GLengthUnit.METER:
        return r'METER';
      case GLengthUnit.FOOT:
        return r'FOOT';
      case GLengthUnit.gUnknownEnumValue:
        return r'gUnknownEnumValue';
    }
  }
}

class GReviewInput {
  const GReviewInput({
    required this.stars,
    this.commentary = const Value.absent(),
    this.favorite_color = const Value.absent(),
    this.seenOn = const Value.absent(),
  });

  factory GReviewInput.fromJson(Map<String, dynamic> json) {
    return GReviewInput(
      stars: (json['stars'] as int),
      commentary: json.containsKey('commentary')
          ? Value.present(json['commentary'] == null
              ? null
              : (json['commentary'] as String))
          : Value.absent(),
      favorite_color: json.containsKey('favorite_color')
          ? Value.present(json['favorite_color'] == null
              ? null
              : GColorInput.fromJson(
                  (json['favorite_color'] as Map<String, dynamic>)))
          : Value.absent(),
      seenOn: json.containsKey('seenOn')
          ? Value.present(json['seenOn'] == null
              ? null
              : (json['seenOn'] as List<dynamic>)
                  .map((e) => e == null ? null : customDateFromJson(e))
                  .toList())
          : Value.absent(),
    );
  }

  final int stars;

  final Value<String> commentary;

  final Value<GColorInput> favorite_color;

  final Value<List<CustomDate?>> seenOn;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final starsValue = stars;
    result['stars'] = starsValue;
    final commentaryValue = commentary;
    if (commentaryValue.isPresent) {
      final commentaryRequired = commentaryValue.requireValue;
      result['commentary'] =
          commentaryRequired == null ? null : commentaryRequired;
    }
    final favorite_colorValue = favorite_color;
    if (favorite_colorValue.isPresent) {
      final favorite_colorRequired = favorite_colorValue.requireValue;
      result['favorite_color'] = favorite_colorRequired == null
          ? null
          : favorite_colorRequired.toJson();
    }
    final seenOnValue = seenOn;
    if (seenOnValue.isPresent) {
      final seenOnRequired = seenOnValue.requireValue;
      result['seenOn'] = seenOnRequired == null
          ? null
          : seenOnRequired
              .map((e) => e == null ? null : customDateToJson(e))
              .toList();
    }
    return result;
  }
}

class GCustomFieldInput {
  const GCustomFieldInput({
    required this.id,
    this.customField = const Value.absent(),
  });

  factory GCustomFieldInput.fromJson(Map<String, dynamic> json) {
    return GCustomFieldInput(
      id: (json['id'] as String),
      customField: json.containsKey('customField')
          ? Value.present(json['customField'] == null
              ? null
              : (json['customField'] as String))
          : Value.absent(),
    );
  }

  final String id;

  final Value<String> customField;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final idValue = id;
    result['id'] = idValue;
    final customFieldValue = customField;
    if (customFieldValue.isPresent) {
      final customFieldRequired = customFieldValue.requireValue;
      result['customField'] =
          customFieldRequired == null ? null : customFieldRequired;
    }
    return result;
  }
}

class GColorInput {
  const GColorInput({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory GColorInput.fromJson(Map<String, dynamic> json) {
    return GColorInput(
      red: (json['red'] as int),
      green: (json['green'] as int),
      blue: (json['blue'] as int),
    );
  }

  final int red;

  final int green;

  final int blue;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final redValue = red;
    result['red'] = redValue;
    final greenValue = green;
    result['green'] = greenValue;
    final blueValue = blue;
    result['blue'] = blueValue;
    return result;
  }
}

class GPostLikesInput {
  const GPostLikesInput({required this.id});

  factory GPostLikesInput.fromJson(Map<String, dynamic> json) {
    return GPostLikesInput(id: (json['id'] as String));
  }

  final String id;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final idValue = id;
    result['id'] = idValue;
    return result;
  }
}

class GPostFavoritesInput {
  const GPostFavoritesInput({required this.id});

  factory GPostFavoritesInput.fromJson(Map<String, dynamic> json) {
    return GPostFavoritesInput(id: (json['id'] as String));
  }

  final String id;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    final idValue = id;
    result['id'] = idValue;
    return result;
  }
}

const Map<String, Set<String>> possibleTypesMap = {
  'Character': {
    'Human',
    'Droid',
  },
  'Author': {
    'Person',
    'Company',
  },
  'Book': {
    'Textbook',
    'ColoringBook',
  },
  'SearchResult': {
    'Human',
    'Droid',
    'Starship',
  },
};

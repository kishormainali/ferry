// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:ferry_generator2_end_to_end/custom/date.dart';
import 'package:gql_tristate_value/gql_tristate_value.dart';

/// The episodes in the Star Wars trilogy.
enum GEpisode {
  /// Star Wars Episode IV: A New Hope, released in 1977.
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

/// Input object sent when creating a new review.
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
                  .map((_$e) => _$e == null ? null : customDateFromJson(_$e))
                  .toList())
          : Value.absent(),
    );
  }

  /// 0-5 stars.
  final int stars;

  final Value<String> commentary;

  final Value<GColorInput> favorite_color;

  final Value<List<CustomDate?>> seenOn;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$starsValue = this.stars;
    _$result['stars'] = _$starsValue;
    final _$commentaryValue = this.commentary;
    if (_$commentaryValue.isPresent) {
      final _$commentaryRequired = _$commentaryValue.requireValue;
      _$result['commentary'] =
          _$commentaryRequired == null ? null : _$commentaryRequired;
    }
    final _$favorite_colorValue = this.favorite_color;
    if (_$favorite_colorValue.isPresent) {
      final _$favorite_colorRequired = _$favorite_colorValue.requireValue;
      _$result['favorite_color'] = _$favorite_colorRequired == null
          ? null
          : _$favorite_colorRequired.toJson();
    }
    final _$seenOnValue = this.seenOn;
    if (_$seenOnValue.isPresent) {
      final _$seenOnRequired = _$seenOnValue.requireValue;
      _$result['seenOn'] = _$seenOnRequired == null
          ? null
          : _$seenOnRequired
              .map((_$e) => _$e == null ? null : customDateToJson(_$e))
              .toList();
    }
    return _$result;
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
    final _$result = <String, dynamic>{};
    final _$idValue = this.id;
    _$result['id'] = _$idValue;
    final _$customFieldValue = this.customField;
    if (_$customFieldValue.isPresent) {
      final _$customFieldRequired = _$customFieldValue.requireValue;
      _$result['customField'] =
          _$customFieldRequired == null ? null : _$customFieldRequired;
    }
    return _$result;
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
    final _$result = <String, dynamic>{};
    final _$redValue = this.red;
    _$result['red'] = _$redValue;
    final _$greenValue = this.green;
    _$result['green'] = _$greenValue;
    final _$blueValue = this.blue;
    _$result['blue'] = _$blueValue;
    return _$result;
  }
}

class GPostLikesInput {
  const GPostLikesInput({required this.id});

  factory GPostLikesInput.fromJson(Map<String, dynamic> json) {
    return GPostLikesInput(id: (json['id'] as String));
  }

  final String id;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$idValue = this.id;
    _$result['id'] = _$idValue;
    return _$result;
  }
}

class GPostFavoritesInput {
  const GPostFavoritesInput({required this.id});

  factory GPostFavoritesInput.fromJson(Map<String, dynamic> json) {
    return GPostFavoritesInput(id: (json['id'] as String));
  }

  final String id;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    final _$idValue = this.id;
    _$result['id'] = _$idValue;
    return _$result;
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

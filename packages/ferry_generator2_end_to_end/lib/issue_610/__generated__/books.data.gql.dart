// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.utils.gql.dart'
    as _gqlUtils;

abstract class GAuthorFragment {
  String get displayName;
  String get G__typename;
}

abstract class GAuthorFragment__asPerson implements GAuthorFragment {
  String get firstName;
  String get lastName;
  String get G__typename;
}

abstract class GAuthorFragment__asCompany implements GAuthorFragment {
  String get name;
  String get G__typename;
}

sealed class GAuthorFragmentData implements GAuthorFragment {
  const GAuthorFragmentData({
    required this.displayName,
    required this.G__typename,
  });

  factory GAuthorFragmentData.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Person':
        return GAuthorFragmentData__asPerson.fromJson(json);
      case 'Company':
        return GAuthorFragmentData__asCompany.fromJson(json);
      default:
        return GAuthorFragmentData__unknown.fromJson(json);
    }
  }

  final String displayName;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    _$result['displayName'] = this.displayName;
    _$result['__typename'] = this.G__typename;
    return _$result;
  }
}

extension GAuthorFragmentDataWhenExtension on GAuthorFragmentData {
  _T when<_T>({
    required _T Function(GAuthorFragmentData__asPerson) person,
    required _T Function(GAuthorFragmentData__asCompany) company,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Person':
        return person(this as GAuthorFragmentData__asPerson);
      case 'Company':
        return company(this as GAuthorFragmentData__asCompany);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GAuthorFragmentData__asPerson)? person,
    _T Function(GAuthorFragmentData__asCompany)? company,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Person':
        return person == null
            ? orElse()
            : person(this as GAuthorFragmentData__asPerson);
      case 'Company':
        return company == null
            ? orElse()
            : company(this as GAuthorFragmentData__asCompany);
      default:
        return orElse();
    }
  }
}

class GAuthorFragmentData__asPerson extends GAuthorFragmentData
    implements GAuthorFragment, GAuthorFragment__asPerson {
  const GAuthorFragmentData__asPerson({
    required displayName,
    required G__typename,
    required this.firstName,
    required this.lastName,
  }) : super(displayName: displayName, G__typename: G__typename);

  factory GAuthorFragmentData__asPerson.fromJson(Map<String, dynamic> json) {
    return GAuthorFragmentData__asPerson(
      displayName: (json['displayName'] as String),
      G__typename: (json['__typename'] as String),
      firstName: (json['firstName'] as String),
      lastName: (json['lastName'] as String),
    );
  }

  final String firstName;

  final String lastName;

  Map<String, dynamic> toJson() {
    final _$result = super.toJson();
    _$result['firstName'] = this.firstName;
    _$result['lastName'] = this.lastName;
    return _$result;
  }

  GAuthorFragmentData__asPerson copyWith({
    String? displayName,
    String? G__typename,
    String? firstName,
    String? lastName,
  }) {
    return GAuthorFragmentData__asPerson(
      displayName: displayName ?? this.displayName,
      G__typename: G__typename ?? this.G__typename,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GAuthorFragmentData__asPerson &&
            displayName == other.displayName &&
            G__typename == other.G__typename &&
            firstName == other.firstName &&
            lastName == other.lastName);
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, displayName, G__typename, firstName, lastName);
  }

  @override
  String toString() {
    return 'GAuthorFragmentData__asPerson(displayName: $displayName, G__typename: $G__typename, firstName: $firstName, lastName: $lastName)';
  }
}

class GAuthorFragmentData__asCompany extends GAuthorFragmentData
    implements GAuthorFragment, GAuthorFragment__asCompany {
  const GAuthorFragmentData__asCompany({
    required displayName,
    required G__typename,
    required this.name,
  }) : super(displayName: displayName, G__typename: G__typename);

  factory GAuthorFragmentData__asCompany.fromJson(Map<String, dynamic> json) {
    return GAuthorFragmentData__asCompany(
      displayName: (json['displayName'] as String),
      G__typename: (json['__typename'] as String),
      name: (json['name'] as String),
    );
  }

  final String name;

  Map<String, dynamic> toJson() {
    final _$result = super.toJson();
    _$result['name'] = this.name;
    return _$result;
  }

  GAuthorFragmentData__asCompany copyWith({
    String? displayName,
    String? G__typename,
    String? name,
  }) {
    return GAuthorFragmentData__asCompany(
      displayName: displayName ?? this.displayName,
      G__typename: G__typename ?? this.G__typename,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GAuthorFragmentData__asCompany &&
            displayName == other.displayName &&
            G__typename == other.G__typename &&
            name == other.name);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, displayName, G__typename, name);
  }

  @override
  String toString() {
    return 'GAuthorFragmentData__asCompany(displayName: $displayName, G__typename: $G__typename, name: $name)';
  }
}

class GAuthorFragmentData__unknown extends GAuthorFragmentData
    implements GAuthorFragment {
  const GAuthorFragmentData__unknown({
    required displayName,
    required G__typename,
  }) : super(displayName: displayName, G__typename: G__typename);

  factory GAuthorFragmentData__unknown.fromJson(Map<String, dynamic> json) {
    return GAuthorFragmentData__unknown(
      displayName: (json['displayName'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final _$result = super.toJson();
    return _$result;
  }

  GAuthorFragmentData__unknown copyWith({
    String? displayName,
    String? G__typename,
  }) {
    return GAuthorFragmentData__unknown(
      displayName: displayName ?? this.displayName,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GAuthorFragmentData__unknown &&
            displayName == other.displayName &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, displayName, G__typename);
  }

  @override
  String toString() {
    return 'GAuthorFragmentData__unknown(displayName: $displayName, G__typename: $G__typename)';
  }
}

abstract class GBookFragment {
  GAuthorFragment get author;
  String get title;
  String get G__typename;
}

abstract class GBookFragment__asTextbook implements GBookFragment {
  List<String> get courses;
  String get G__typename;
}

abstract class GBookFragment__asColoringBook implements GBookFragment {
  List<String> get colors;
  String get G__typename;
}

sealed class GBookFragmentData implements GBookFragment {
  const GBookFragmentData({
    required this.author,
    required this.title,
    required this.G__typename,
  });

  factory GBookFragmentData.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Textbook':
        return GBookFragmentData__asTextbook.fromJson(json);
      case 'ColoringBook':
        return GBookFragmentData__asColoringBook.fromJson(json);
      default:
        return GBookFragmentData__unknown.fromJson(json);
    }
  }

  final GAuthorFragmentData author;

  final String title;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    _$result['author'] = this.author.toJson();
    _$result['title'] = this.title;
    _$result['__typename'] = this.G__typename;
    return _$result;
  }
}

extension GBookFragmentDataWhenExtension on GBookFragmentData {
  _T when<_T>({
    required _T Function(GBookFragmentData__asTextbook) textbook,
    required _T Function(GBookFragmentData__asColoringBook) coloringBook,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Textbook':
        return textbook(this as GBookFragmentData__asTextbook);
      case 'ColoringBook':
        return coloringBook(this as GBookFragmentData__asColoringBook);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GBookFragmentData__asTextbook)? textbook,
    _T Function(GBookFragmentData__asColoringBook)? coloringBook,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Textbook':
        return textbook == null
            ? orElse()
            : textbook(this as GBookFragmentData__asTextbook);
      case 'ColoringBook':
        return coloringBook == null
            ? orElse()
            : coloringBook(this as GBookFragmentData__asColoringBook);
      default:
        return orElse();
    }
  }
}

class GBookFragmentData__asTextbook extends GBookFragmentData
    implements GBookFragment, GBookFragment__asTextbook {
  const GBookFragmentData__asTextbook({
    required author,
    required title,
    required G__typename,
    required this.courses,
  }) : super(author: author, title: title, G__typename: G__typename);

  factory GBookFragmentData__asTextbook.fromJson(Map<String, dynamic> json) {
    return GBookFragmentData__asTextbook(
      author: GAuthorFragmentData.fromJson(
          (json['author'] as Map<String, dynamic>)),
      title: (json['title'] as String),
      G__typename: (json['__typename'] as String),
      courses: List<String>.from((json['courses'] as List<dynamic>)),
    );
  }

  final List<String> courses;

  Map<String, dynamic> toJson() {
    final _$result = super.toJson();
    _$result['courses'] = this.courses.map((_$e) => _$e).toList();
    return _$result;
  }

  GBookFragmentData__asTextbook copyWith({
    GAuthorFragmentData? author,
    String? title,
    String? G__typename,
    List<String>? courses,
  }) {
    return GBookFragmentData__asTextbook(
      author: author ?? this.author,
      title: title ?? this.title,
      G__typename: G__typename ?? this.G__typename,
      courses: courses ?? this.courses,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GBookFragmentData__asTextbook &&
            author == other.author &&
            title == other.title &&
            G__typename == other.G__typename &&
            _gqlUtils.listEquals(courses, other.courses));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, author, title, G__typename, _gqlUtils.listHash(courses));
  }

  @override
  String toString() {
    return 'GBookFragmentData__asTextbook(author: $author, title: $title, G__typename: $G__typename, courses: $courses)';
  }
}

class GBookFragmentData__asColoringBook extends GBookFragmentData
    implements GBookFragment, GBookFragment__asColoringBook {
  const GBookFragmentData__asColoringBook({
    required author,
    required title,
    required G__typename,
    required this.colors,
  }) : super(author: author, title: title, G__typename: G__typename);

  factory GBookFragmentData__asColoringBook.fromJson(
      Map<String, dynamic> json) {
    return GBookFragmentData__asColoringBook(
      author: GAuthorFragmentData.fromJson(
          (json['author'] as Map<String, dynamic>)),
      title: (json['title'] as String),
      G__typename: (json['__typename'] as String),
      colors: List<String>.from((json['colors'] as List<dynamic>)),
    );
  }

  final List<String> colors;

  Map<String, dynamic> toJson() {
    final _$result = super.toJson();
    _$result['colors'] = this.colors.map((_$e) => _$e).toList();
    return _$result;
  }

  GBookFragmentData__asColoringBook copyWith({
    GAuthorFragmentData? author,
    String? title,
    String? G__typename,
    List<String>? colors,
  }) {
    return GBookFragmentData__asColoringBook(
      author: author ?? this.author,
      title: title ?? this.title,
      G__typename: G__typename ?? this.G__typename,
      colors: colors ?? this.colors,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GBookFragmentData__asColoringBook &&
            author == other.author &&
            title == other.title &&
            G__typename == other.G__typename &&
            _gqlUtils.listEquals(colors, other.colors));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, author, title, G__typename, _gqlUtils.listHash(colors));
  }

  @override
  String toString() {
    return 'GBookFragmentData__asColoringBook(author: $author, title: $title, G__typename: $G__typename, colors: $colors)';
  }
}

class GBookFragmentData__unknown extends GBookFragmentData
    implements GBookFragment {
  const GBookFragmentData__unknown({
    required author,
    required title,
    required G__typename,
  }) : super(author: author, title: title, G__typename: G__typename);

  factory GBookFragmentData__unknown.fromJson(Map<String, dynamic> json) {
    return GBookFragmentData__unknown(
      author: GAuthorFragmentData.fromJson(
          (json['author'] as Map<String, dynamic>)),
      title: (json['title'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final _$result = super.toJson();
    return _$result;
  }

  GBookFragmentData__unknown copyWith({
    GAuthorFragmentData? author,
    String? title,
    String? G__typename,
  }) {
    return GBookFragmentData__unknown(
      author: author ?? this.author,
      title: title ?? this.title,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GBookFragmentData__unknown &&
            author == other.author &&
            title == other.title &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, author, title, G__typename);
  }

  @override
  String toString() {
    return 'GBookFragmentData__unknown(author: $author, title: $title, G__typename: $G__typename)';
  }
}

class GGetBooksData {
  const GGetBooksData({
    required this.books,
    required this.G__typename,
  });

  factory GGetBooksData.fromJson(Map<String, dynamic> json) {
    return GGetBooksData(
      books: (json['books'] as List<dynamic>)
          .map((_$e) =>
              GBookFragmentData.fromJson((_$e as Map<String, dynamic>)))
          .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GBookFragmentData> books;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final _$result = <String, dynamic>{};
    _$result['books'] = this.books.map((_$e) => _$e.toJson()).toList();
    _$result['__typename'] = this.G__typename;
    return _$result;
  }

  GGetBooksData copyWith({
    List<GBookFragmentData>? books,
    String? G__typename,
  }) {
    return GGetBooksData(
      books: books ?? this.books,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GGetBooksData &&
            _gqlUtils.listEquals(books, other.books) &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, _gqlUtils.listHash(books), G__typename);
  }

  @override
  String toString() {
    return 'GGetBooksData(books: $books, G__typename: $G__typename)';
  }
}

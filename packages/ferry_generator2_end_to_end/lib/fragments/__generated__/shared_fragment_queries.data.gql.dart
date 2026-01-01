// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ferry_generator2_end_to_end/graphql/__generated__/schema.utils.gql.dart'
    as _gqlUtils;

abstract class GSharedAuthorFragment {
  String get displayName;
  String get G__typename;
}

abstract class GSharedAuthorFragment__asPerson
    implements GSharedAuthorFragment {
  String get firstName;
  String get lastName;
  String get G__typename;
}

abstract class GSharedAuthorFragment__asCompany
    implements GSharedAuthorFragment {
  String get name;
  String get G__typename;
}

sealed class GSharedAuthorFragmentData implements GSharedAuthorFragment {
  const GSharedAuthorFragmentData({
    required this.displayName,
    required this.G__typename,
  });

  factory GSharedAuthorFragmentData.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Person':
        return GSharedAuthorFragmentData__asPerson.fromJson(json);
      case 'Company':
        return GSharedAuthorFragmentData__asCompany.fromJson(json);
      default:
        return GSharedAuthorFragmentData__unknown.fromJson(json);
    }
  }

  final String displayName;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['displayName'] = displayName;
    result['__typename'] = G__typename;
    return result;
  }
}

extension GSharedAuthorFragmentDataWhenExtension on GSharedAuthorFragmentData {
  _T when<_T>({
    required _T Function(GSharedAuthorFragmentData__asPerson) person,
    required _T Function(GSharedAuthorFragmentData__asCompany) company,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Person':
        return person(this as GSharedAuthorFragmentData__asPerson);
      case 'Company':
        return company(this as GSharedAuthorFragmentData__asCompany);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GSharedAuthorFragmentData__asPerson)? person,
    _T Function(GSharedAuthorFragmentData__asCompany)? company,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Person':
        return person == null
            ? orElse()
            : person(this as GSharedAuthorFragmentData__asPerson);
      case 'Company':
        return company == null
            ? orElse()
            : company(this as GSharedAuthorFragmentData__asCompany);
      default:
        return orElse();
    }
  }
}

class GSharedAuthorFragmentData__asPerson extends GSharedAuthorFragmentData
    implements GSharedAuthorFragment, GSharedAuthorFragment__asPerson {
  const GSharedAuthorFragmentData__asPerson({
    required displayName,
    required G__typename,
    required this.firstName,
    required this.lastName,
  }) : super(displayName: displayName, G__typename: G__typename);

  factory GSharedAuthorFragmentData__asPerson.fromJson(
      Map<String, dynamic> json) {
    return GSharedAuthorFragmentData__asPerson(
      displayName: (json['displayName'] as String),
      G__typename: (json['__typename'] as String),
      firstName: (json['firstName'] as String),
      lastName: (json['lastName'] as String),
    );
  }

  final String firstName;

  final String lastName;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['displayName'] = displayName;
    result['__typename'] = G__typename;
    result['firstName'] = firstName;
    result['lastName'] = lastName;
    return result;
  }

  GSharedAuthorFragmentData__asPerson copyWith({
    String? displayName,
    String? G__typename,
    String? firstName,
    String? lastName,
  }) {
    return GSharedAuthorFragmentData__asPerson(
      displayName: displayName ?? this.displayName,
      G__typename: G__typename ?? this.G__typename,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedAuthorFragmentData__asPerson &&
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
    return 'GSharedAuthorFragmentData__asPerson(displayName: $displayName, G__typename: $G__typename, firstName: $firstName, lastName: $lastName)';
  }
}

class GSharedAuthorFragmentData__asCompany extends GSharedAuthorFragmentData
    implements GSharedAuthorFragment, GSharedAuthorFragment__asCompany {
  const GSharedAuthorFragmentData__asCompany({
    required displayName,
    required G__typename,
    required this.name,
  }) : super(displayName: displayName, G__typename: G__typename);

  factory GSharedAuthorFragmentData__asCompany.fromJson(
      Map<String, dynamic> json) {
    return GSharedAuthorFragmentData__asCompany(
      displayName: (json['displayName'] as String),
      G__typename: (json['__typename'] as String),
      name: (json['name'] as String),
    );
  }

  final String name;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['displayName'] = displayName;
    result['__typename'] = G__typename;
    result['name'] = name;
    return result;
  }

  GSharedAuthorFragmentData__asCompany copyWith({
    String? displayName,
    String? G__typename,
    String? name,
  }) {
    return GSharedAuthorFragmentData__asCompany(
      displayName: displayName ?? this.displayName,
      G__typename: G__typename ?? this.G__typename,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedAuthorFragmentData__asCompany &&
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
    return 'GSharedAuthorFragmentData__asCompany(displayName: $displayName, G__typename: $G__typename, name: $name)';
  }
}

class GSharedAuthorFragmentData__unknown extends GSharedAuthorFragmentData
    implements GSharedAuthorFragment {
  const GSharedAuthorFragmentData__unknown({
    required displayName,
    required G__typename,
  }) : super(displayName: displayName, G__typename: G__typename);

  factory GSharedAuthorFragmentData__unknown.fromJson(
      Map<String, dynamic> json) {
    return GSharedAuthorFragmentData__unknown(
      displayName: (json['displayName'] as String),
      G__typename: (json['__typename'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['displayName'] = displayName;
    result['__typename'] = G__typename;
    return result;
  }

  GSharedAuthorFragmentData__unknown copyWith({
    String? displayName,
    String? G__typename,
  }) {
    return GSharedAuthorFragmentData__unknown(
      displayName: displayName ?? this.displayName,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedAuthorFragmentData__unknown &&
            displayName == other.displayName &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, displayName, G__typename);
  }

  @override
  String toString() {
    return 'GSharedAuthorFragmentData__unknown(displayName: $displayName, G__typename: $G__typename)';
  }
}

abstract class GSharedBookFragment {
  String get title;
  GSharedAuthorFragment get author;
  String get G__typename;
}

abstract class GSharedBookFragment__asTextbook implements GSharedBookFragment {
  List<String> get courses;
  String get G__typename;
}

abstract class GSharedBookFragment__asColoringBook
    implements GSharedBookFragment {
  List<String> get colors;
  String get G__typename;
}

sealed class GSharedBookFragmentData implements GSharedBookFragment {
  const GSharedBookFragmentData({
    required this.title,
    required this.author,
    required this.G__typename,
  });

  factory GSharedBookFragmentData.fromJson(Map<String, dynamic> json) {
    switch (json['__typename'] as String) {
      case 'Textbook':
        return GSharedBookFragmentData__asTextbook.fromJson(json);
      case 'ColoringBook':
        return GSharedBookFragmentData__asColoringBook.fromJson(json);
      default:
        return GSharedBookFragmentData__unknown.fromJson(json);
    }
  }

  final String title;

  final GSharedAuthorFragmentData author;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['title'] = title;
    result['author'] = author.toJson();
    result['__typename'] = G__typename;
    return result;
  }
}

extension GSharedBookFragmentDataWhenExtension on GSharedBookFragmentData {
  _T when<_T>({
    required _T Function(GSharedBookFragmentData__asTextbook) textbook,
    required _T Function(GSharedBookFragmentData__asColoringBook) coloringBook,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Textbook':
        return textbook(this as GSharedBookFragmentData__asTextbook);
      case 'ColoringBook':
        return coloringBook(this as GSharedBookFragmentData__asColoringBook);
      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(GSharedBookFragmentData__asTextbook)? textbook,
    _T Function(GSharedBookFragmentData__asColoringBook)? coloringBook,
    required _T Function() orElse,
  }) {
    switch (G__typename) {
      case 'Textbook':
        return textbook == null
            ? orElse()
            : textbook(this as GSharedBookFragmentData__asTextbook);
      case 'ColoringBook':
        return coloringBook == null
            ? orElse()
            : coloringBook(this as GSharedBookFragmentData__asColoringBook);
      default:
        return orElse();
    }
  }
}

class GSharedBookFragmentData__asTextbook extends GSharedBookFragmentData
    implements GSharedBookFragment, GSharedBookFragment__asTextbook {
  const GSharedBookFragmentData__asTextbook({
    required title,
    required author,
    required G__typename,
    required this.courses,
  }) : super(title: title, author: author, G__typename: G__typename);

  factory GSharedBookFragmentData__asTextbook.fromJson(
      Map<String, dynamic> json) {
    return GSharedBookFragmentData__asTextbook(
      title: (json['title'] as String),
      author: GSharedAuthorFragmentData.fromJson(
          (json['author'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
      courses: List<String>.from((json['courses'] as List<dynamic>)),
    );
  }

  final List<String> courses;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['title'] = title;
    result['author'] = author.toJson();
    result['__typename'] = G__typename;
    result['courses'] = courses.map((e) => e).toList();
    return result;
  }

  GSharedBookFragmentData__asTextbook copyWith({
    String? title,
    GSharedAuthorFragmentData? author,
    String? G__typename,
    List<String>? courses,
  }) {
    return GSharedBookFragmentData__asTextbook(
      title: title ?? this.title,
      author: author ?? this.author,
      G__typename: G__typename ?? this.G__typename,
      courses: courses ?? this.courses,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedBookFragmentData__asTextbook &&
            title == other.title &&
            author == other.author &&
            G__typename == other.G__typename &&
            _gqlUtils.listEquals(courses, other.courses));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, title, author, G__typename, _gqlUtils.listHash(courses));
  }

  @override
  String toString() {
    return 'GSharedBookFragmentData__asTextbook(title: $title, author: $author, G__typename: $G__typename, courses: $courses)';
  }
}

class GSharedBookFragmentData__asColoringBook extends GSharedBookFragmentData
    implements GSharedBookFragment, GSharedBookFragment__asColoringBook {
  const GSharedBookFragmentData__asColoringBook({
    required title,
    required author,
    required G__typename,
    required this.colors,
  }) : super(title: title, author: author, G__typename: G__typename);

  factory GSharedBookFragmentData__asColoringBook.fromJson(
      Map<String, dynamic> json) {
    return GSharedBookFragmentData__asColoringBook(
      title: (json['title'] as String),
      author: GSharedAuthorFragmentData.fromJson(
          (json['author'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
      colors: List<String>.from((json['colors'] as List<dynamic>)),
    );
  }

  final List<String> colors;

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['title'] = title;
    result['author'] = author.toJson();
    result['__typename'] = G__typename;
    result['colors'] = colors.map((e) => e).toList();
    return result;
  }

  GSharedBookFragmentData__asColoringBook copyWith({
    String? title,
    GSharedAuthorFragmentData? author,
    String? G__typename,
    List<String>? colors,
  }) {
    return GSharedBookFragmentData__asColoringBook(
      title: title ?? this.title,
      author: author ?? this.author,
      G__typename: G__typename ?? this.G__typename,
      colors: colors ?? this.colors,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedBookFragmentData__asColoringBook &&
            title == other.title &&
            author == other.author &&
            G__typename == other.G__typename &&
            _gqlUtils.listEquals(colors, other.colors));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, title, author, G__typename, _gqlUtils.listHash(colors));
  }

  @override
  String toString() {
    return 'GSharedBookFragmentData__asColoringBook(title: $title, author: $author, G__typename: $G__typename, colors: $colors)';
  }
}

class GSharedBookFragmentData__unknown extends GSharedBookFragmentData
    implements GSharedBookFragment {
  const GSharedBookFragmentData__unknown({
    required title,
    required author,
    required G__typename,
  }) : super(title: title, author: author, G__typename: G__typename);

  factory GSharedBookFragmentData__unknown.fromJson(Map<String, dynamic> json) {
    return GSharedBookFragmentData__unknown(
      title: (json['title'] as String),
      author: GSharedAuthorFragmentData.fromJson(
          (json['author'] as Map<String, dynamic>)),
      G__typename: (json['__typename'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result['title'] = title;
    result['author'] = author.toJson();
    result['__typename'] = G__typename;
    return result;
  }

  GSharedBookFragmentData__unknown copyWith({
    String? title,
    GSharedAuthorFragmentData? author,
    String? G__typename,
  }) {
    return GSharedBookFragmentData__unknown(
      title: title ?? this.title,
      author: author ?? this.author,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedBookFragmentData__unknown &&
            title == other.title &&
            author == other.author &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, title, author, G__typename);
  }

  @override
  String toString() {
    return 'GSharedBookFragmentData__unknown(title: $title, author: $author, G__typename: $G__typename)';
  }
}

class GSharedBooksAData {
  const GSharedBooksAData({
    required this.books,
    required this.G__typename,
  });

  factory GSharedBooksAData.fromJson(Map<String, dynamic> json) {
    return GSharedBooksAData(
      books: (json['books'] as List<dynamic>)
          .map((e) =>
              GSharedBookFragmentData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GSharedBookFragmentData> books;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['books'] = books.map((e) => e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GSharedBooksAData copyWith({
    List<GSharedBookFragmentData>? books,
    String? G__typename,
  }) {
    return GSharedBooksAData(
      books: books ?? this.books,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedBooksAData &&
            _gqlUtils.listEquals(books, other.books) &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, _gqlUtils.listHash(books), G__typename);
  }

  @override
  String toString() {
    return 'GSharedBooksAData(books: $books, G__typename: $G__typename)';
  }
}

class GSharedBooksBData {
  const GSharedBooksBData({
    required this.books,
    required this.G__typename,
  });

  factory GSharedBooksBData.fromJson(Map<String, dynamic> json) {
    return GSharedBooksBData(
      books: (json['books'] as List<dynamic>)
          .map((e) =>
              GSharedBookFragmentData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      G__typename: (json['__typename'] as String),
    );
  }

  final List<GSharedBookFragmentData> books;

  final String G__typename;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['books'] = books.map((e) => e.toJson()).toList();
    result['__typename'] = G__typename;
    return result;
  }

  GSharedBooksBData copyWith({
    List<GSharedBookFragmentData>? books,
    String? G__typename,
  }) {
    return GSharedBooksBData(
      books: books ?? this.books,
      G__typename: G__typename ?? this.G__typename,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GSharedBooksBData &&
            _gqlUtils.listEquals(books, other.books) &&
            G__typename == other.G__typename);
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, _gqlUtils.listHash(books), G__typename);
  }

  @override
  String toString() {
    return 'GSharedBooksBData(books: $books, G__typename: $G__typename)';
  }
}

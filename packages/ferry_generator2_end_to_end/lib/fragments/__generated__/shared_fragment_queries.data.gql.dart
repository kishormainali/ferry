// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

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
      courses:
          (json['courses'] as List<dynamic>).map((e) => (e as String)).toList(),
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
      colors:
          (json['colors'] as List<dynamic>).map((e) => (e as String)).toList(),
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
}

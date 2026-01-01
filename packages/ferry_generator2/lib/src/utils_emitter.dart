import "package:code_builder/code_builder.dart";

Library buildUtilsLibrary() {
  final specs = <Spec>[
    _buildListEqualsHelper(deep: false),
    _buildListEqualsHelper(deep: true),
    _buildListHashHelper(deep: false),
    _buildListHashHelper(deep: true),
    _buildDeepEqualsHelper(),
    _buildDeepHashHelper(),
  ];

  return Library((b) => b..body.addAll(specs));
}

Expression _pragmaPreferInline() =>
    refer("pragma").call([literalString("vm:prefer-inline")]);

Method _buildListEqualsHelper({required bool deep}) {
  final name = deep ? "listEqualsDeep" : "listEquals";
  final elementCheck =
      deep ? "!deepEquals(left[i], right[i])" : "left[i] != right[i]";
  return Method(
    (b) => b
      ..name = name
      ..returns = refer("bool")
      ..types.add(refer("T"))
      ..annotations.add(_pragmaPreferInline())
      ..requiredParameters.addAll([
        Parameter(
          (b) => b
            ..name = "left"
            ..type = TypeReference(
              (b) => b
                ..symbol = "List"
                ..isNullable = true
                ..types.add(refer("T")),
            ),
        ),
        Parameter(
          (b) => b
            ..name = "right"
            ..type = TypeReference(
              (b) => b
                ..symbol = "List"
                ..isNullable = true
                ..types.add(refer("T")),
            ),
        ),
      ])
      ..body = Code(
        [
          "if (identical(left, right)) return true;",
          "if (left == null || right == null) return false;",
          "final length = left.length;",
          "if (length != right.length) return false;",
          "for (var i = 0; i < length; i++) {",
          "  if ($elementCheck) return false;",
          "}",
          "return true;",
        ].join("\n"),
      ),
  );
}

Method _buildListHashHelper({required bool deep}) {
  final name = deep ? "listHashDeep" : "listHash";
  final elementHash = deep ? "deepHash(value)" : "value";
  return Method(
    (b) => b
      ..name = name
      ..returns = refer("int")
      ..types.add(refer("T"))
      ..annotations.add(_pragmaPreferInline())
      ..requiredParameters.add(
        Parameter(
          (b) => b
            ..name = "values"
            ..type = TypeReference(
              (b) => b
                ..symbol = "List"
                ..isNullable = true
                ..types.add(refer("T")),
            ),
        ),
      )
      ..body = Code(
        [
          "if (values == null) return 0;",
          "var hash = 0;",
          "for (final value in values) {",
          "  hash = Object.hash(hash, $elementHash);",
          "}",
          "return hash;",
        ].join("\n"),
      ),
  );
}

Method _buildDeepEqualsHelper() {
  return Method(
    (b) => b
      ..name = "deepEquals"
      ..returns = refer("bool")
      ..annotations.add(_pragmaPreferInline())
      ..requiredParameters.addAll([
        Parameter((b) => b
          ..name = "left"
          ..type = refer("Object?")),
        Parameter((b) => b
          ..name = "right"
          ..type = refer("Object?")),
      ])
      ..body = Code(
        [
          "if (identical(left, right)) return true;",
          "if (left == null || right == null) return false;",
          "if (left is List && right is List) {",
          "  return listEqualsDeep(left, right);",
          "}",
          "if (left is Map && right is Map) {",
          "  if (left.length != right.length) return false;",
          "  for (final entry in left.entries) {",
          "    if (!right.containsKey(entry.key)) return false;",
          "    if (!deepEquals(entry.value, right[entry.key])) return false;",
          "  }",
          "  return true;",
          "}",
          "return left == right;",
        ].join("\n"),
      ),
  );
}

Method _buildDeepHashHelper() {
  return Method(
    (b) => b
      ..name = "deepHash"
      ..returns = refer("int")
      ..annotations.add(_pragmaPreferInline())
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = "value"
          ..type = refer("Object?")),
      )
      ..body = Code(
        [
          "if (value == null) return 0;",
          "if (value is List) {",
          "  return listHashDeep(value);",
          "}",
          "if (value is Map) {",
          "  return Object.hashAllUnordered(",
          "    value.entries.map(",
          "      (entry) => Object.hash(",
          "        deepHash(entry.key),",
          "        deepHash(entry.value),",
          "      ),",
          "    ),",
          "  );",
          "}",
          "return value.hashCode;",
        ].join("\n"),
      ),
  );
}

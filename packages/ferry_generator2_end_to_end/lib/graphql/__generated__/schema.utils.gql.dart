// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

@pragma('vm:prefer-inline')
bool listEquals<T>(
  List<T>? left,
  List<T>? right,
) {
  if (identical(left, right)) return true;
  if (left == null || right == null) return false;
  final length = left.length;
  if (length != right.length) return false;
  for (var i = 0; i < length; i++) {
    if (left[i] != right[i]) return false;
  }
  return true;
}

@pragma('vm:prefer-inline')
bool listEqualsDeep<T>(
  List<T>? left,
  List<T>? right,
) {
  if (identical(left, right)) return true;
  if (left == null || right == null) return false;
  final length = left.length;
  if (length != right.length) return false;
  for (var i = 0; i < length; i++) {
    if (!deepEquals(left[i], right[i])) return false;
  }
  return true;
}

@pragma('vm:prefer-inline')
int listHash<T>(List<T>? values) {
  if (values == null) return 0;
  var hash = 0;
  for (final value in values) {
    hash = Object.hash(hash, value);
  }
  return hash;
}

@pragma('vm:prefer-inline')
int listHashDeep<T>(List<T>? values) {
  if (values == null) return 0;
  var hash = 0;
  for (final value in values) {
    hash = Object.hash(hash, deepHash(value));
  }
  return hash;
}

@pragma('vm:prefer-inline')
bool deepEquals(
  Object? left,
  Object? right,
) {
  if (identical(left, right)) return true;
  if (left == null || right == null) return false;
  if (left is List && right is List) {
    return listEqualsDeep(left, right);
  }
  if (left is Map && right is Map) {
    if (left.length != right.length) return false;
    for (final entry in left.entries) {
      if (!right.containsKey(entry.key)) return false;
      if (!deepEquals(entry.value, right[entry.key])) return false;
    }
    return true;
  }
  return left == right;
}

@pragma('vm:prefer-inline')
int deepHash(Object? value) {
  if (value == null) return 0;
  if (value is List) {
    return listHashDeep(value);
  }
  if (value is Map) {
    return Object.hashAllUnordered(
      value.entries.map(
        (entry) => Object.hash(
          deepHash(entry.key),
          deepHash(entry.value),
        ),
      ),
    );
  }
  return value.hashCode;
}

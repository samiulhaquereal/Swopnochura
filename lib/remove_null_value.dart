/*
class NullChecker {
  static NullChecker? _instance;

  NullChecker._internal();

  factory NullChecker() {
    _instance ??= NullChecker._internal();
    return _instance!;
  }

  /// Replaces null values with a single space ' ' in a collection.
  ///
  /// Supports [List], [Map], and [Set].
  /// - For [List], replaces null or empty string elements with ' '.
  /// - For [Map], replaces null or empty string values with ' '.
  /// - For [Set], replaces null or empty string elements with ' '.
  T replaceNullWithSpace<T>(T collection) {
    if (collection is List) {
      // Replace null and empty string elements with ' '
      return collection
          .map((element) => (element == null || element == '') ? ' ' : element)
          .toList() as T;
    } else if (collection is Map) {
      // Replace null and empty string values in Map with ' '
      Map<String, dynamic> cleanedMap = {};
      collection.forEach((key, value) {
        cleanedMap[key] = (value == null || value == '') ? ' ' : value;
      });
      return cleanedMap as T;
    } else if (collection is Set) {
      // Replace null and empty string elements in Set with ' '
      return collection
          .map((element) => (element == null || element == '') ? ' ' : element)
          .toSet() as T;
    } else {
      throw ArgumentError('Unsupported collection type');
    }
  }
}
*/


class NullChecker {
  static NullChecker? _instance;

  NullChecker._internal();

  factory NullChecker() {
    _instance ??= NullChecker._internal();
    return _instance!;
  }

  /// Removes null and empty string values from a collection.
  ///
  /// Supports [List], [Map], and [Set].
  /// - For [List], removes any null or empty string elements.
  /// - For [Map], removes any entries with null or empty string values.
  /// - For [Set], removes any null or empty string elements.
  T removeNullValues<T>(T collection) {
    if (collection is List) {
      return collection.where((element) => element != null && element != '').toList() as T;
    } else if (collection is Map) {
      // Correctly filter out null and empty string values from a Map
      Map<String, dynamic> cleanedMap = {};
      collection.forEach((key, value) {
        if (value != null && value != '') {
          cleanedMap[key] = value;
        }
      });
      return cleanedMap as T;
    } else if (collection is Set) {
      return collection.where((element) => element != null && element != '').toSet() as T;
    } else {
      throw ArgumentError('Unsupported collection type');
    }
  }
}
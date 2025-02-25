library enum_to_string;

import 'camel_case_to_words.dart';

class EnumToString {
  static bool _isEnumItem(enumItem) {
    final splitEnum = enumItem.toString().split('.');
    return splitEnum.length > 1 &&
        splitEnum[0] == enumItem.runtimeType.toString();
  }

  /// Check if the enum has a custom string mapping
  static String? _getCustomMapping(dynamic enumItem) {
    try {
      // Access the value property if it exists
      final value = (enumItem as dynamic).value as String?;
      return value;
    } catch (_) {
      return null;
    }
  }

  /// Convert an enum to a string
  ///
  /// Pass in the enum value, so TestEnum.valueOne into [enumItem]
  /// It will first check if the enum has a custom string mapping (using enhanced enums).
  /// If it does, that value will be returned.
  /// Otherwise, it will return the striped off value so "valueOne".
  ///
  /// If you pass in the option [camelCase]=true it will convert it to words
  /// So TestEnum.valueOne will become Value One
  ///
  /// If you pass in the option [capitalizeWords]=true along with [camelCase]=true,
  /// it will capitalize each word. So TestEnum.valueOne will become "Value One"
  /// instead of "Value one"
  static String convertToString(dynamic enumItem,
      {bool camelCase = false,
      bool capitalizeWords = false,
      bool checkCustomMapping = false}) {
    assert(enumItem != null);
    assert(_isEnumItem(enumItem),
        '$enumItem of type ${enumItem.runtimeType.toString()} is not an enum item');

    // First check for custom mapping
    if (checkCustomMapping) {
      final customMapping = _getCustomMapping(enumItem);
      if (customMapping != null) {
        return customMapping;
      }
    }

    // Fall back to original behavior
    final tmp = enumItem.toString().split('.')[1];
    return !camelCase
        ? tmp
        : camelCaseToWords(tmp, defaultPattern, capitalizeWords);
  }

  @Deprecated(
      'Renamed function to EnumToString.convertToString to make it clearer')
  static String parse(enumItem, {bool camelCase = false}) =>
      convertToString(enumItem, camelCase: camelCase);

  /// An alias for parse(item, camelCase: true)
  ///
  @Deprecated(
      'Deprecated in favour of using convertToString(item, camelCase: true)')
  static String parseCamelCase(enumItem) {
    return EnumToString.convertToString(enumItem, camelCase: true);
  }

  /// Given a string, find and return its matching enum value
  ///
  /// You need to pass in the values of the enum object. So TestEnum.values
  /// in the first argument. The matching value is the second argument.
  ///
  /// Example final result = EnumToString.fromString(TestEnum.values, "valueOne")
  /// result == TestEnum.valueOne //true
  ///
  static T? fromString<T>(List<T?> enumValues, String value,
      {bool camelCase = false}) {
    final matchList = enumValues
        .where((enumItem) =>
            EnumToString.convertToString(enumItem, camelCase: camelCase)
                .toLowerCase() ==
            value.toLowerCase())
        .toList();

    return matchList.length == 1 ? matchList.single : null;
  }

  /// Get the index of the enum value
  ///
  /// Pass in the enum values to argument one, so TestEnum.values
  /// Pass in the matching string to argument 2, so "valueOne"
  ///
  /// Eg. final index = EnumToString.indexOf(TestEnum.values, "valueOne")
  /// index == 0 //true
  static int indexOf<T>(List<T> enumValues, String value) {
    final fromStringResult = fromString<T>(enumValues, value);
    if (fromStringResult == null) {
      return -1;
    } else {
      return enumValues.indexOf(fromStringResult);
    }
  }

  /// Bulk convert enum values to a list
  ///
  static List<String> toList<T>(List<T> enumValues,
      {bool camelCase = false, bool capitalizeWords = false}) {
    final enumList = enumValues
        .map((t) => !camelCase
            ? EnumToString.convertToString(t)
            : EnumToString.convertToString(t,
                camelCase: true, capitalizeWords: capitalizeWords))
        .toList();

    // I am sure there is a better way to convert a nullable list to a
    // non-nullable one, but this will do until I find out how. Happy if
    // someone want to do a PR in the meantime to correct this.
    var output = <String>[];
    for (var value in enumList) {
      output.add(value);
    }
    return output;
  }

  /// Get a list of enums given a list of strings.
  /// Basically just EnumToString.fromString, but using lists
  ///
  /// As with fromString it is not case sensitive
  ///
  /// Eg. EnumToString.fromList(TestEnum.values, ["valueOne", "value2"]
  static List<T?> fromList<T>(List<T> enumValues, List valueList) {
    return List<T?>.from(
        valueList.map<T?>((item) => fromString(enumValues, item)));
  }
}

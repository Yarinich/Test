import 'package:recase/recase.dart';

/// You can get name the enum in necessary case.
//ignore_for_file: format-comment
extension EnumExt on Enum {
  /// camelCase
  String get camelCase => ReCase(name).camelCase;

  /// CONSTANT_CASE
  String get constantCase => ReCase(name).constantCase;

  /// Sentence case
  String get sentenceCase => ReCase(name).sentenceCase;

  /// snake_case
  String get snakeCase => ReCase(name).snakeCase;

  /// dot.case
  String get dotCase => ReCase(name).dotCase;

  /// param-case
  String get paramCase => ReCase(name).paramCase;

  /// path/case
  String get pathCase => ReCase(name).pathCase;

  /// PascalCase
  String get pascalCase => ReCase(name).pascalCase;

  /// Header-Case
  String get headerCase => ReCase(name).headerCase;

  /// Title Case
  String get titleCase => ReCase(name).titleCase;
}

/// You can use this extension for all enums
/// Don't worry about server format of enums
///
/// e.g.
/// enum Team {
///   someName,
///   secondName,
///   otherName,
/// }
///
/// void valueOfTeam() {
///   final someName = Team.values.valueOf('someName');
///   final secondName = Team.values.valueOf('second_name');
///   final otherName = Team.values.valueOf('Other name');
///   final nullableName = Team.values.valueOf(null);
/// }
///
/// All name of enum have to be camelCase as dart code convention
///
extension EnumValueOf<T extends Enum> on Iterable<T> {
  T? valueOf(String? name) {
    if (name != null) {
      final camelCaseName = name.camelCase;
      for (final value in this) {
        if (value.name == camelCaseName) {
          return value;
        }
      }
    }

    return null;
  }
}

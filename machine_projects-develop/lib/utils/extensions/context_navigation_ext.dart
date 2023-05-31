import 'package:flutter/material.dart';

extension ContextNavigationExt on BuildContext {
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.pushNamed(
        this,
        routeName,
        arguments: arguments,
      );

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) =>
      Navigator.pushReplacementNamed(
        this,
        routeName,
        result: result,
        arguments: arguments,
      );

  void pop({
    dynamic result,
    bool rootNavigator = false,
  }) =>
      Navigator.of(
        this,
        rootNavigator: rootNavigator,
      ).pop(result);

  Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    String newRouteName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T?>(
      newRouteName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }
}

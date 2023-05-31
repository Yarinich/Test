import 'package:flutter/material.dart';

extension NavigatorStateExt on NavigatorState {
  Future<T?> pushNamedAndRemoveAll<T extends Object>(
    String newRouteName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil<T?>(
      newRouteName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }
}

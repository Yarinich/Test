// ignore_for_file: always_put_control_body_on_new_line, sort_constructors_first
// ignore_for_file: member-ordering

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

typedef KeyboardVisibleCallback = Function(bool isVisible);

/// Keyboard display listener
///
/// Indicates when keyboard is opened.
/// If bottom inset is greater than 0 - keyboard is opened.
/// If inset is equal to zero - keyboard is closed
class KeyboardListener extends WidgetsBindingObserver {
  final _onKeyboardVisibleListeners = <String, KeyboardVisibleCallback>{};

  bool get isVisibleKeyboard {
    return WidgetsBinding.instance.window.viewInsets.bottom > 0;
  }

  KeyboardListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Callback for changing metrics
  @override
  void didChangeMetrics() {
    _listener();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _onKeyboardVisibleListeners.clear();
  }

  void addListener({
    required KeyboardVisibleCallback onChange,
  }) {
    final id = const Uuid().v4();
    _onKeyboardVisibleListeners[id] = onChange;
  }

  void removeListener(KeyboardVisibleCallback callback) {
    _onKeyboardVisibleListeners.removeWhere((key, value) => value == callback);
  }

  void _listener() {
    _onChange(isVisibleKeyboard);
  }

  void _onChange(bool isOpen) {
    for (final listener in _onKeyboardVisibleListeners.values) {
      listener(isOpen);
    }
  }
}

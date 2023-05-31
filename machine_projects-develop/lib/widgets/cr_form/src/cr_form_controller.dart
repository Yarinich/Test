import 'package:flutter/material.dart';

/// Controller for [CRForm]
///
/// Call [validate] to check each field. After checking, you will be scrolled to
/// the first invalid field
class CRFormController extends ChangeNotifier {
  CRFormController();

  Future<bool> Function()? _onValidate;

  @override
  void dispose() {
    _onValidate = null;
    super.dispose();
  }

  Future<bool> validate() {
    return _onValidate?.call() ?? Future.value(false);
  }

  // ignore: use_setters_to_change_properties
  void setOnValidateMethod(Future<bool> Function() method) {
    _onValidate = method;
  }
}

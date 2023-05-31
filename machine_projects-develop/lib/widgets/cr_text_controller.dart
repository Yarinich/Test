import 'package:flutter/material.dart';
import 'package:machine/widgets/cr_form/src/cr_base_text_controller.dart';

class CRTextController extends CRBaseTextController {
  CRTextController({
    String? value,
    TextEditingController? ctrl,
  }) {
    if (value != null) {
      ctrl?.text = value;
    }
    textEditingController = ctrl ?? TextEditingController(text: value);
  }

  late final TextEditingController textEditingController;
  String? _errorText;

  String get text => textEditingController.text;

  // ignore: unnecessary_getters_setters
  String? get errorText => _errorText;

  set errorText(String? error) => _errorText = error;

  bool get hasError => errorText != null;
}

import 'package:flutter/cupertino.dart';

/// Base text controller class
///
/// For using [CRForm] required fields that extend [CRFormFieldState]
abstract class CRBaseTextController extends ChangeNotifier {
  final fieldFocus = FocusNode();

  @override
  void dispose() {
    fieldFocus.dispose();
    super.dispose();
  }
}
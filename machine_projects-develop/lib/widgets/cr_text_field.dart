import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machine/widgets/cr_form/src/cr_form_field.dart';
import 'package:machine/widgets/cr_text_controller.dart';
import 'package:machine/widgets/titled_widget.dart';

class CRTextField extends CRTextFormField {
  CRTextField({
    required CRTextController super.controller,
    super.key,
    super.validator,
    bool autocorrect = false,
    bool obscureText = false,
    String? prefixText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffix,
    Widget? suffixIcon,
    String? counterText = '',
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    int errorMaxLines = 2,
    int helperMaxLines = 1,
    String? title,
    String? label,
    String? helper = '',
    Iterable<String>? autofillHints,
    final Function(String)? onChanged,
    int? maxLength = 50,
    int? maxLines = 1,
    TextInputType? keyboardType,
    TextStyle prefixStyle = const TextStyle(),
    TextStyle hintStyle = const TextStyle(),
    EdgeInsets scrollPadding = const EdgeInsets.all(20),
    this.inputFormatters,
    TextInputAction? textInputAction,
    super.enabled = true,
    FormFieldSetter<String>? onSaved,
    final Function(String)? onFieldSubmitted,
  })  : _controller = controller,
        super(
          initialValue: controller.text,
          builder: (formFieldState) {
            final state = formFieldState as CRTextFieldState;
            final hasPrefixIcon = prefixIcon != null;
            final hasSuffixIcon = suffixIcon != null;
            final hasError = state.hasError || controller.errorText != null;
            final errorText = controller.errorText ?? state.errorText;

            return TitledWidget(
              title: title,
              margin: const EdgeInsets.only(left: 8, bottom: 4),
              child: TextFormField(
                controller: controller.textEditingController,
                focusNode: controller.fieldFocus,
                // not extracted because The instance member can't
                // be accessed in an initializer.
                // ignore: prefer-extracting-callbacks
                decoration: InputDecoration(
                  labelText: label,
                  helperText: helper,
                  helperMaxLines: helperMaxLines,
                  hintText: hintText,
                  hintStyle: hintStyle,
                  errorText: hasError ? errorText : null,
                  errorMaxLines: errorMaxLines,
                  isCollapsed: hasPrefixIcon,
                  contentPadding: hasPrefixIcon ? EdgeInsets.zero : null,
                  prefixIcon: prefixIcon,
                  prefixIconConstraints: hasPrefixIcon
                      ? const BoxConstraints(
                          minWidth: kMinInteractiveDimension,
                          maxWidth: kMinInteractiveDimension,
                          minHeight: kMinInteractiveDimension,
                          maxHeight: kMinInteractiveDimension,
                        )
                      : null,
                  prefixText: prefixText,
                  prefixStyle: prefixStyle,
                  suffixIcon: suffixIcon,
                  suffix: suffix,
                  suffixIconConstraints: hasSuffixIcon
                      ? const BoxConstraints(
                          minWidth: kMinInteractiveDimension,
                          maxWidth: kMinInteractiveDimension,
                          minHeight: kMinInteractiveDimension,
                          maxHeight: kMinInteractiveDimension,
                        )
                      : null,
                  counterText: counterText,
                  filled: false,
                  errorBorder: errorTextFieldBorder,
                  focusedBorder: selectedTextFieldBorder,
                  focusedErrorBorder: errorTextFieldBorder,
                  disabledBorder: textFieldBorder,
                  enabledBorder: textFieldBorder,
                ),
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                obscuringCharacter: '*',
                obscureText: obscureText,
                autocorrect: autocorrect,
                maxLines: maxLines,
                maxLength: maxLength,
                //ignore: prefer-extracting-callbacks
                onChanged: (value) {
                  state.didChange(value);
                  onChanged?.call(value);
                },
                onFieldSubmitted: onFieldSubmitted,
                onSaved: onSaved,
                inputFormatters: inputFormatters,
                enabled: enabled,
                scrollPadding: scrollPadding,
                autofillHints: autofillHints,
              ),
            );
          },
        );

  final List<TextInputFormatter>? inputFormatters;
  final CRTextController _controller;

  @override
  CRTextController controller() => _controller;

  @override
  FormFieldState<String> createState() => CRTextFieldState();

  static const textFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black45),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const selectedTextFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const errorTextFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}

class CRTextFieldState extends CRBaseTextFieldState {
  // ignore: avoid-returning-widgets
  @override
  CRTextField get widget => super.widget as CRTextField;

  @override
  CRTextController get controller => widget.controller();

  @override
  bool get isValid => super.isValid && !controller.hasError;

  @override
  bool validate() {
    if (controller.hasError) {
      return false;
    }

    return super.validate();
  }
}

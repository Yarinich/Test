import 'package:flutter/cupertino.dart';
import 'package:machine/widgets/cr_form/src/cr_form.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:uuid/uuid.dart';

/// Base state class for form field
/// For using your field with [CRForm], you need to extend your state class with this.
/// E.g.
/// ```
/// class ExampleCheckboxState extends CRFormFieldState<bool> {
///   @override
///   FormField<bool> get widget => super.widget;
/// }
/// ```
class CRFormFieldState<T> extends FormFieldState<T> {
  final id = const Uuid().v4();

  @override
  void deactivate() {
    CRForm.of(context)?.unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    CRForm.of(context)?.register(this);

    final formScope = CRFormScope.of(context);

    return formScope != null
        ? RenderMetricsObject(
            id: id,
            manager: formScope.renderParametersManager,
            child: super.build(context),
          )
        : super.build(context);
  }
}
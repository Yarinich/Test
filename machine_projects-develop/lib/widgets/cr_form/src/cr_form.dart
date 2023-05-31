import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:machine/widgets/cr_form/src/cr_form_controller.dart';
import 'package:machine/widgets/cr_form/src/cr_form_field.dart';
import 'package:machine/widgets/cr_form/src/utils/keyboard_listener.dart' as kl;
import 'package:render_metrics/render_metrics.dart';

class CRFormScope extends InheritedWidget {
  const CRFormScope({
    required Widget child,
    required CRFormState formState,
    required RenderParametersManager renderManager,
    Key? key,
  })  : _formState = formState,
        _manager = renderManager,
        super(
          key: key,
          child: child,
        );

  final CRFormState _formState;
  final RenderParametersManager _manager;

  RenderParametersManager get renderParametersManager => _manager;

  static CRFormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CRFormScope>();
  }

  /// updating doesn't needed because this InheritedWidget only stores
  /// renderParametersManager field and no contains any logic
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

///
/// Can be used as [Form] widget
/// Works only with fields that interit from [CRFormFieldState]. See example.
/// ```
/// class CRCheckboxState extends CRFormFieldState<bool> {
///   @override
///   FormField<bool> get widget => super.widget;
/// }
/// ```
///
/// [animationDuration], [animationCurve] - scroll animation duration and scroll animation curve.
/// zero duration - scrolls immediately (without any animation)
///
/// [recalculateFieldsBeforeValidations] - after each validation gather all fields again.
/// It might be helpful if fields change their own size after validation (e.g. adds an error line).
///
/// [debugMode] - shows the line to which the field will scroll.
///
/// [autoscroll] - enables autoscroll to first invalid field.
///
/// [scrollOffset] - the offset to the bottom position of the field.
///
/// [onChanged] - the callback that calls when user interacting with any field in the [CRForm]
class CRForm extends StatefulWidget {
  const CRForm({
    required this.child,
    required this.controller,
    Key? key,
    this.onChanged,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.ease,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.scrollOffset = 0,
    this.debugMode = false,
    this.autoscroll = true,
    this.recalculateFieldsBeforeValidations = false,
  }) : super(key: key);

  final CRFormController controller;
  final Widget child;

  /// Called when one of the form fields changes.
  ///
  /// Make sure you call [FormFieldState.didChange] in your widget.
  ///
  /// And if you store some custom states inside [CRFormFieldState] and want
  /// run [onChanged] on those states changes, call [FormFieldState.didChange]
  /// in your field state too.
  /// <br>
  /// <br>
  /// For example in this way for widget inherited from [FormField]:
  /// ```
  /// Checkbox(
  ///   value: state.value,
  ///   onChanged: (value) {
  ///     state.didChange(value);
  ///   },
  /// )
  /// ```
  ///
  /// Where [state] in [FormFieldState].
  final VoidCallback? onChanged;

  final Duration animationDuration;
  final Curve animationCurve;
  final double scrollOffset;

  /// autoscroll to first invalid field after validation checking
  final bool autoscroll;

  /// show keyboard line
  final bool debugMode;
  final AutovalidateMode autovalidateMode;
  final bool recalculateFieldsBeforeValidations;

  static CRFormState? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CRFormScope>();

    return scope?._formState;
  }

  @override
  State<CRForm> createState() => CRFormState();
}

class CRFormState extends State<CRForm> {
  final _formKey = GlobalKey<FormState>();
  final _renderManager = RenderParametersManager();
  final _overlayId = 'overlay';

  final _fields = <FormFieldState<dynamic>>{};
  final _idsFields = <MapEntry<String, FormFieldState>>[];

  late kl.KeyboardListener _keyboardListener;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = OverlayEntry(builder: _buildOverlay);
      Overlay.of(context).insert(_overlayEntry!);
      _keyboardListener = kl.KeyboardListener()
        ..addListener(onChange: _keyboardHandle);
      recalculateFieldIds();
    });

    widget.controller.setOnValidateMethod(validateAll);
  }

  @override
  void dispose() {
    // dispose for overlayEntry should only be called by the object's owner;
    // typically the Navigator owns a route and so will call this method when the route is removed
    // we need only call remove method, for clean all links
    _overlayEntry?.remove();
    _overlayEntry = null;
    _keyboardListener.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => recalculateFieldIds(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CRFormScope(
      renderManager: _renderManager,
      formState: this,
      child: Form(
        key: _formKey,
        autovalidateMode: widget.autovalidateMode,
        onChanged: widget.onChanged,
        child: widget.child,
      ),
    );
  }

  /// Register field in [CRForm].
  /// This method adds widget into fields set and will validate this form
  void register(FormFieldState state) {
    _fields.add(state);
  }

  /// Remove field from [CRForm]
  /// Further this form will not be validated
  void unregister(FormFieldState state) {
    _fields.remove(state);
  }

  /// Call this to validating your form
  ///
  /// This method calls [validate] method in each field,
  /// sorts invalid fields and scrolls to top invalid field
  Future<bool> validateAll() async {
    if (widget.recalculateFieldsBeforeValidations) {
      recalculateFieldIds();
    }

    final fieldsIsValid = _formKey.currentState?.validate() ?? false;

    // You need to find the first invalid field first.
    // We will scroll to him
    String? firstInvalidId;
    for (final entry in _idsFields) {
      final valid = entry.value.isValid;

      if (!valid && firstInvalidId == null) {
        firstInvalidId = entry.key;
        break;
      }
    }

    // Here we retrieve render information for the first invalid field
    // 1. Get the difference from the invalid field to the overlay widget
    // (which is below)
    // 2. Scroll field to overlay widget
    // 3. If field is text field - we need to request the keyboard
    if (firstInvalidId != null && widget.autoscroll) {
      final state = _idsFields
          .firstWhere((element) => element.key == firstInvalidId)
          .value;
      final diff = _renderManager.getDiffById(firstInvalidId, _overlayId);
      if (diff != null) {
        final dy = diff.diffBottomToTop + widget.scrollOffset;
        await _doScroll(dy);
      } else if (kDebugMode) {
        print(
          'cr_form: Failed to calculate difference to first invalid field.\n'
          'Try to enable fields recalculation before validation with \n'
          'parameter [recalculateFieldsBeforeValidations] of [CRForm].',
        );
      }
      if (state is CRBaseTextFieldState) {
        state.focusNode.requestFocus();
      }
    }

    return fieldsIsValid;
  }

  /// Method for retrieving fields render metrics
  /// Every found metrics have its id that will saved in list
  void recalculateFieldIds() {
    final fields = <String, FormFieldState>{};

    // every validable widget must contains RenderMetricsObject on the root
    // for detecting self metrics in CRForm
    for (final fieldState in _fields) {
      fieldState.context.visitChildElements((element) {
        if (element.widget is RenderMetricsObject) {
          final widget = element.widget as RenderMetricsObject<String>;
          final id = widget.id;
          fields[id] = fieldState;
        }
      });
    }

    // sorting by position on screen
    // top widget in beginning
    final sortedEntries = _sortByPosition(fields);
    _idsFields
      ..clear()
      ..addAll(sortedEntries);
  }

  /// Method for sorting fields metrics by position on the screen
  /// Top widgets will be at the beginning of the list
  List<MapEntry<String, FormFieldState<dynamic>>> _sortByPosition(
    Map<String, FormFieldState<dynamic>> fields,
  ) {
    return fields.entries.toList()
      ..sort((a, b) {
        final renderDataA = _renderManager.getRenderData(a.key);
        final renderDataB = _renderManager.getRenderData(b.key);

        // ignore: prefer-conditional-expressions
        if (renderDataA != null && renderDataB != null) {
          return renderDataA.yTop > renderDataB.yTop ? 1 : -1;
        } else {
          return 0;
        }
      });
  }

  /// Scrolling with scrollOffset
  /// First, we get Scrollable.of(context) to retrieve the current position
  /// Second, we scroll on passed offset
  Future<void> _doScroll(double scrollOffset) async {
    final controller = Scrollable.of(context);
    final offset = controller.position.pixels;
    var newOffset = controller.position.pixels + scrollOffset;

    if (scrollOffset < 0) {
      final bound = offset - scrollOffset.abs();
      // ignore: prefer-conditional-expressions
      if (bound >= 0) {
        newOffset = bound;
      } else {
        newOffset = 0;
      }
    }

    await controller.position.animateTo(
      newOffset,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final bottomInsetPadding = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: bottomInsetPadding,
          left: 0,
          right: 0,
          child: RenderMetricsObject(
            id: _overlayId,
            manager: _renderManager,
            child: _InvisibleOverlay(
              debugMode: widget.debugMode,
            ),
          ),
        ),
      ],
    );
  }

  void _keyboardHandle(bool _) {
    _overlayEntry?.markNeedsBuild();
  }
}

class _InvisibleOverlay extends StatelessWidget {
  const _InvisibleOverlay({
    Key? key,
    this.debugMode = false,
  }) : super(key: key);

  final bool debugMode;

  @override
  Widget build(BuildContext context) {
    return debugMode
        ? Container(
            height: 10,
            width: 10,
            color: Colors.green,
          )
        : const SizedBox();
  }
}

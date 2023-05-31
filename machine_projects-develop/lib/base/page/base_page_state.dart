import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/page/page_name_widget.dart';
import 'package:machine/base/widget/base_widget_state.dart';
import 'package:machine/base/widget/progress_widget.dart';
import 'package:machine/utils/show_error_dialog.dart';

export 'dart:async';

abstract class BasePageState<T extends StatefulWidget, Bloc extends BlocBase>
    extends BaseWidgetState<T, Bloc> {
  /// Override to hide page page name when not needed (e.g. for bottom
  /// navigation).
  bool showPageName = false;
  bool showLastBlocState = false;

  /// Override to disable auto unfocus on tap on empty space on the page.
  bool unfocusOnTap = true;

  late final String _pageName = widget.runtimeType.toString();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<Bloc, dynamic>(
        builder: _pageBuilder,
        listener: onStateListener,
        bloc: bloc,
        buildWhen: (previous, current) =>
            current is! ActionState || previous is ProgressState,
        listenWhen: listenCondition,
      ),
    );
  }

  /// слухаєш стейти та не перебудовуєш скрін
  @mustCallSuper
  @override
  FutureOr<void> onAction(BuildContext context, ActionState state) {
    FocusScope.of(context).unfocus();
    if (state is OpenPreviousPageState) {
      Navigator.pop(context, state);
    }
    super.onAction(context, state);
  }

  /// коли повертається еррор стейт
  @mustCallSuper
  @override
  FutureOr<void> onError(BuildContext context, ErrorState errorState) async {
    if (errorState is NoNetworkState) {
      showErrorDialog(context, errorState);

      return;
    }
    showErrorDialog(context, errorState);

    if (!mounted) {
      return;
    }
    super.onError(context, errorState);
  }

  Widget progressWidget(BuildContext context) => const ProgressWidget();

  Widget _pageBuilder(BuildContext context, dynamic state) {
    onRebuild(context, state);

    if (isProgressState) {
      FocusScope.of(context).unfocus();
    }

    return GestureDetector(
      onTap: unfocusOnTap ? unfocus : null,
      child: Material(
        child: Stack(children: [
          Builder(builder: bodyWidget),
          if (kDebugMode && showPageName)
            PageNameWidget(
              _pageName,
              lastBlocState:
                  showLastBlocState ? bloc.state.runtimeType.toString() : null,
            ),
        ]),
      ),
    );
  }
}

void unfocus() => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

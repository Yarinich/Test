import 'dart:async';

import 'package:flutter/material.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/bloc/i_bloc.dart';

export 'dart:async';

abstract class BaseWidgetState<T extends StatefulWidget, Bloc extends BlocBase>
    extends State<T> implements IBloc<Bloc> {
  @override
  late final Bloc bloc;

  /// Override this getter if bloc used for this widget is created outside of
  /// this widget.
  bool get closeBloc => true;

  /// Override this if you don't want to unregister bloc in [GetIt].
  bool get unregisterBlocOnDispose => true;

  bool get isProgressState => bloc.state is ProgressState;

  Bloc createBloc();

  @override
  void initState() {
    super.initState();

    bloc = createBloc();
  }

  @override
  void dispose() {
    if (closeBloc) {
      bloc.close();
    }
    super.dispose();
  }

  /// Track widget rebuilds from bloc, get data from new states.
  // base empty implementation
  // ignore: no-empty-block
  void onRebuild(BuildContext context, BaseState state) {}

  void onStateListener(BuildContext context, dynamic state) {
    if (state is ErrorState) {
      onError(context, state);
    } else if (state is ActionState) {
      onAction(context, state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<Bloc, dynamic>(
        builder: _builder,
        listener: onStateListener,
        bloc: bloc,
        buildWhen: (previous, current) =>
            current is! ActionState || previous is ProgressState,
        listenWhen: listenCondition,
      ),
    );
  }

  Widget bodyWidget(BuildContext context);

  /// Override this method to check the Action states of the app.
  @mustCallSuper
  // base empty implementation
  // ignore: no-empty-block
  FutureOr<void> onAction(BuildContext context, ActionState state) {}

  @mustCallSuper
  // base empty implementation
  // ignore: no-empty-block
  FutureOr<void> onError(BuildContext context, ErrorState errorState) {}

  bool listenCondition(dynamic previousState, dynamic currentState) => true;

  Widget _builder(BuildContext context, dynamic state) {
    onRebuild(context, state);

    return Builder(builder: bodyWidget);
  }
}

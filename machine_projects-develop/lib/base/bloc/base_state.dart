part of 'base_bloc.dart';

/// Base state of the app. It rebuilds the page and can be processed
/// in onRebuild if BasePageState is used.
@immutable
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// Base state for actions without rebuilding widgets by Bloc
/// (e.g. show dialog, open new screen, etc.).
///
/// Can be processed in onAction.
abstract class ActionState extends BaseState {}

class InitState extends BaseState {
  const InitState();
}

class ErrorState extends BaseState {
  const ErrorState({
    this.msg,
    this.title,
    this.data,
  });

  final String? msg;
  final String? title;
  final dynamic data;

  @override
  List<Object?> get props => [
        msg,
        title,
        data,
      ];
}

/// Default progress state.
///
/// Yielded from [doAsync] extension while performing future.
///
/// [BasePageState] shows progress widget over the page on this state.
class ProgressState extends BaseState {
  const ProgressState({this.isFullScreen = true});

  final bool isFullScreen;

  @override
  List<Object?> get props => [isFullScreen];
}

class NavigationState extends ActionState {}

/// If you inheriting [UniqueState] and overriding [props] property,
/// add `Uuid().v4()` to props variable
class UniqueState extends BaseState {
  @override
  List<Object?> get props => [const Uuid().v4()];
}

class OpenPreviousPageState extends NavigationState {}

class LogoutState extends NavigationState {}

class UserOffNetworkState extends NavigationState {}

class NoNetworkState extends ErrorState {}

class ShimmerState extends ProgressState {
  const ShimmerState() : super(isFullScreen: false);
}

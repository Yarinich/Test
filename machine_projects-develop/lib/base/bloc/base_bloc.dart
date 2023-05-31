import 'package:cr_logger/cr_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/base/error_handler.dart';
import 'package:machine/base/widget/base_widget_state.dart';
import 'package:uuid/uuid.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'base_event.dart';

part 'base_state.dart';

abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc({BaseState? initState}) : super(initState ?? const InitState()) {
    initialState = initState ?? const InitState();
    init();
    on<RebuildEvent>((_, emit) => emit(UniqueState()));
  }

  late BaseState initialState;

  /// Used for setting event handlers from mixin for bloc. See [PlacesBlocMixin]
  /// for example.
  ///
  /// Base empty implementation.
  // ignore: no-empty-block
  void init() {}

  @override
  void onError(Object error, StackTrace stackTrace) {
    log.e(
      'onError',
      error,
      stackTrace,
    );
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);.
    super.onError(error, stackTrace);
  }

  void rebuild() => add(RebuildEvent());

  // ignore: long-parameter-list
  Stream<BaseState> doAsync<T>(
    Future Function() function, {
    FutureOr<BaseState?> Function(T response)? onComplete,
    OnErrorCallback? onError = onErrorHandler,
    BaseState? progressState,
    bool showProgress = true,
  }) async* {
    if (showProgress) {
      yield progressState ?? const ProgressState();
    }
    try {
      final response = await function();
      yield (await onComplete?.call(response)) ?? const InitState();
    } catch (error, stack) {
      if (onError != null) {
        final res = await onError(error, stack);
        if (res is BaseState) {
          yield res;
        } else {
          yield const InitState();
        }
      } else {
        yield const InitState();
      }
    }
  }
}

extension FutureErrorHandlerExt<T> on Future<T> {
  Future<T> onErrorHandler(
    FutureOr<T> Function(Object error, StackTrace stack) onError,
  ) async {
    try {
      return await this;
    } catch (ex, stack) {
      return await onError(ex, stack);
    }
  }
}

typedef OnErrorCallback = FutureOr<dynamic> Function(
  Object error,
  StackTrace stack,
);

extension FutureDoAsync<T> on Future<T> {
  static const initState = InitState();

  Future<T> delay(Duration duration) =>
      Future.delayed(duration).then((_) => this);
}

ErrorState onErrorHandler(
  Object error,
  StackTrace stackTrace,
) {
  log.e(
    error.toString(),
    error,
    stackTrace,
  );

  return errorHandler(
    error,
    stackTrace,
  );
}

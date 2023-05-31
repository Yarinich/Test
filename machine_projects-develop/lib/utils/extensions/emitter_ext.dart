import 'package:machine/base/bloc/base_bloc.dart';

/// Bloc [Emitter] extension for convenient usage with [doAsync] extension
/// streams.
extension EmitterExt on Emitter {
  /// Takes stream with states and emits them while stream is active.
  void async(Stream<BaseState> stream) =>
      forEach<BaseState>(stream, onData: (state) => state);

  /// Takes future and emits states it which is returned from it.
  void futureAsync(Future<BaseState> future) =>
      future.then((state) => this(state));
}

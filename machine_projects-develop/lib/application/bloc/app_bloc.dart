import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:machine/application/bloc/app_event.dart';
import 'package:machine/application/bloc/app_state.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/database/hive_provider.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';

class AppBloc extends BaseBloc {
  AppBloc() : super() {
    /// зчитує івент та повертає потрібний стейт
    on<InitializeAppEvent>(
      (event, emit) => emit.futureAsync(_initializeApp()),
    );
    on<CheckUserStateEvent>(
      (_, emit) => emit(_checkUserState()),
    );
    on<NoInternetConnectionEvent>(
      (event, emit) => emit(MoveToNoInternetPage()),
    );
  }

  static const _splashDuration = Duration(milliseconds: 500);

  Future<BaseState> _initializeApp() async {
    /// Щоб сплеш скрін був хоча б пів секунди
    await Future.delayed(_splashDuration);

    /// Перевіряємо інтернет юзера
    await Connectivity().checkConnectivity();
    // if (result == ConnectivityResult.none) {
    //   return MoveToNoInternetPage();
    // }

    /// Вертаємо потібний нам стейт, щоб закрити сплеш скрін
    return SplashEndedState();
  }

  /// Перевіряємо чи авторизован юзер.
  BaseState _checkUserState() {
    return UserState(
      isUserLogged: HiveProvider.instance.user?.email != null,
    );
  }
}

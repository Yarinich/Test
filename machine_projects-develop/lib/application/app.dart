import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:machine/application/bloc/app_bloc.dart';
import 'package:machine/application/bloc/app_event.dart';
import 'package:machine/application/bloc/app_state.dart';
import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/pages/auth/sign_in/sign_in_page.dart';
import 'package:machine/pages/auth/sign_up/sign_up_page.dart';
import 'package:machine/pages/bottom_navigation/bottom_navigation_page.dart';
import 'package:machine/pages/no_internet_connection_page/no_internet_connection_page.dart';
import 'package:machine/pages/splash/splash_page.dart';
import 'package:machine/utils/extensions/navigator_state_ext.dart';
import 'package:machine/utils/show_error_dialog.dart';

/// Global navigation key for opening new Routes
/// without calling [Navigator.of(context)]
final _navKey = GlobalKey<NavigatorState>();

/// Static getter for convenient route navigation.
///
/// E.g. nav.pushNamed(routeName)
///
/// Can be used anywhere in the app
NavigatorState? get nav => _navKey.currentState;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription? _connectionSub;
  final _appBloc = AppBloc();

  @override
  void initState() {
    super.initState();

    /// Підписуємося на зміни стану інтернету
    _connectionSub = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      /// якщо юзер ні до чого не підключен
      if (result == ConnectivityResult.none) {
        _appBloc.add(NoInternetConnectionEvent());
      } else {
        /// Якщо підключен, то перевіряється чи юзер авторизован
        _appBloc.add(CheckUserStateEvent());
      }
    });
    _appBloc.add(InitializeAppEvent());
  }

  /// Стейт всього додатку
  @override
  void dispose() {
    _appBloc.close();
    _connectionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),

      /// Слухаємо наш блок
      child: BlocListener(
        bloc: _appBloc,
        listener: _onStateChange,
        child: MaterialApp(
          navigatorKey: _navKey,
          debugShowCheckedModeBanner: false,

          /// початковий скрін
          initialRoute: SplashPage.routeName,

          /// Наші всі можливі роути
          routes: {
            SplashPage.routeName: (context) => const SplashPage(),
            SignInPage.routeName: (context) => const SignInPage(),
            SignUpPage.routeName: (context) => const SignUpPage(),
            BottomNavigationPage.routeName: (context) =>
                const BottomNavigationPage(),
            NoInternetConnectionPage.routeName: (context) =>
                const NoInternetConnectionPage(),
          },
          title: 'Car app',
        ),
      ),
    );
  }

  Future<void> _onStateChange(BuildContext _, BaseState state) async {
    if (state is ErrorState) {
      showErrorDialog(context, state);
    } else if (state is AppInitializedState) {
      _appBloc.add(SplashEndedEvent());
    } else if (state is SplashEndedState) {
      //   _appBloc.add(CheckUserStateEvent());
    } else if (state is UserState) {
      await _onUserState(state);
    } else if (state is MoveToNoInternetPage) {
      await nav?.pushNamedAndRemoveAll(NoInternetConnectionPage.routeName);
    }
  }

  /// Якщо юзер авторизован, то перекидує на основна пейжду. Якщо ні, то на сайн ін пейждц
  Future _onUserState(UserState state) async {
    if (!state.isUserLogged) {
      return nav?.pushNamedAndRemoveAll(SignInPage.routeName);
    }

    return nav?.pushNamedAndRemoveAll(BottomNavigationPage.routeName);
  }
}

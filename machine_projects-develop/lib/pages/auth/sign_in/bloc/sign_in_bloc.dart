import 'dart:async';

import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/database/hive_provider.dart';
import 'package:machine/data/firebase/firebase_auth_service.dart';
import 'package:machine/data/models/user_model.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends BaseBloc {
  SignInBloc() {
    on<SignInWithEmailEvent>(
      (event, emit) => emit.async(_signIn(event)),
    );
    on<SignInWithGoogleEvent>(
      (event, emit) => emit.async(_signInWithGoogle()),
    );
  }

  final _authService = FirebaseAuthService();

  Stream<BaseState> _signIn(SignInWithEmailEvent event) => doAsync<UserModel?>(
        () => _authService
            .signInWithEmail(event.email, event.password)
            .then((UserModel? user) async {
          HiveProvider.instance.user = user;
          return user;
        }),
        onComplete: (user) => user != null ? SignedInState(user) : initialState,
      );

  Stream<BaseState> _signInWithGoogle() => doAsync<UserModel?>(
        () => _authService.signInWithGoogle().then((UserModel? user) async {
          HiveProvider.instance.user = user;
          return user;
        }),
        onComplete: (user) => user != null ? SignedInState(user) : initialState,
      );
}

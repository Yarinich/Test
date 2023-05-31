import 'dart:async';

import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/database/hive_provider.dart';
import 'package:machine/data/firebase/firebase_auth_service.dart';
import 'package:machine/data/network/apis/auth_api.dart';
import 'package:machine/data/network/requests/auth/sing_up_request.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends BaseBloc {
  SignUpBloc() {
    on<SignUpEvent>(
      (event, emit) => emit.async(_signUp(event)),
    );

    on<SignUpWithGoogleEvent>(
      (event, emit) => emit.async(_signUpWithGoogle()),
    );
  }

  final _authProvider = FirebaseAuthService();
  final _authApi = AuthApi();

  Stream<BaseState> _signUp(SignUpEvent event) {
    return doAsync(
      () => _authProvider
          .signUpWithEmail(event.name, event.email, event.password)
          .then((user) async {
        if (user != null) {
          await _authApi.signUp(SignUpRequest(user));
          HiveProvider.instance.user = user;
        }

        return user;
      }),
      onComplete: (user) =>
          user != null ? OpenResourceInfoPageState() : initialState,
    );
  }

  Stream<BaseState> _signUpWithGoogle() {
    return doAsync(
      () => _authProvider.signInWithGoogle().then((user) async {
        if (user != null) {
          await _authApi.signUp(SignUpRequest(user));
          HiveProvider.instance.user = user;
        }
        return user;
      }),
      onComplete: (user) =>
          user != null ? OpenResourceInfoPageState() : initialState,
    );
  }
}

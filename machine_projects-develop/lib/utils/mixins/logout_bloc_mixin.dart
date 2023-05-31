import 'package:machine/base/bloc/base_bloc.dart';
import 'package:machine/data/database/hive_provider.dart';
import 'package:machine/data/firebase/firebase_auth_service.dart';
import 'package:machine/utils/extensions/emitter_ext.dart';
import 'package:machine/utils/mixins/logout_event.dart';

mixin LogoutBlocMixin on BaseBloc {
  @override
  void init() {
    super.init();
    on<LogoutEvent>(
      (event, emit) => emit.async(_logout()),
    );
  }

  final _authApi = FirebaseAuthService();

  Stream<BaseState> _logout() => doAsync(
        () => _authApi.signOut(),
        onComplete: (_) {
          HiveProvider.instance.clean();

          return LogoutState();
        },
      );
}

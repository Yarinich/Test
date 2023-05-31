import 'package:machine/data/converters/hive/user_hive_converter.dart';
import 'package:machine/data/database/repository/hive_repository.dart';
import 'package:machine/data/models/user_model.dart';

class HiveProvider {
  HiveProvider._();

  static final instance = HiveProvider._();

  final _repository = HiveRepository();
  final _userConverter = UserHiveConverter();

  UserModel? get user => _userConverter.inToOut(_repository.getUser());

  set user(UserModel? user) =>
      _repository.saveUser(_userConverter.outToIn(user));

  // TODO: remove later
  Stream<UserModel?> get onUserChange => _repository.onUserChange.map(
        (userEvent) => _userConverter.inToOut(userEvent),
      );

  Future<void> init() => _repository.init();

  void clean() => _repository.clean();
}

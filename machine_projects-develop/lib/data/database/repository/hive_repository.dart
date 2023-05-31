import 'package:hive_flutter/hive_flutter.dart';
import 'package:machine/data/database/models/user_hive.dart';
import 'package:machine/data/database/repository/hive_contract.dart';

/// робота з бд
class HiveRepository {
  late final Box _userBox;

  Future init() => Hive.initFlutter().then((hive) async {
        Hive.registerAdapter(UserHiveAdapter());

        _userBox = await Hive.openBox<UserHive>(HiveContract.userBoxKey);
      });

  Future<void> clean() async {
    await _userBox.clear();
  }

  void saveUser(UserHive? user) {
    if (user != null) {
      _userBox.put(HiveContract.userKey, user);
    } else {
      _userBox.clear();
    }
  }

  UserHive? getUser() => _userBox.get(HiveContract.userKey);

  // TODO: remove later
  void deleteUser(UserHive user) => _userBox.delete(HiveContract.userKey);

  // TODO: remove later
  Stream<UserHive?> get onUserChange =>
      _userBox.watch(key: HiveContract.userKey).map(
            (boxEvent) => boxEvent.value,
          );
}

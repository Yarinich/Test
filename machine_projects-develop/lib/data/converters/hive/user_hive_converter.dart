import 'package:machine/data/database/models/user_hive.dart';
import 'package:machine/data/models/user_model.dart';

/// Конвертує модельку з бд в нашу модель, яку ми вже будемо використовувати
class UserHiveConverter {
  UserModel? inToOut(UserHive? inObject) {
    return inObject != null
        ? UserModel(
            name: inObject.name,
            email: inObject.email,
            photoUrl: inObject.photoUrl,
          )
        : null;
  }

  UserHive? outToIn(UserModel? outObject) {
    return outObject != null
        ? UserHive(
            name: outObject.name,
            email: outObject.email,
            photoUrl: outObject.photoUrl,
          )
        : null;
  }
}

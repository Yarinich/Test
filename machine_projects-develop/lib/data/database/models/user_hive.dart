import 'package:hive_flutter/hive_flutter.dart';

part 'user_hive.g.dart';

@HiveType(typeId: 0)
class UserHive extends HiveObject {
  UserHive({
    required this.name,
    required this.email,
    this.photoUrl,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? photoUrl;
}

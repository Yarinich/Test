import 'package:cr_logger/cr_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:machine/application/app.dart';
import 'package:machine/constants.dart';
import 'package:machine/data/database/hive_provider.dart';

Future<void> main() async {
  /// цей метод потрібен, щоб main метод був асинхроним
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// ініт бази данних
  await HiveProvider.instance.init();

  /// ініт дебаггера
  await _initLogger();

  /// загружка нашого додатку
  runApp(const App());
}

Future<void> _initLogger() async {
  final logger = CRLoggerInitializer.instance;

  await logger.init(
    printLogs: !kReleaseMode,
    useCrLoggerInReleaseBuild: !kReleaseMode,
  );

  logger.appInfo = {'Endpoint': serverBaseURL};
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/config/app_environment.dart';
import 'package:web_learner/core/logging/app_logger.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return const AppEnvironment(
    appName: 'Web Learner',
    flavor: AppFlavor.development,
    baseUrl: 'http://61.150.84.25:100',
  );
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  return const AppLogger();
});

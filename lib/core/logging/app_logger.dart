import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger();

  void info(String message) {
    debugPrint('[INFO] $message');
  }

  void warning(String message) {
    debugPrint('[WARN] $message');
  }

  void error(String message) {
    debugPrint('[ERROR] $message');
  }
}

import 'dart:developer' as dev;

class AppLogger {
  static void info(String message, [String tag = 'INFO']) {
    dev.log('🔵 [$tag] $message');
  }

  static void warning(String message, [String tag = 'WARN']) {
    dev.log('🟡 [$tag] $message');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace, String tag = 'ERROR']) {
    dev.log('🔴 [$tag] $message', error: error, stackTrace: stackTrace);
  }
}

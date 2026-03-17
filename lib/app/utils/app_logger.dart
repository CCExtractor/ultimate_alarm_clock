import 'package:flutter/foundation.dart';

class AppLogger {
  static void d(String message, {String tag = 'App'}) {
    if (!kDebugMode) return;
    debugPrint('[DEBUG][$tag] ${_redact(message)}');
  }

  static void i(String message, {String tag = 'App'}) {
    debugPrint('[INFO][$tag] ${_redact(message)}');
  }

  static void w(String message, {String tag = 'App'}) {
    debugPrint('[WARN][$tag] ${_redact(message)}');
  }

  static void e(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final safeMessage = _redact(message);
    final safeError = error == null ? '' : ' | error=${_redact(error.toString())}';
    debugPrint('[ERROR][$tag] $safeMessage$safeError');
    if (stackTrace != null && kDebugMode) {
      debugPrint(stackTrace.toString());
    }
  }

  static String _redact(String input) {
    var output = input;
    output = output.replaceAll(
      RegExp(r'(?i)(token\s*[:=\-]?\s*)([^,\s]+)'),
      r'$1[REDACTED]',
    );
    output = output.replaceAll(
      RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'),
      '[REDACTED_EMAIL]',
    );
    output = output.replaceAll(RegExp(r'content://\S+'), '[REDACTED_URI]');
    return output;
  }
}

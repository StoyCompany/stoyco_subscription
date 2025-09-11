import 'dart:developer' as developer;

class LoggerApp {

  static void log(String message) {
    _printWithColor('[LOG] $message', _AnsiColors.green);
  }

  static void error(String message, {String? name}) {
    _printWithColor('[ERROR ${name != null ? '($name)' : ''}] $message', _AnsiColors.red);
  }

  static void warning(String message) {
    _printWithColor('[WARNING] $message', _AnsiColors.yellow);
  }

  static void _printWithColor(String message, String colorCode) {
    developer.log('$colorCode$message${_AnsiColors.reset}');
  }
}


/// Códigos ANSI para colores de texto.
class _AnsiColors {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
}

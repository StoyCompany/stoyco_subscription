import 'package:logger/logger.dart';

class StoyCoLogger {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void debug(String message) {
    final String messageToPrint = '[ STOYCO LOG DEBUG ] $message';
    _logger.d(messageToPrint);
  }

  static void info(String message) {
    final String messageToPrint = '[ STOYCO LOG INFO ] $message';
    _logger.i(messageToPrint);
  }

  static void warning(String message) {
    final String messageToPrint = '[ STOYCO LOG WARNING ] $message';
    _logger.w(messageToPrint);
  }

  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final String messageToPrint =
        '[ STOYCO LOG ERROR : ${tag != null ? '($tag)' : ''}] $message';
    _logger.e(messageToPrint, error: error, stackTrace: stackTrace);
  }
}

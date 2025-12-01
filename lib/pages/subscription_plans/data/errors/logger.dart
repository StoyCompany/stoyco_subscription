import 'package:logger/logger.dart';

class StoyCoLogger {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void debug(String message, {String? tag}) {
    final String messageToPrint = tag != null
        ? '[ STOYCO LOG DEBUG : ($tag)] $message'
        : '[ STOYCO LOG DEBUG ] $message';
    _logger.d(messageToPrint);
  }

  static void info(String message, {String? tag}) {
    final String messageToPrint = tag != null
        ? '[ STOYCO LOG INFO : ($tag)] $message'
        : '[ STOYCO LOG INFO ] $message';
    _logger.i(messageToPrint);
  }

  static void warning(String message, {String? tag}) {
    final String messageToPrint = tag != null
        ? '[ STOYCO LOG WARNING : ($tag)] $message'
        : '[ STOYCO LOG WARNING ] $message';
    _logger.w(messageToPrint);
  }

  static void warn(String message, {String? tag}) {
    warning(message, tag: tag);
  }

  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    final String messageToPrint = tag != null
        ? '[ STOYCO LOG ERROR : ($tag)] $message'
        : '[ STOYCO LOG ERROR ] $message';
    _logger.e(messageToPrint, error: error, stackTrace: stackTrace);
  }
}

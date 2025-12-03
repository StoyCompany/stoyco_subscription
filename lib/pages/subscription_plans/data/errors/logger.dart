import 'package:logger/logger.dart';

class StoyCoLogger {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void debug(String message, {String? tag}) {
    final String messageToPrint = tag != null
        ? '[ STOYCO SUBSCRIPTION LOG DEBUG : ($tag)] $message'
        : '[ STOYCO SUBSCRIPTION LOG DEBUG ] $message';
    _logger.d(messageToPrint);
  }

  static void info(String message, {String? tag}) {
    final String messageToPrint = tag != null
        ? '[ STOYCO SUBSCRIPTION LOG INFO : ($tag)] $message'
        : '[ STOYCO SUBSCRIPTION LOG INFO ] $message';
    _logger.i(messageToPrint);
  }

  static void warning(String message, {String? tag}) {
    final String messageToPrint = tag != null
        ? '[ STOYCO SUBSCRIPTION LOG WARNING : ($tag)] $message'
        : '[ STOYCO SUBSCRIPTION LOG WARNING ] $message';
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
        ? '[ STOYCO SUBSCRIPTION LOG ERROR : ($tag)] $message'
        : '[ STOYCO SUBSCRIPTION LOG ERROR ] $message';
    _logger.e(messageToPrint, error: error, stackTrace: stackTrace);
  }
}

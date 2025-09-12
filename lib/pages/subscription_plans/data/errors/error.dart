
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/logger.dart';

class ErrorFailure extends Failure {
  factory ErrorFailure.decode(
    Error? error,
  ) {
    StoyCoLogger.error(
      error.toString(),
      error: error,
      stackTrace: error?.stackTrace,
      tag: 'FAILURE[ERROR][TRACE]',
    );
    return ErrorFailure._(
      error: error,
      message: error.toString(),
    );
  }
  ErrorFailure._({
    this.error,
    this.message,
  });
  final Error? error;
  @override
  final String? message;
}

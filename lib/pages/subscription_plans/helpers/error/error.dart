
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/logger.dart';

class ErrorFailure extends Failure {
  factory ErrorFailure.decode(
    Error? error,
  ) {
    LoggerApp.error(error.toString(), name: 'FAILURE[ERROR]');
    LoggerApp.error((error?.stackTrace).toString(),
        name: 'FAILURE[ERROR][TRACE]');
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

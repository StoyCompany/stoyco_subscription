import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/logger.dart';

class ExceptionFailure extends Failure {
  factory ExceptionFailure.decode(Exception? error) {
    StoyCoLogger.error(error.toString(), tag: 'FAILURE[EXCEPTION]');
    return ExceptionFailure._(
      error: error,
      message: error.toString(),
    );
  }
  ExceptionFailure._({
    this.error,
    this.message,
  });
  @override
  final String? message;
  final Exception? error;
}

class PlatformFailure extends Failure {
  PlatformFailure._({
    this.message,
    this.error,
  });

  factory PlatformFailure.decode(PlatformException? error) {
    StoyCoLogger.error((error).toString(), tag: 'FAILURE[PLATFORM][EXCEPTION]');
    StoyCoLogger.error((error?.message).toString(), tag: 'FAILURE[PLATFORM][MESSAGE]');
    StoyCoLogger.error((error?.stacktrace).toString(), tag: 'FAILURE[PLATFORM][TRACE]');

    return PlatformFailure._(
      error: error,
      message: error?.message,
    );
  }
  @override
  final String? message;
  final PlatformException? error;
}

class DioFailure extends Failure {
  factory DioFailure.decode(DioException? error) {
    StoyCoLogger.error((error?.message).toString(), stackTrace: error?.stackTrace, error: error, tag: 'FAILURE[DIO][EXCEPTION]');
    return DioFailure._(
      error: error,
      message: error.toString(),
    );
  }
  DioFailure._({
    this.error,
    this.message,
  });
  @override
  final String? message;
  final Exception? error;
}

//Exception: Exception: functionToUpdateToken is not set
class FunctionToUpdateTokenNotSetException implements Exception {
  /// Creates a `FunctionToUpdateTokenNotSetException` with an optional message
  ///
  /// * `message`: The error message (defaults to "functionToUpdateToken is not set")
  FunctionToUpdateTokenNotSetException([
    this.message = 'functionToUpdateToken is not set',
  ]);

  /// The error message associated with the exception
  final String message;

  /// Returns a string representation of the exception
  @override
  String toString() => 'FunctionToUpdateTokenNotSetException: $message';
}

/// Exception thrown when the user token is empty or invalid.
class EmptyUserTokenException implements Exception {
  /// Creates an `EmptyUserTokenException` with an optional message.
  ///
  /// * `message`: The error message (defaults to "User token is empty")
  EmptyUserTokenException([this.message = 'User token is empty']);

  /// The error message associated with the exception
  final String message;

  /// Returns a string representation of the exception
  @override
  String toString() => 'EmptyUserTokenException: $message';
}

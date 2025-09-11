import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/logger.dart';

class ExceptionFailure extends Failure {
  factory ExceptionFailure.decode(Exception? error) {
    LoggerApp.error(error.toString(), name: 'FAILURE[EXCEPTION]');
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
    LoggerApp.error((error).toString(), name: 'FAILURE[PLATFORM][EXCEPTION]');
    LoggerApp.error((error?.message).toString(), name: 'FAILURE[PLATAFORM][MESSAGE]');
    LoggerApp.error((error?.stacktrace).toString(), name: 'FAILURE[PLATFORM][TRACE]');
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
    LoggerApp.error(error.toString(), name: 'FAILURE[DIO][EXCEPTION]');
    LoggerApp.error((error?.message).toString(), name: 'FAILURE[DIO][MESSAGE]');
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

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_data_source.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

class PaymentSummaryService {
  factory PaymentSummaryService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?> Function()? functionToUpdateToken,
  }) {
    instance = PaymentSummaryService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    return instance;
  }

  PaymentSummaryService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _dataSource = PaymentSummaryDataSource(environment: environment);
    _repository = PaymentSummaryRepository(_dataSource, userToken);
    _repository.updateToken(userToken);
    _dataSource.updateToken(userToken);
  }

  static PaymentSummaryService instance = PaymentSummaryService._();

  String userToken;

  StoycoEnvironment environment;

  Future<String?> Function()? functionToUpdateToken;

  late final PaymentSummaryDataSource _dataSource;

  late final PaymentSummaryRepository _repository;

  void updateToken(String token) {
    userToken = token;
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  void setFunctionToUpdateToken(Future<String?> Function()? function) {
    functionToUpdateToken = function;
  }

  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }
      final String? newToken = await functionToUpdateToken!();
      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _repository.updateToken(newToken);
        _dataSource.updateToken(newToken);
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
  }

  Future<Either<Failure, PaymentSummaryInfoResponse>> getPaymentSummaryByPlan({
    required String planId,
    required String recurrenceType,
  }) async {
    try {
      await verifyToken();
      final PaymentSummaryInfoResponse result = await _repository.getPaymentSummaryByPlan(
        planId: planId,
        recurrenceType: recurrenceType,
      );
      return Right<Failure, PaymentSummaryInfoResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

class PartnerProfileService {
  factory PartnerProfileService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? Function()? functionToUpdateToken,
  }) {
    instance = PartnerProfileService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    return instance;
  }

  PartnerProfileService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _dataSource = PartnerProfileDataSource(environment: environment);
    _repository = PartnerProfileRepository(_dataSource, userToken);
    _repository.updateToken(userToken);
    _dataSource.updateToken(userToken);
  }

  static PartnerProfileService instance = PartnerProfileService._();

  String userToken;

  StoycoEnvironment environment;

  Future<String?>? Function()? functionToUpdateToken;

  late final PartnerProfileDataSource _dataSource;
  late final PartnerProfileRepository _repository;

  void updateToken(String token) {
    userToken = token;
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  void setFunctionToUpdateToken(Future<String?>? Function()? function) {
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

  Future<Either<Failure, LowestPricePlanResponseModel>>
  getLowestPricePlanByPartner(String partnerId) async {
    try {
      final LowestPricePlanResponseModel result = await _repository
          .getLowestPricePlanByPartner(partnerId: partnerId);
      return Right<Failure, LowestPricePlanResponseModel>(result);
    } on DioException catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(
        ExceptionFailure.decode(error),
      );
    }
  }

  Future<Either<Failure, SubscriptionIsActiveResponse>>
  getLastUserPlanByPartner(String partnerId) async {
    try {
      await verifyToken();
      final SubscriptionIsActiveResponse result = await _repository
          .getLastUserPlanByPartner(partnerId: partnerId);
      return Right<Failure, SubscriptionIsActiveResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }
}

import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_repository.dart';
/// A service class to handle coach marks and onboarding functionality.
///
/// This class provides methods to fetch, update, and interact with coach mark
/// data, as well as manage user onboarding progress.
///
/// It also handles user token management and provides a stream to indicate
/// whether coach marks are currently open.
class SubscriptionPlansService {
  /// Creates a singleton instance of `SubscriptionPlansService`.
  ///
  /// * `environment`: The current environment (development, production, etc.). Defaults to `StoycoEnvironment.development`.
  /// * `userToken`: The user's authentication token.
  /// * `functionToUpdateToken`: An optional function to update the token if it becomes invalid.
  factory SubscriptionPlansService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? functionToUpdateToken,
  }) {
    instance = SubscriptionPlansService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );

    return instance;
  }

  /// Private constructor to enforce singleton pattern.
  SubscriptionPlansService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _subscriptionPlansDataSource = SubscriptionPlansDataSource(
      environment: environment,
    );

    _subscriptionPlansRepository = SubscriptionPlansRepository(
      _subscriptionPlansDataSource,
      userToken,
    );

    _subscriptionPlansRepository.updateToken(userToken);
    _subscriptionPlansDataSource.updateToken(userToken);
  }

  static SubscriptionPlansService instance = SubscriptionPlansService._();

  String userToken;
  StoycoEnvironment environment;
  late SubscriptionPlansRepository _subscriptionPlansRepository;
  late SubscriptionPlansDataSource _subscriptionPlansDataSource;
  Future<String?>? functionToUpdateToken;

  /// Updates the user token and associated repositories.

  void updateToken(String token) {
    userToken = token;
    _subscriptionPlansRepository.updateToken(token);
  }

  /// Verifies the user token and updates it if necessary.
  ///
  /// Throws an exception if token update fails.
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }

      final String? newToken = await functionToUpdateToken;

      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _subscriptionPlansRepository.updateToken(newToken);
        _subscriptionPlansDataSource.updateToken(newToken);
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
  }

  /// Sets the function to update the user token.
  void setFunctionToUpdateToken(Future<String?>? function) {
    functionToUpdateToken = function;
  }

  /// Fetches subscription plans by partner and user.
  Future<Either<Failure, SubscriptionPlanResponse>> getSubscriptionPlansByPartnerAndUser(GetSubscriptionPlansRequest request) async {
    try {
      await verifyToken();
      return await _subscriptionPlansRepository.getSubscriptionPlans(request);
    } catch (e) {
      return Left<Failure, SubscriptionPlanResponse>(ExceptionFailure.decode(Exception('Error getting subscription plans by user: $e')));
    }
  }

}

import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_repository.dart';
class SubscriptionPlansService {
  /// Service class for managing subscription plans and user authentication.
  ///
  /// This class provides methods to fetch subscription plans, manage user tokens,
  /// and handle token updates for API requests. It follows the singleton pattern
  /// to ensure a single instance throughout the app lifecycle.
  ///
  /// Usage:
  /// ```dart
  /// final service = SubscriptionPlansService(
  ///   environment: StoycoEnvironment.production,
  ///   userToken: 'your_token',
  /// );
  /// final response = await service.getSubscriptionPlansByPartnerAndUser(request);
  /// ```
  /// Returns the singleton instance of [SubscriptionPlansService].
  ///
  /// - [environment]: The current environment (development, production, etc.). Defaults to [StoycoEnvironment.development].
  /// - [userToken]: The user's authentication token.
  /// - [functionToUpdateToken]: Optional function to update the token if it becomes invalid.
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

  /// Private constructor for singleton pattern.
  ///
  /// - [environment]: The current environment.
  /// - [userToken]: The user's authentication token.
  /// - [functionToUpdateToken]: Optional function to update the token.
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

  /// Singleton instance of [SubscriptionPlansService].
  static SubscriptionPlansService instance = SubscriptionPlansService._();

  /// The user's authentication token.
  String userToken;

  /// The current environment (development, production, etc.).
  StoycoEnvironment environment;

  /// Internal repository for subscription plans.
  late SubscriptionPlansRepository _subscriptionPlansRepository;

  /// Internal data source for subscription plans.
  late SubscriptionPlansDataSource _subscriptionPlansDataSource;

  /// Optional function to update the user token if it becomes invalid.
  Future<String?>? functionToUpdateToken;

  /// Updates the user token and associated repositories.
  ///
  /// - [token]: The new user authentication token.
  void updateToken(String token) {
    userToken = token;
    _subscriptionPlansRepository.updateToken(token);
  }

  /// Verifies the user token and updates it if necessary.
  ///
  /// Throws [FunctionToUpdateTokenNotSetException] if the update function is not set.
  /// Throws [EmptyUserTokenException] if the token update fails.
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
  ///
  /// - [function]: The function to update the token.
  void setFunctionToUpdateToken(Future<String?>? function) {
    functionToUpdateToken = function;
  }

  /// Fetches subscription plans for a given partner and user.
  ///
  /// - [request]: The request model containing partner and user information.
  ///
  /// Returns [Either] with [SubscriptionPlanResponse] on success or [Failure] on error.
  Future<Either<Failure, SubscriptionPlanResponse>> getSubscriptionPlansByPartnerAndUser(GetSubscriptionPlansRequest request) async {
    try {
      return await _subscriptionPlansRepository.getSubscriptionPlans(request);
    } catch (e) {
      return Left<Failure, SubscriptionPlanResponse>(ExceptionFailure.decode(Exception('Error getting subscription plans by user: $e')));
    }
  }

}

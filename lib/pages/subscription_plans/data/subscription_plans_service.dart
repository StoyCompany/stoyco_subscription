import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_method_modification_request.dart';
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
    Future<String?> Function()? functionToUpdateToken,
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

  /// Callback function to refresh the authentication token.
  Future<String?> Function()? functionToUpdateToken;

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
      final String? newToken = await functionToUpdateToken?.call();
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
  void setFunctionToUpdateToken(Future<String?> Function()? function) {
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

  /// Subscribes a user to a plan.
  ///
  /// Overview: Initiates a subscription for the user to the specified plan.
  /// Atomic Level: Organism – handles business logic and integration.
  /// Parameters:
  /// - [request]: The model containing user and plan information for subscription.
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  /// Example:
  /// ```dart
  /// final result = await service.subscribeToPlan(
  ///   SubscribeRequest(userId: '123', planId: 'abc'),
  /// );
  /// ```
  Future<Either<Failure, bool>> subscribeToPlan(SubscribeRequest request) async {
    try {
      return await _subscriptionPlansRepository.subscribeToPlan(request);
    } catch (e) {
      return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error subscribing to plan: $e')));
    }
  }

  /// Unsubscribes a user from a plan.
  ///
  /// Overview: Cancels the user's active subscription for the specified plan.
  /// Atomic Level: Organism – handles business logic and integration.
  /// Parameters:
  /// - [request]: The model containing user and plan information for unsubscription.
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  /// Example:
  /// ```dart
  /// final result = await service.unsubscribe(
  ///   String planId,
  /// );
  /// ```
  Future<Either<Failure, bool>> unsubscribe(String planId) async {
    try {
      return await _subscriptionPlansRepository.unsubscribe(planId);
    } catch (e) {
      return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error unsubscribing plan: $e')));
    }
  }

  /// Renews a user's subscription to a plan.
  ///
  /// Overview: Renews the user's active subscription for the specified plan.
  /// Atomic Level: Organism – handles business logic and integration.
  /// Parameters:
  /// - [request]: The model containing user and plan information for renewal.
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  /// Example:
  /// ```dart
  /// final result = await service.renewSubscription(
  ///   String planId,
  /// );
  /// ```
  Future<Either<Failure, bool>> renewSubscription(String planId) async {
    try {
      return await _subscriptionPlansRepository.renewSubscription(planId);
    } catch (e) {
      return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error renewing subscription: $e')));
    }
  }

  /// Updates the payment method for a user's subscription.
  ///
  /// Overview: Changes the payment method for the user's active subscription.
  /// Atomic Level: Organism – handles business logic and integration.
  /// Parameters:
  /// - [request]: The model containing user, plan, and payment method information.
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  /// Example:
  /// ```dart
  /// final result = await service.updateSubscriptionPaymentMethod(
  ///   SubscriptionMethodModificationRequest(userId: '123', planId: 'abc', paymentMethodId: 'pm_456'),
  /// );
  /// ```
  Future<Either<Failure, bool>> updateSubscriptionPaymentMethod(SubscriptionMethodModificationRequest request) async {
    try {
      return await _subscriptionPlansRepository.updateSubscriptionPaymentMethod(request);
    } catch (e) {
      return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error updating payment method: $e')));
    }
  }

}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_for_app_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_method_modification_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_modification_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_repository.dart';

/// {@template subscription_plans_service}
/// Service class for managing subscription plans with automatic Firebase Auth token management.
///
/// This singleton service provides methods to fetch subscription plans, subscribe, unsubscribe,
/// and manage payment methods. It automatically handles token retrieval and refresh from Firebase Auth.
///
/// **Token Management:**
/// - Automatically retrieves token from Firebase Auth before each request
/// - Refreshes token before making API calls
/// - No manual token management required
///
/// **Usage:**
/// ```dart
/// final service = SubscriptionPlansService(
///   environment: StoycoEnvironment.production,
///   firebaseAuth: FirebaseAuth.instance,
/// );
///
/// // Service automatically handles token refresh
/// final result = await service.getSubscriptionPlansByPartnerAndUser('partnerId');
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (response) => print('Plans: ${response.data.length}'),
/// );
/// ```
/// {@endtemplate}
class SubscriptionPlansService {
  /// Factory constructor for initializing the service.
  ///
  /// Automatically handles token retrieval and refresh from Firebase Auth.
  ///
  /// - [firebaseAuth]: Required Firebase Auth instance for authentication
  /// - [environment]: API environment (defaults to development)
  ///
  /// Example:
  /// ```dart
  /// final service = SubscriptionPlansService(
  ///   environment: StoycoEnvironment.production,
  ///   firebaseAuth: FirebaseAuth.instance,
  /// );
  /// ```
  factory SubscriptionPlansService({
    required FirebaseAuth firebaseAuth,
    StoycoEnvironment environment = StoycoEnvironment.development,
  }) {
    instance = SubscriptionPlansService._(
      firebaseAuth: firebaseAuth,
      environment: environment,
    );
    return instance;
  }

  /// Private constructor for singleton pattern.
  SubscriptionPlansService._({
    required this.firebaseAuth,
    this.environment = StoycoEnvironment.development,
  }) {
    _dataSource = SubscriptionPlansDataSource(environment: environment);
    _repository = SubscriptionPlansRepository(_dataSource, '');
  }

  /// Singleton instance of [SubscriptionPlansService].
  static late SubscriptionPlansService instance;

  /// The current environment (development, production, testing).
  final StoycoEnvironment environment;

  /// Firebase Auth instance for automatic token management.
  final FirebaseAuth firebaseAuth;

  late final SubscriptionPlansDataSource _dataSource;
  late final SubscriptionPlansRepository _repository;

  /// Gets the current user token from Firebase Auth.
  /// 
  /// Returns null if the user is not signed in or token retrieval fails,
  /// allowing the service to work without authentication.
  Future<String?> _getToken() async {
    try {
      final User? user = firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }
      final String? token = await user.getIdToken();
      return token;
    } catch (e) {
      // Return null if token retrieval fails
      return null;
    }
  }

  /// Updates the token in the data source and repository.
  /// 
  /// If token is null, updates with empty string to allow unauthenticated requests.
  Future<void> _updateTokenInLayers() async {
    final String? token = await _getToken();
    final String tokenValue = token ?? '';
    _repository.updateToken(tokenValue);
    _dataSource.updateToken(tokenValue);
  }

  /// Fetches subscription plans for a given partner and user.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// - [partnerId]: The MongoDB ObjectId of the partner
  ///
  /// Returns [Either] with [SubscriptionPlanResponse] on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.getSubscriptionPlansByPartnerAndUser('507f1f77bcf86cd799439012');
  /// ```
  Future<Either<Failure, SubscriptionPlanResponse>> getSubscriptionPlansByPartnerAndUser(String partnerId) async {
    try {
      await _updateTokenInLayers();
      return await _repository.getSubscriptionPlans(partnerId);
    } on DioException catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(ExceptionFailure.decode(error));
    }
  }

  /// Subscribes a user to a plan.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// Parameters:
  /// - [request]: The model containing user and plan information for subscription
  ///
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.subscribeToPlan(
  ///   SubscribeRequest(userId: '123', planId: 'abc'),
  /// );
  /// ```
  Future<Either<Failure, bool>> subscribeToPlan(SubscribeRequest request) async {
    try {
      await _updateTokenInLayers();
      return await _repository.subscribeToPlan(request);
    } on DioException catch (error) {
      return Left<Failure, bool>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, bool>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, bool>(ExceptionFailure.decode(error));
    }
  }

  /// Subscribes a user to a plan.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// Parameters:
  /// - [request]: The model containing user and plan information for subscription
  ///
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.subscribeToPlan(
  ///   SubscribeForAppRequest(userId: '123', planId: 'abc'),
  /// );
  /// ```
  Future<Either<Failure, bool>> subscribeToPlanApp(SubscribeForAppRequest request) async {
    try {
      await _updateTokenInLayers();
      return await _repository.subscribeToPlanApp(request);
    } on DioException catch (error) {
      return Left<Failure, bool>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, bool>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, bool>(ExceptionFailure.decode(error));
    }
  }

  /// Unsubscribes a user from a plan.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// Parameters:
  /// - [request]: The model containing user and plan information for unsubscription
  ///
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.unsubscribe(
  ///   SubscriptionModificationRequest(planId: 'abc'),
  /// );
  /// ```
  Future<Either<Failure, bool>> unsubscribe(SubscriptionModificationRequest request) async {
    try {
      await _updateTokenInLayers();
      return await _repository.unsubscribe(request);
    } on DioException catch (error) {
      return Left<Failure, bool>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, bool>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, bool>(ExceptionFailure.decode(error));
    }
  }

  /// Renews a user's subscription to a plan.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// Parameters:
  /// - [request]: The model containing user and plan information for renewal
  ///
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.renewSubscription(
  ///   SubscriptionModificationRequest(planId: 'abc'),
  /// );
  /// ```
  Future<Either<Failure, bool>> renewSubscription(SubscriptionModificationRequest request) async {
    try {
      await _updateTokenInLayers();
      return await _repository.renewSubscription(request);
    } on DioException catch (error) {
      return Left<Failure, bool>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, bool>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, bool>(ExceptionFailure.decode(error));
    }
  }

  /// Updates the payment method for a user's subscription.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// Parameters:
  /// - [request]: The model containing user, plan, and payment method information
  ///
  /// Returns: [Either] with [bool] on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.updateSubscriptionPaymentMethod(
  ///   SubscriptionMethodModificationRequest(userId: '123', planId: 'abc', paymentMethodId: 'pm_456'),
  /// );
  /// ```
  Future<Either<Failure, bool>> updateSubscriptionPaymentMethod(SubscriptionMethodModificationRequest request) async {
    try {
      await _updateTokenInLayers();
      return await _repository.updateSubscriptionPaymentMethod(request);
    } on DioException catch (error) {
      return Left<Failure, bool>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, bool>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, bool>(ExceptionFailure.decode(error));
    }
  }

  /// Creates a SetupIntent for managing payment methods.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// Returns: [Either] with [String] containing the client secret on success or [Failure] on error.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.createSetupIntent();
  /// ```
  Future<Either<Failure, String>> createSetupIntent() async {
    try {
      await _updateTokenInLayers();
      return await _repository.createSetupIntent();
    } on DioException catch (error) {
      return Left<Failure, String>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, String>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, String>(ExceptionFailure.decode(error));
    }
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/get_subscription_catalog_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/user_subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// {@template subscription_catalog_service}
/// Service class for managing subscription catalog operations with automatic Firebase Auth token management.
///
/// This singleton service provides methods to fetch user subscription plans
/// and catalog information. It automatically handles token retrieval and refresh from Firebase Auth.
///
/// **Token Management:**
/// - Automatically retrieves token from Firebase Auth before each request
/// - Refreshes token before making API calls
/// - No manual token management required
///
/// **Usage:**
/// ```dart
/// final service = SubscriptionCatalogService(
///   environment: StoycoEnvironment.production,
///   firebaseAuth: FirebaseAuth.instance,
/// );
///
/// // Service automatically handles token refresh
/// final result = await service.getUserSubscriptionPlans(
///   GetUserSubscriptionPlansRequest(userId: 'user_id'),
/// );
/// ```
/// {@endtemplate}
class SubscriptionCatalogService {
  /// Factory constructor for initializing the service.
  ///
  /// Automatically handles token retrieval and refresh from Firebase Auth.
  ///
  /// - [firebaseAuth]: Required Firebase Auth instance for authentication
  /// - [environment]: API environment (defaults to development)
  factory SubscriptionCatalogService({
    required FirebaseAuth firebaseAuth,
    StoycoEnvironment environment = StoycoEnvironment.development,
  }) {
    instance = SubscriptionCatalogService._(
      firebaseAuth: firebaseAuth,
      environment: environment,
    );
    return instance;
  }

  /// Private constructor for singleton pattern.
  SubscriptionCatalogService._({
    required this.firebaseAuth,
    this.environment = StoycoEnvironment.development,
  }) {
    _dataSource = SubscriptionCatalogDataSource(environment: environment);
    _repository = SubscriptionCatalogRepository(_dataSource);
  }

  /// Singleton instance of [SubscriptionCatalogService].
  static late SubscriptionCatalogService instance;

  /// The current environment (development, production, testing).
  final StoycoEnvironment environment;

  /// Firebase Auth instance for automatic token management.
  final FirebaseAuth firebaseAuth;

  late final SubscriptionCatalogDataSource _dataSource;
  late final SubscriptionCatalogRepository _repository;

  /// Gets the current user token from Firebase Auth.
  Future<String> _getToken() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in to Firebase');
    }
    final String? token = await user.getIdToken();
    if (token == null) {
      throw Exception('Failed to retrieve Firebase ID token');
    }
    return token;
  }

  /// Updates the token in the data source and repository.
  Future<void> _updateTokenInLayers() async {
    final String token = await _getToken();
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  /// Fetches the subscription plans for a specific user.
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  ///
  /// - [request]: Contains the user ID and filter parameters
  ///
  /// Returns [Either] with [UserSubscriptionPlanResponse] on success or [Failure] on error.
  Future<Either<Failure, UserSubscriptionPlanResponse>> getUserSubscriptionPlans(GetUserSubscriptionPlansRequest request) async {
    try {
      await _updateTokenInLayers();
      final UserSubscriptionPlanResponse response = await _repository.getUserSubscriptionPlans(request);
      return Right<Failure, UserSubscriptionPlanResponse>(response);
    } on DioException catch (error) {
      return Left<Failure, UserSubscriptionPlanResponse>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, UserSubscriptionPlanResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, UserSubscriptionPlanResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }

  /// Fetches the subscription catalog from the API, optionally filtered by [userId]
  /// and paginated using [page] and [pageSize].
  ///
  /// This is a public endpoint that doesn't require authentication.
  ///
  /// Returns [Either] with [GetSubscriptionCatalogResponse] on success or [Failure] on error.
  Future<Either<Failure, GetSubscriptionCatalogResponse>> getSubscriptionCatalog({String? userId, int? page, int? pageSize}) async {
    try {
      final GetSubscriptionCatalogResponse response = await _repository.getSubscriptionCatalog(
            userId: userId,
            page: page,
            pageSize: pageSize,
          );
      return Right<Failure, GetSubscriptionCatalogResponse>(response);
    } on DioException catch (error) {
      return Left<Failure, GetSubscriptionCatalogResponse>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, GetSubscriptionCatalogResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, GetSubscriptionCatalogResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }
}

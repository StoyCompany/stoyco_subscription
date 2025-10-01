import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
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
/// Service class for managing subscription catalog operations.
///
/// This singleton service provides methods to fetch user subscription plans
/// by interacting with the repository and data source layers. It manages
/// the user authentication token, environment configuration, and supports
/// automatic token refresh using a provided callback function.
///
/// Usage example:
/// ```dart
/// final service = SubscriptionCatalogService(
///   environment: StoycoEnvironment.production,
///   userToken: 'your_token',
///   functionToUpdateToken: () => getNewToken(),
/// );
///
/// final result = await service.getUserSubscriptionPlans(
///   GetUserSubscriptionPlansRequest(userId: 'user_id'),
/// );
/// ```
/// {@endtemplate}
class SubscriptionCatalogService {
  /// Factory for singleton initialization with custom environment, token and token update function.
  factory SubscriptionCatalogService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? Function()? functionToUpdateToken,
  }) {
    instance = SubscriptionCatalogService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    return instance;
  }

  /// Private constructor for singleton pattern.
  SubscriptionCatalogService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _dataSource = SubscriptionCatalogDataSource(environment: environment);
    _repository = SubscriptionCatalogRepository(_dataSource);
    _repository.updateToken(userToken);
    _dataSource.updateToken(userToken);
  }

  /// Singleton instance of [SubscriptionCatalogService].
  static SubscriptionCatalogService instance = SubscriptionCatalogService._();

  /// The user's authentication token.
  String userToken;

  /// The current environment (development, production, etc.).
  StoycoEnvironment environment;

  /// Optional function to update the user token if it becomes invalid.
  Future<String?>? Function()? functionToUpdateToken;

  late final SubscriptionCatalogDataSource _dataSource;
  late final SubscriptionCatalogRepository _repository;

  /// Updates the user token and propagates it to the repository and data source.
  void updateToken(String token) {
    userToken = token;
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  /// Sets the function to update the user token.
  void setFunctionToUpdateToken(Future<String?>? Function()? function) {
    functionToUpdateToken = function;
  }

  /// Verifies the user token and updates it if necessary using [functionToUpdateToken].
  ///
  /// Throws an [Exception] if the token cannot be updated.
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw Exception('functionToUpdateToken is not set');
      }
      final String? newToken = await functionToUpdateToken!();
      if (newToken != null && newToken.isNotEmpty) {
        updateToken(newToken);
      } else {
        throw Exception('Failed to update token');
      }
    }
  }

  /// Fetches the subscription plans for a specific user.
  ///
  /// Takes a [GetUserSubscriptionPlansRequest] containing the user ID.
  /// Returns an [Either] with [UserSubscriptionPlanResponse] on success or [Failure] on error.
  Future<Either<Failure, UserSubscriptionPlanResponse>>
  getUserSubscriptionPlans(GetUserSubscriptionPlansRequest request) async {
    try {
      await verifyToken();
      final UserSubscriptionPlanResponse response = await _repository
          .getUserSubscriptionPlans(request);
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
  /// Returns an [Either] with [GetSubscriptionCatalogResponse] on success or [Failure] on error.
  Future<Either<Failure, GetSubscriptionCatalogResponse>>
  getSubscriptionCatalog({String? userId, int? page, int? pageSize}) async {
    try {
      final GetSubscriptionCatalogResponse response = await _repository
          .getSubscriptionCatalog(
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

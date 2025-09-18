import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';
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
/// by interacting with the repository and data source layers.
/// {@endtemplate}
class SubscriptionCatalogService {
  /// Private constructor for singleton pattern.
  SubscriptionCatalogService._({this.userToken = ''}) {
    _dataSource = SubscriptionCatalogDataSource();
    _repository = SubscriptionCatalogRepository(_dataSource);
    _dataSource.updateToken(userToken);
  }

  /// The singleton instance of [SubscriptionCatalogService].
  static SubscriptionCatalogService instance = SubscriptionCatalogService._();

  /// Internal data source for subscription catalog operations.
  late final SubscriptionCatalogDataSource _dataSource;

  /// Internal repository for subscription catalog operations.
  late final SubscriptionCatalogRepository _repository;

  /// The user's authentication token.
  String userToken;

  /// Updates the user token and propagates it to the data source.
  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
  }

  /// Fetches the subscription plans for a specific user.
  ///
  /// Takes a [GetUserSubscriptionPlansRequest] containing the user ID.
  /// Returns [Either] with [UserSubscriptionPlanResponse] on success or [Failure] on error.
  Future<Either<Failure, UserSubscriptionPlanResponse>>
  getUserSubscriptionPlans(GetUserSubscriptionPlansRequest request) async {
    try {
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
}

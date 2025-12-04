import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/get_subscription_catalog_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/user_subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// {@template subscription_catalog_repository}
/// Repository class for managing subscription catalog data operations.
///
/// This class acts as an intermediary between the data source and the service layer,
/// providing methods to fetch user subscription plans and handle data mapping.
/// {@endtemplate}
class SubscriptionCatalogRepository {
  /// Creates a [SubscriptionCatalogRepository] with the given [SubscriptionCatalogDataSource].
  SubscriptionCatalogRepository(this._dataSource);

  /// The data source used to fetch subscription catalog data.
  final SubscriptionCatalogDataSource _dataSource;

  String userToken = '';

  /// Updates the authentication token used for data requests.
  ///
  /// This method allows the repository to update the token in the data source
  /// when it changes, ensuring that all requests use the latest token.
  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
  }

  /// Fetches user subscription plans.
  ///
  /// Returns a [UserSubscriptionPlanResponse] with the plans data.
  Future<Either<Failure, UserSubscriptionPlanResponse>> getUserSubscriptionPlans(
    GetUserSubscriptionPlansRequest request,
  ) async {
    try {
      final Response<Map<String, dynamic>> response = await _dataSource.getUserSubscriptionPlans(request);
      return Right<Failure, UserSubscriptionPlanResponse>(UserSubscriptionPlanResponse.fromJson(response.data!));
    } catch (e) {
      return Left<Failure, UserSubscriptionPlanResponse>(
        ExceptionFailure.decode(
          e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Fetches the general subscription catalog.
  ///
  /// Returns a [GetSubscriptionCatalogResponse] with the catalog data.
  Future<Either<Failure, GetSubscriptionCatalogResponse>> getSubscriptionCatalog({
    int? page,
    int? pageSize,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _dataSource.getSubscriptionCatalog(
        page: page,
        pageSize: pageSize,
      );
      return  Right<Failure, GetSubscriptionCatalogResponse>(GetSubscriptionCatalogResponse.fromJson(response.data!));
    } catch (e) {
      return Left<Failure, GetSubscriptionCatalogResponse>(
        ExceptionFailure.decode(
          e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }
}

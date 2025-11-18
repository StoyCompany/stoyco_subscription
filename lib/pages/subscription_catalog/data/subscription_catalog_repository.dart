import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/get_subscription_catalog_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/user_subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_data_source.dart';

/// {@template subscription_catalog_repository}
/// Repository class for managing subscription catalog data operations.
///
/// This class acts as an intermediary between the data source and the service layer,
/// providing methods to fetch user subscription plans and handle data mapping.
/// {@endtemplate}
class SubscriptionCatalogRepository with RepositoryCacheMixin {
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
    // Clear cache when token changes (user might have logged in/out)
    clearAllCache();
  }

  /// Fetches user subscription plans.
  ///
  /// Returns a [UserSubscriptionPlanResponse] with the plans data.
  /// Results are cached for 4 minutes.
  Future<UserSubscriptionPlanResponse> getUserSubscriptionPlans(
    GetUserSubscriptionPlansRequest request,
  ) async {
    final result = await cachedCall<UserSubscriptionPlanResponse>(
      key: 'user_subscription_plans_${request.userId}',
      ttl: const Duration(minutes: 4),
      fetcher: () async {
        try {
          final Response<Map<String, dynamic>> response = await _dataSource
              .getUserSubscriptionPlans(request);
          return Right(UserSubscriptionPlanResponse.fromJson(response.data!));
        } catch (e) {
          return Left(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((l) => throw Exception(l.message), (r) => r);
  }

  /// Fetches the general subscription catalog.
  ///
  /// Returns a [GetSubscriptionCatalogResponse] with the catalog data.
  /// Results are cached for 5 minutes as catalog data changes infrequently.
  Future<GetSubscriptionCatalogResponse> getSubscriptionCatalog({
    String? userId,
    int? page,
    int? pageSize,
  }) async {
    final cacheKey =
        'subscription_catalog_${userId ?? "all"}_${page ?? 1}_${pageSize ?? 10}';
    final result = await cachedCall<GetSubscriptionCatalogResponse>(
      key: cacheKey,
      ttl: const Duration(minutes: 5),
      fetcher: () async {
        try {
          final Response<Map<String, dynamic>> response = await _dataSource
              .getSubscriptionCatalog(
                userId: userId,
                page: page,
                pageSize: pageSize,
              );
          return Right(GetSubscriptionCatalogResponse.fromJson(response.data!));
        } catch (e) {
          return Left(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((l) => throw Exception(l.message), (r) => r);
  }
}

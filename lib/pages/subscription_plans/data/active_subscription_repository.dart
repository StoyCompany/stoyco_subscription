import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/responses/active_user_plan_response.dart';

/// {@template active_subscription_repository}
/// Repository class for active subscription verification operations.
///
/// Acts as an intermediary between the service layer and the data source,
/// handling data transformation and error handling.
/// {@endtemplate}
class ActiveSubscriptionRepository with RepositoryCacheMixin {
  /// {@macro active_subscription_repository}
  ActiveSubscriptionRepository(this._dataSource);

  /// The data source for API communication.
  final ActiveSubscriptionDataSource _dataSource;

  /// Updates the authentication token in the data source.
  void updateToken(String token) {
    _dataSource.updateToken(token);
    // Clear cache when token changes (user might have logged in/out)
    clearAllCache();
  }

  /// Fetches active subscription plans for the authenticated user.
  ///
  /// Returns an [ActiveUserPlanResponse] containing the list of active
  /// subscriptions for the user.
  /// Results are cached for 3 minutes to balance freshness and performance.
  ///
  /// Throws [DioException] if the API request fails.
  Future<ActiveUserPlanResponse> getActiveUserSubscriptions() async {
    final Either<Failure, ActiveUserPlanResponse> result = await cachedCall<ActiveUserPlanResponse>(
      key: 'active_user_subscriptions',
      ttl: const Duration(minutes: 3),
      fetcher: () async {
        try {
          final Response<Map<String, dynamic>> response = await _dataSource
              .getActiveUserSubscriptions();

          if (response.data == null) {
            throw DioException(
              requestOptions: response.requestOptions,
              message: 'Response data is null',
            );
          }
          return Right<Failure, ActiveUserPlanResponse>(ActiveUserPlanResponse.fromJson(response.data!));
        } catch (e) {
          return Left<Failure, ActiveUserPlanResponse>(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((Failure l) => throw Exception(l.message), (ActiveUserPlanResponse r) => r);
  }
}

import 'package:dio/dio.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/responses/active_user_plan_response.dart';

/// {@template active_subscription_repository}
/// Repository class for active subscription verification operations.
///
/// Acts as an intermediary between the service layer and the data source,
/// handling data transformation and error handling.
/// {@endtemplate}
class ActiveSubscriptionRepository {
  /// {@macro active_subscription_repository}
  ActiveSubscriptionRepository(this._dataSource);

  /// The data source for API communication.
  final ActiveSubscriptionDataSource _dataSource;

  /// Updates the authentication token in the data source.
  void updateToken(String token) {
    _dataSource.updateToken(token);
  }

  /// Fetches active subscription plans for the authenticated user.
  ///
  /// Returns an [ActiveUserPlanResponse] containing the list of active
  /// subscriptions for the user.
  ///
  /// Throws [DioException] if the API request fails.
  Future<ActiveUserPlanResponse> getActiveUserSubscriptions() async {
    final Response<Map<String, dynamic>> response = await _dataSource
        .getActiveUserSubscriptions();

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Response data is null',
      );
    }

    return ActiveUserPlanResponse.fromJson(response.data!);
  }
}

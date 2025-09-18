import 'package:dio/dio.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';

/// {@template subscription_catalog_data_source}
/// Data source class for subscription catalog API operations.
///
/// Handles direct communication with the remote API to fetch user subscription plans.
/// {@endtemplate}
class SubscriptionCatalogDataSource {
  /// Creates a [SubscriptionCatalogDataSource] with a default [Dio] client.
  final Dio _dio = Dio();
  String _userToken = '';

  /// Updates the user token used for API requests.
  ///
  /// This should be called whenever the user logs in or the token is refreshed.
  void updateToken(String token) {
    _userToken = token;
  }

  Map<String, String> _getHeaders() => <String, String>{
    'Authorization': 'Bearer $_userToken',
  };

  /// Fetches the subscription plans for a specific user from the API.
  ///
  /// Takes a [GetUserSubscriptionPlansRequest] containing the user ID.
  /// Returns a [Response] with the raw JSON data from the API.
  Future<Response<Map<String, dynamic>>> getUserSubscriptionPlans(
    GetUserSubscriptionPlansRequest request,
  ) async {
    final String url =
        'https://qa.api.stoyco.io/api/stoyco/v1/subscriptions/plans/user/${request.userId}';
    return _dio.get(url, options: Options(headers: _getHeaders()));
  }
}

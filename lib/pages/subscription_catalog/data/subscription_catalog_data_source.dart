import 'package:dio/dio.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';

/// {@template subscription_catalog_data_source}
/// Data source class for subscription catalog API operations.
///
/// Handles direct communication with the remote API to fetch user subscription plans.
/// Manages the authentication token and environment configuration for API requests.
/// {@endtemplate}
class SubscriptionCatalogDataSource {
  /// {@macro subscription_catalog_data_source}
  SubscriptionCatalogDataSource({required this.environment});

  /// The current environment (development, production, etc.).
  final StoycoEnvironment environment;

  /// Dio HTTP client instance.
  final Dio _dio = Dio();

  /// The user's authentication token.
  String _userToken = '';

  /// Updates the authentication token used for API requests.
  void updateToken(String token) {
    _userToken = token;
  }

  /// Returns the headers for API requests, including the authorization token.
  Map<String, String> _getHeaders() => <String, String>{
    'Authorization': 'Bearer $_userToken',
    'accept': '*/*',
  };

  /// Fetches the subscription plans for a specific user from the API.
  ///
  /// Takes a [GetUserSubscriptionPlansRequest] containing the user ID.
  /// Returns a [Response] with the raw JSON data from the API.
  Future<Response<Map<String, dynamic>>> getUserSubscriptionPlans(
    GetUserSubscriptionPlansRequest request,
  ) async {
    final String url = '${environment.baseUrl()}subscriptions/plans/user/${request.userId}';
    return _dio.get(url, options: Options(headers: _getHeaders()));
  }

  Future<Response<Map<String, dynamic>>> getSubscriptionCatalog({
    int? page,
    int? pageSize,
  }) async {
    final String url = '${environment.baseUrl()}subscriptions/catalog';
    final Map<String, dynamic> queryParams = <String, dynamic>{};
    if (page != null) {
      queryParams['page'] = page;
    }
    if (pageSize != null) {
      queryParams['pageSize'] = pageSize;
    }
    return _dio.get(
      url,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      options: Options(headers: _getHeaders()),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:stoyco_subscription/envs/envs.dart';

/// {@template active_subscription_data_source}
/// Data source class for active subscription verification API operations.
///
/// Handles direct communication with the remote API to check if a user
/// has active subscriptions. Manages the authentication token and
/// environment configuration for API requests.
/// {@endtemplate}
class ActiveSubscriptionDataSource {
  /// {@macro active_subscription_data_source}
  ActiveSubscriptionDataSource({required this.environment});

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

  /// Fetches the active subscription plans for the authenticated user from the API.
  ///
  /// Returns a [Response] with the raw JSON data from the API containing
  /// all active subscriptions for the user.
  ///
  /// The endpoint used is: `/subscriptions/plans/user/active`
  Future<Response<Map<String, dynamic>>> getActiveUserSubscriptions() async {
    final String url =
        '${environment.baseUrl()}subscriptions/plans/user/active';
    return _dio.get(url, options: Options(headers: _getHeaders()));
  }

  /// Fetches the server time from the API for validation purposes.
  ///
  /// Returns a [Response] with the server time in multiple formats:
  /// - UTC DateTime
  /// - Unix timestamp
  /// - ISO 8601 format
  ///
  /// The endpoint used is: `/subscriptions/server-time`
  /// This endpoint does not require authentication.
  Future<Response<Map<String, dynamic>>> getServerTime() async {
    final String url = '${environment.baseUrl()}subscriptions/server-time';
    return _dio.get(url, options: Options(headers: <String, dynamic>{'accept': '*/*'}));
  }
}

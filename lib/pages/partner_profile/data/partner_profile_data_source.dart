import 'dart:async';

import 'package:dio/dio.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';

/// {@template partner_profile_data_source}
/// Data source for partner profile-related network operations.
///
/// This class manages API requests related to partner profiles, including
/// fetching the lowest price plan and checking if a user's subscription is active.
/// It uses Dio for HTTP requests and supports automatic token refresh via an
/// authentication interceptor. When a request fails with a 401 or 403 status code,
/// the interceptor attempts to refresh the token and retries the request once.
///
/// Example usage:
/// ```dart
/// final dataSource = PartnerProfileDataSource(
///   environment: StoycoEnvironment.production,
/// );
/// dataSource.setRefreshTokenCallback(() async => await refreshToken());
/// dataSource.updateToken('user-access-token');
/// final plan = await dataSource.getLowestPricePlanByPartner('partnerId');
/// ```
/// {@endtemplate}
class PartnerProfileDataSource {
  /// Creates a [PartnerProfileDataSource] with the given [environment] and optional [dio] client.
  ///
  /// Installs an interceptor that automatically refreshes the token and retries
  /// the request if a 401/403 response is received.
  PartnerProfileDataSource({required this.environment, Dio? dio})
    : _dio = dio ?? Dio() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          final RequestOptions requestOptions = e.requestOptions;

          // If unauthorized and not already retried, attempt to refresh token and retry once.
          if ((e.response?.statusCode == 401 ||
                  e.response?.statusCode == 403) &&
              _refreshToken != null &&
              requestOptions.extra['retried'] != true) {
            try {
              // Synchronize token refresh so only one refresh occurs at a time.
              _refreshingTokenFuture ??= _refreshToken!();
              final String? newToken = await _refreshingTokenFuture;
              _refreshingTokenFuture = null;

              if (newToken != null && newToken.isNotEmpty) {
                _userToken = newToken;
                _dio.options.headers['Authorization'] = 'Bearer $newToken';

                // Mark the request as retried to avoid infinite loops.
                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                requestOptions.extra['retried'] = true;

                try {
                  final Response<dynamic> response = await _dio.fetch(
                    requestOptions,
                  );
                  return handler.resolve(response);
                } catch (err) {
                  return handler.reject(err as DioException);
                }
              } else {
                // If refresh fails, clear the token and forward the error.
                _userToken = '';
                _dio.options.headers.remove('Authorization');
                return handler.next(e);
              }
            } catch (err) {
              _refreshingTokenFuture = null;
              _userToken = '';
              _dio.options.headers.remove('Authorization');
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// The environment configuration for API endpoints.
  final StoycoEnvironment environment;

  /// Dio HTTP client used for network requests.
  final Dio _dio;

  /// The current user access token.
  String _userToken = '';

  /// Callback to refresh the access token.
  Future<String?> Function()? _refreshToken;

  /// Future used to synchronize token refresh operations.
  Future<String?>? _refreshingTokenFuture;

  /// Updates the stored user token and sets the Authorization header.
  void updateToken(String token) {
    _userToken = token;
  }

  /// Returns the current headers for authenticated requests.
  Map<String, String> _getHeaders() {
    if (_userToken.isNotEmpty) {
      return <String, String>{'Authorization': 'Bearer $_userToken'};
    }
    return <String, String>{};
  }

  /// Fetches the lowest price subscription plan for the given [partnerId].
  ///
  /// Throws a [DioException] if the request fails.
  Future<LowestPricePlanResponseModel> getLowestPricePlanByPartner(
    String partnerId,
  ) async {
    final String url =
        '${environment.baseUrl()}subscriptions/lowestPricePlan/partner/$partnerId';
    final Map<String, String> headers = <String, String>{};
    if (_userToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_userToken';
    }
    final Response<Map<String, dynamic>> response = await _dio.get(
      url,
      options: Options(headers: headers),
    );
    return LowestPricePlanResponseModel.fromJson(response.data!);
  }

  /// Fetches the last active user subscription for the given [partnerId].
  ///
  /// Throws a [DioException] if the request fails.
  Future<SubscriptionIsActiveResponse> getLastUserPlanByPartner(
    String partnerId,
  ) async {
    final String url =
        '${environment.baseUrl()}subscriptions/plan-last-user/partner/$partnerId';
    final Map<String, String> headers = <String, String>{};
    if (_userToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_userToken';
    }
    final Response<Map<String, dynamic>> response = await _dio.get(
      url,
      options: Options(headers: headers),
    );
    return SubscriptionIsActiveResponse.fromJson(response.data!);
  }

  Future<GetCulturalAssetsResponse> getCulturalAssetsByCommunityOwner(
    String partnerId,
  ) async {
    final String url =
        '${environment.web3BaseUrl()}collection/community-owner-id/$partnerId';
    final Map<String, String> headers = _getHeaders();
    final Response<Map<String, dynamic>> response = await _dio.get(
      url,
      options: Options(headers: headers),
    );
    return GetCulturalAssetsResponse.fromJson(response.data!);
  }
}

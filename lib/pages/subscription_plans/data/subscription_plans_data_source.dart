import 'package:dio/dio.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_for_app_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_method_modification_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_modification_request.dart';

class SubscriptionPlansDataSource{

  SubscriptionPlansDataSource({
    required StoycoEnvironment environment,
  }) : _environment = environment;

  /// The current environment.
  final StoycoEnvironment _environment;

  /// The Dio instance used for making network requests
  final Dio _dio = Dio();

  /// The user's authentication token
  late String _userToken;

  /// Updates the user token.
  void updateToken(String value) {
    _userToken = value;
  }

  /// Gets the headers for authenticated requests, including the Authorization header
  Map<String, String> _getHeadersOpcionalAuth() {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (_userToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_userToken';
    }
    return headers;
  }

  Map<String, String> _getHeaders() => <String, String>{
    'Authorization': 'Bearer $_userToken',
    'Content-Type': 'application/json',
  };

  Future<Response<Map<String, dynamic>>> getSubscriptionPlans(String partnerId) async {
    final String url = '${_environment.baseUrl()}subscriptions/plans/partner/$partnerId';
    return _dio.get(
      url,
      options: Options(headers: _getHeadersOpcionalAuth()),
    );
  }

  Future<Response<String>> subscribeToPlan(SubscribeRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/subscribe';
    return _dio.post(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<String>> subscribeToPlanApp(SubscribeForAppRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/subscribe-app';
    return _dio.post(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<String>> unsubscribe(SubscriptionModificationRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/unsubscribe';
    return _dio.post(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }
  
  Future<Response<String>> renewSubscription(SubscriptionModificationRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/subscription/renew';
    return _dio.post(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<String>> updateSubscriptionPaymentMethod(SubscriptionMethodModificationRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/subscription/payment-method';
    return _dio.put(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<Map<String, dynamic>>> createSetupIntent() async {
    final String url = '${_environment.baseUrl()}user-plans/setup-intent';
    return _dio.post(
      url,
      options: Options(headers: _getHeaders()),
    );
  }
}

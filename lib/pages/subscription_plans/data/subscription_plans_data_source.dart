import 'package:dio/dio.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_method_modification_request.dart';

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
  Map<String, String> _getHeaders() => <String, String>{
    'Authorization': 'Bearer $_userToken',
    'Content-Type': 'application/json',
  };

  Future<Response<Map<String, dynamic>>> getSubscriptionPlans(GetSubscriptionPlansRequest request) async {
    final String url = '${_environment.baseUrl()}subscriptions/plans/partner/${request.idPartner}';
    return _dio.get(
      url,
      queryParameters: <String, dynamic>{
        'userId': request.idUser,
      },
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<Map<String, dynamic>>> subscribeToPlan(SubscribeRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/subscribe';
    return _dio.post(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<Map<String, dynamic>>> unsubscribe(String planId) async {
    final String url = '${_environment.baseUrl()}user-plans/unsubscribe';
    return _dio.post(
      url,
      data: <String, String>{
        'planId': planId,
      },
      options: Options(headers: _getHeaders()),
    );
  }
  
  Future<Response<Map<String, dynamic>>> renewSubscription(String planId) async {
    final String url = '${_environment.baseUrl()}user-plans/subscription/$planId/renew';
    return _dio.post(
      url,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response<Map<String, dynamic>>> updateSubscriptionPaymentMethod(SubscriptionMethodModificationRequest request) async {
    final String url = '${_environment.baseUrl()}user-plans/subscription/payment-method';
    return _dio.put(
      url,
      data: request.toJson(),
      options: Options(headers: _getHeaders()),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';

class PartnerProfileDataSource {
  PartnerProfileDataSource({required this.environment});

  final StoycoEnvironment environment;

  final Dio _dio = Dio();

  String _userToken = '';

  void updateToken(String token) {
    _userToken = token;
  }

  Map<String, String> _getHeaders() => <String, String>{
    'Authorization': 'Bearer $_userToken',
  };

  Future<LowestPricePlanResponseModel> getLowestPricePlanByPartner(
    String partnerId,
  ) async {
    final String url =
        '${environment.baseUrl()}subscriptions/lowestPricePlan/partner/$partnerId';
    final Response<Map<String, dynamic>> response = await _dio.get(
      url,
      options: Options(headers: _getHeaders()),
    );
    return LowestPricePlanResponseModel.fromJson(response.data!);
  }

  Future<SubscriptionIsActiveResponse> getLastUserPlanByPartner(
    String partnerId,
  ) async {
    final String url =
        '${environment.baseUrl()}subscriptions/plan-last-user/partner/$partnerId';
    final Response<Map<String, dynamic>> response = await _dio.get(
      url,
      options: Options(headers: _getHeaders()),
    );
    return SubscriptionIsActiveResponse.fromJson(response.data!);
  }
}

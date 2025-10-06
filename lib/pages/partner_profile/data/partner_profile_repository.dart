import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';

class PartnerProfileRepository {
  PartnerProfileRepository(this._dataSource, this.userToken);

  final PartnerProfileDataSource _dataSource;

  /// The user's authentication token.
  late String userToken;

  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
  }

  Future<LowestPricePlanResponseModel> getLowestPricePlanByPartner({
    required String partnerId,
  }) async {
    return _dataSource.getLowestPricePlanByPartner(partnerId);
  }

  Future<SubscriptionIsActiveResponse> getLastUserPlanByPartner({
    required String partnerId,
  }) {
    return _dataSource.getLastUserPlanByPartner(partnerId);
  }
}

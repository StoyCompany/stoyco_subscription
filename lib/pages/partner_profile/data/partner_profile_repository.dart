import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';

/// Repository class for partner profile-related operations.
///
/// This repository acts as an abstraction layer between the data source and the service,
/// providing methods to fetch partner subscription data and manage the user's authentication token.
class PartnerProfileRepository {
  /// Creates a [PartnerProfileRepository] with the given [PartnerProfileDataSource] and [userToken].
  PartnerProfileRepository(this._dataSource, this.userToken);

  /// The data source used for network operations.
  final PartnerProfileDataSource _dataSource;

  /// The user's authentication token.
  late String userToken;

  /// Updates the stored authentication token and propagates it to the data source.
  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
  }

  /// Fetches the lowest price subscription plan for the given [partnerId].
  ///
  /// Returns a [LowestPricePlanResponseModel] with the plan details.
  Future<LowestPricePlanResponseModel> getLowestPricePlanByPartner({
    required String partnerId,
  }) async {
    return _dataSource.getLowestPricePlanByPartner(partnerId);
  }

  /// Fetches the last active user subscription for the given [partnerId].
  ///
  /// Returns a [SubscriptionIsActiveResponse] with the subscription details.
  Future<SubscriptionIsActiveResponse> getLastUserPlanByPartner({
    required String partnerId,
  }) {
    return _dataSource.getLastUserPlanByPartner(partnerId);
  }

  Future<GetCulturalAssetsResponse> getCulturalAssetsByCommunityOwner({
    required String partnerId,
  }) async {
    return _dataSource.getCulturalAssetsByCommunityOwner(partnerId);
  }
}

import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';

/// Repository class for partner profile-related operations.
///
/// This repository acts as an abstraction layer between the data source and the service,
/// providing methods to fetch partner subscription data and manage the user's authentication token.
class PartnerProfileRepository with RepositoryCacheMixin {
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
    // Clear cache when token changes (user might have logged in/out)
    clearAllCache();
  }

  /// Fetches the lowest price subscription plan for the given [partnerId].
  ///
  /// Returns a [LowestPricePlanResponseModel] with the plan details.
  /// Results are cached for 10 minutes.
  Future<LowestPricePlanResponseModel> getLowestPricePlanByPartner({
    required String partnerId,
  }) async {
    final result = await cachedCall<LowestPricePlanResponseModel>(
      key: 'lowest_price_plan_$partnerId',
      ttl: const Duration(minutes: 10),
      fetcher: () async {
        try {
          final data = await _dataSource.getLowestPricePlanByPartner(partnerId);
          return Right(data);
        } catch (e) {
          return Left(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((l) => throw Exception(l.message), (r) => r);
  }

  /// Fetches the last active user subscription for the given [partnerId].
  ///
  /// Returns a [SubscriptionIsActiveResponse] with the subscription details.
  /// Results are cached for 5 minutes.
  Future<SubscriptionIsActiveResponse> getLastUserPlanByPartner({
    required String partnerId,
  }) async {
    final result = await cachedCall<SubscriptionIsActiveResponse>(
      key: 'last_user_plan_$partnerId',
      ttl: const Duration(minutes: 5),
      fetcher: () async {
        try {
          final data = await _dataSource.getLastUserPlanByPartner(partnerId);
          return Right(data);
        } catch (e) {
          return Left(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((l) => throw Exception(l.message), (r) => r);
  }

  /// Fetches cultural assets for the given [partnerId].
  ///
  /// Returns a [GetCulturalAssetsResponse] with the cultural assets details.
  /// Results are cached for 15 minutes as this data changes infrequently.
  Future<GetCulturalAssetsResponse> getCulturalAssetsByCommunityOwner({
    required String partnerId,
  }) async {
    final result = await cachedCall<GetCulturalAssetsResponse>(
      key: 'cultural_assets_$partnerId',
      ttl: const Duration(minutes: 15),
      fetcher: () async {
        try {
          final data = await _dataSource.getCulturalAssetsByCommunityOwner(
            partnerId,
          );
          return Right(data);
        } catch (e) {
          return Left(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((l) => throw Exception(l.message), (r) => r);
  }
}

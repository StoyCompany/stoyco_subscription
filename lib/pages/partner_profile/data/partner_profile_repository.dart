import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/mixins/content_access_validator_mixin.dart';

/// Repository class for partner profile-related operations.
///
/// This repository acts as an abstraction layer between the data source and the service,
/// providing methods to fetch partner subscription data and manage the user's authentication token.
class PartnerProfileRepository with RepositoryCacheMixin, MultiContentAccessValidatorMixin {
  /// Creates a [PartnerProfileRepository] with the given [PartnerProfileDataSource] and [userToken].
  PartnerProfileRepository({
    required PartnerProfileDataSource dataSource, 
    required ActiveSubscriptionService activeSubscriptionService,
    String? userToken
  }): _dataSource = dataSource,
      _activeSubscriptionService = activeSubscriptionService,
      userToken = userToken ?? '';

  /// The data source used for network operations.
  final PartnerProfileDataSource _dataSource;
  final ActiveSubscriptionService _activeSubscriptionService;

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
    
    final Either<Failure, LowestPricePlanResponseModel> result = await cachedCall<LowestPricePlanResponseModel>(
      key: 'lowest_price_plan_$partnerId',
      ttl: const Duration(minutes: 10),
      fetcher: () async {
        try {
          final LowestPricePlanResponseModel data = await _dataSource.getLowestPricePlanByPartner(partnerId);
          return Right<Failure, LowestPricePlanResponseModel>(data);
        } catch (e) {
          return Left<Failure, LowestPricePlanResponseModel>(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((Failure l) => throw Exception(l.message), (LowestPricePlanResponseModel r) => r);
  }

  /// Fetches the last active user subscription for the given [partnerId].
  ///
  /// Returns a [SubscriptionIsActiveResponse] with the subscription details.
  /// Results are cached for 5 minutes.
  Future<SubscriptionIsActiveResponse> getLastUserPlanByPartner({
    required String partnerId,
  }) async {
    final Either<Failure, SubscriptionIsActiveResponse> result = await cachedCall<SubscriptionIsActiveResponse>(
      key: 'last_user_plan_$partnerId',
      ttl: const Duration(minutes: 5),
      fetcher: () async {
        try {
          final SubscriptionIsActiveResponse data = await _dataSource.getLastUserPlanByPartner(partnerId);
          return Right<Failure, SubscriptionIsActiveResponse>(data);
        } catch (e) {
          return Left<Failure, SubscriptionIsActiveResponse>(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((Failure l) => throw Exception(l.message), (SubscriptionIsActiveResponse r) => r);
  }

  /// Fetches cultural assets for the given [partnerId].
  ///
  /// Returns a [GetCulturalAssetsResponse] with the cultural assets details.
  /// Results are cached for 15 minutes as this data changes infrequently.
  Future<GetCulturalAssetsResponse> getCulturalAssetsByCommunityOwner({
    required String partnerId,
  }) async {
    final Either<Failure, GetCulturalAssetsResponse> result = await cachedCall<GetCulturalAssetsResponse>(
      key: 'cultural_assets_$partnerId',
      ttl: const Duration(minutes: 15),
      fetcher: () async {
        try {
          final GetCulturalAssetsResponse data = await _dataSource.getCulturalAssetsByCommunityOwner(
            partnerId,
          );
          data.copyWith(
            data: await  validateMultipleAccess<CulturalAssetItemModel>(
              service: _activeSubscriptionService,
              contents: data.data ?? <CulturalAssetItemModel>[],
              getAccessContent: (CulturalAssetItemModel item) => item.accessContent,
              hasAccessToContent: (CulturalAssetItemModel item, bool hasAccess) => item.copyWith(hasAccessWithSubscription: hasAccess),
              getIsSubscriptionOnly: (CulturalAssetItemModel item) => item.isSubscriberOnly,
            ),
          );
          return Right<Failure, GetCulturalAssetsResponse>(data);
        } catch (e) {
          return Left<Failure, GetCulturalAssetsResponse>(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((Failure l) => throw Exception(l.message), (GetCulturalAssetsResponse r) => r);
  }
}

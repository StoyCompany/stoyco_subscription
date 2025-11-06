import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// {@template partner_profile_service}
/// Service class for managing partner profile-related operations.
///
/// This service handles authentication token management, token refresh logic,
/// and provides methods to fetch partner subscription data. It coordinates
/// between the data source and repository layers, ensuring that API requests
/// are authenticated and that tokens are refreshed as needed.
///
/// Example usage:
/// ```dart
/// await injectPartnerProfileService();
/// final result = await PartnerProfileService.instance.getLowestPricePlanByPartner('partnerId');
/// ```
/// {@endtemplate}
class PartnerProfileService {
  /// Factory constructor for [PartnerProfileService].
  ///
  /// [environment] specifies the API environment.
  /// [userToken] is the initial authentication token.
  /// [functionToUpdateToken] is a callback to refresh the token when needed.
  factory PartnerProfileService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?> Function()? functionToUpdateToken,
  }) {
    instance = PartnerProfileService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    return instance;
  }

  /// Internal constructor for [PartnerProfileService].
  PartnerProfileService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _dataSource = PartnerProfileDataSource(environment: environment);
    _repository = PartnerProfileRepository(_dataSource, userToken);
    _repository.updateToken(userToken);
    _dataSource.updateToken(userToken);
  }

  /// Singleton instance of the service.
  static PartnerProfileService instance = PartnerProfileService._();

  /// The current user authentication token.
  String userToken;

  /// The environment configuration for API endpoints.
  StoycoEnvironment environment;

  /// Callback function to refresh the authentication token.
  Future<String?> Function()? functionToUpdateToken;

  /// The data source for partner profile operations.
  late final PartnerProfileDataSource _dataSource;

  /// The repository for partner profile operations.
  late final PartnerProfileRepository _repository;

  /// Updates the stored token and propagates it to the repository and data source.
  void updateToken(String token) {
    userToken = token;
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  /// Sets the function used to update the token when missing.
  void setFunctionToUpdateToken(Future<String?> Function()? function) {
    functionToUpdateToken = function;
  }

  /// Ensures a valid token is available.
  ///
  /// If the token is empty, attempts to refresh it using [functionToUpdateToken].
  /// Throws [FunctionToUpdateTokenNotSetException] if the refresh function is not set,
  /// or [EmptyUserTokenException] if the token cannot be refreshed.
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }
      final String? newToken = await functionToUpdateToken!();
      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _repository.updateToken(newToken);
        _dataSource.updateToken(newToken);
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
  }

  /// Fetches the lowest price subscription plan for the given [partnerId].
  ///
  /// Returns an [Either] with [LowestPricePlanResponseModel] on success,
  /// or a [Failure] on error.
  Future<Either<Failure, LowestPricePlanResponseModel>>
  getLowestPricePlanByPartner(String partnerId) async {
    try {
      final LowestPricePlanResponseModel result = await _repository
          .getLowestPricePlanByPartner(partnerId: partnerId);
      return Right<Failure, LowestPricePlanResponseModel>(result);
    } on DioException catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(
        ExceptionFailure.decode(error),
      );
    }
  }

  /// Fetches the last active user subscription for the given [partnerId].
  ///
  /// Ensures a valid token before making the request.
  /// Returns an [Either] with [SubscriptionIsActiveResponse] on success,
  /// or a [Failure] on error.
  Future<Either<Failure, SubscriptionIsActiveResponse>>
  getLastUserPlanByPartner(String partnerId) async {
    try {
      await verifyToken();
      final SubscriptionIsActiveResponse result = await _repository
          .getLastUserPlanByPartner(partnerId: partnerId);
      return Right<Failure, SubscriptionIsActiveResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }

  Future<Either<Failure, GetCulturalAssetsResponse>>
  getCulturalAssetsByCommunityOwner(String partnerId) async {
    try {
      final GetCulturalAssetsResponse result = await _repository
          .getCulturalAssetsByCommunityOwner(partnerId: partnerId);
      return Right<Failure, GetCulturalAssetsResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, GetCulturalAssetsResponse>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, GetCulturalAssetsResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, GetCulturalAssetsResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }
}

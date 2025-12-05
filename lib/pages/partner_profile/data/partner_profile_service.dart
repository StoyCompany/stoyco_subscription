import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/get_cultural_assets_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/lowest_price_plan_response_model.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/models/response/subscription_is_active_response.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';
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

  /// Factory constructor for creating or accessing a singleton instance.
  ///
  /// Automatically handles token retrieval and refresh from Firebase Auth.
  ///
  /// - [firebaseAuth]: Required Firebase Auth instance for authentication
  /// - [environment]: API environment (required)
  /// - [activeSubscriptionService]: Required dependency for subscription checks
  factory PartnerProfileService({
    required FirebaseAuth firebaseAuth,
    required StoycoEnvironment environment,
    required ActiveSubscriptionService activeSubscriptionService,
  }) => _instance ??= PartnerProfileService._(
    firebaseAuth: firebaseAuth,
    environment: environment,
    activeSubscriptionService: activeSubscriptionService,
  );

  PartnerProfileService._({
    required this.firebaseAuth,
    required this.environment,
    required this.activeSubscriptionService,
  }) {
    _dataSource = PartnerProfileDataSource(environment: environment);
    _repository = PartnerProfileRepository(
      dataSource: _dataSource!,
      activeSubscriptionService: activeSubscriptionService,
      userToken: '',
    );
  }

  /// Singleton instance
  static PartnerProfileService? _instance;

  /// Getter for singleton instance
  static PartnerProfileService? get instance => _instance;

  /// Firebase Auth instance for automatic token management.
  final FirebaseAuth firebaseAuth;

  /// The environment configuration for API endpoints.
  final StoycoEnvironment environment;

  /// The active subscription service dependency
  final ActiveSubscriptionService activeSubscriptionService;

  /// The data source for partner profile operations.
  PartnerProfileDataSource? _dataSource;

  /// The repository for partner profile operations.
  PartnerProfileRepository? _repository;

  /// Gets the current user token from Firebase Auth.
  Future<String> _getToken() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in to Firebase');
    }
    final String? token = await user.getIdToken();
    if (token == null) {
      throw Exception('Failed to retrieve Firebase ID token');
    }
    return token;
  }

  /// Updates the token in the data source and repository.
  Future<void> _updateTokenInLayers() async {
    final String token = await _getToken();
    _repository?.updateToken(token);
    _dataSource?.updateToken(token);
  }

  /// Fetches the lowest price subscription plan for the given [partnerId].
  ///
  /// This is a public endpoint that doesn't require authentication.
  Future<Either<Failure, LowestPricePlanResponseModel>> getLowestPricePlanByPartner(String partnerId) async {
    try {
      final LowestPricePlanResponseModel result = await _repository!.getLowestPricePlanByPartner(partnerId: partnerId);
      return Right<Failure, LowestPricePlanResponseModel>(result);
    } on DioException catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, LowestPricePlanResponseModel>(ExceptionFailure.decode(error));
    }
  }


  /// Fetches the last active user subscription for the given [partnerId].
  ///
  /// Automatically refreshes Firebase Auth token before making the request.
  Future<Either<Failure, SubscriptionIsActiveResponse>> getLastUserPlanByPartner(String partnerId) async {
    try {
      await _updateTokenInLayers();
      final SubscriptionIsActiveResponse result = await _repository!.getLastUserPlanByPartner(partnerId: partnerId);
      return Right<Failure, SubscriptionIsActiveResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, SubscriptionIsActiveResponse>(ExceptionFailure.decode(error));
    }
  }


  Future<Either<Failure, GetCulturalAssetsResponse>> getCulturalAssetsByCommunityOwner(String partnerId) async {
    try {
      final GetCulturalAssetsResponse result = await _repository!.getCulturalAssetsByCommunityOwner(partnerId: partnerId);
      return Right<Failure, GetCulturalAssetsResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, GetCulturalAssetsResponse>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, GetCulturalAssetsResponse>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, GetCulturalAssetsResponse>(ExceptionFailure.decode(error));
    }
  }
}

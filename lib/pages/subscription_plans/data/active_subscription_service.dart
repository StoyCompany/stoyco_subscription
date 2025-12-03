import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/logger.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/server_time.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/responses/active_user_plan_response.dart';

/// {@template active_subscription_service}
/// Service class for managing active subscription verification operations with caching.
///
/// This singleton service provides methods to check if a user has active
/// subscriptions by interacting with the repository and data source layers.
/// It manages the user authentication automatically using Firebase Auth.
///
/// **Caching Strategy:**
/// - Stores subscription data in memory after first fetch
/// - Automatically refreshes cache after configured duration (default: 5 minutes)
/// - Can force refresh on demand
/// - Clears cache automatically on user logout
///
/// **Usage:**
/// ```dart
/// final service = ActiveSubscriptionService(
///   environment: StoycoEnvironment.testing,
///   firebaseAuth: FirebaseAuth.instance,
///   cacheDuration: Duration(minutes: 10), // Optional, defaults to 5 minutes
/// );
///
/// // First call fetches from API and caches
/// final result = await service.getActiveUserSubscriptions();
///
/// // Subsequent calls use cache if still valid
/// final cachedResult = await service.getActiveUserSubscriptions();
///
/// // Force refresh from API
/// final freshResult = await service.getActiveUserSubscriptions(forceRefresh: true);
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (response) {
///     if (response.count > 0) {
///       print('User has ${response.count} active subscription(s)');
///     } else {
///       print('User has no active subscriptions');
///     }
///   },
/// );
/// ```
/// {@endtemplate}
class ActiveSubscriptionService {
  /// Factory constructor for initializing the service.
  ///
  /// Automatically handles token retrieval and refresh from Firebase Auth.
  /// Sets up cache management and logout listener.
  ///
  /// - [firebaseAuth]: Required Firebase Auth instance for authentication
  /// - [environment]: API environment (defaults to development)
  /// - [cacheDuration]: How long to keep cache valid (defaults to 5 minutes)
  ///
  /// Example:
  /// ```dart
  /// final service = ActiveSubscriptionService(
  ///   environment: StoycoEnvironment.production,
  ///   firebaseAuth: FirebaseAuth.instance,
  ///   cacheDuration: Duration(minutes: 10),
  /// );
  /// ```
  factory ActiveSubscriptionService({
    required FirebaseAuth firebaseAuth,
    StoycoEnvironment environment = StoycoEnvironment.development,
    Duration cacheDuration = const Duration(minutes: 5),
  }) {
    instance = ActiveSubscriptionService._(
      firebaseAuth: firebaseAuth,
      environment: environment,
      cacheDuration: cacheDuration,
    );
    return instance;
  }

  /// Private constructor for singleton pattern.
  ActiveSubscriptionService._({
    required this.firebaseAuth,
    this.environment = StoycoEnvironment.development,
    this.cacheDuration = const Duration(minutes: 5),
  }) {
    _dataSource = ActiveSubscriptionDataSource(environment: environment);
    _repository = ActiveSubscriptionRepository(_dataSource);
    _setupAuthStateListener();
  }

  /// Singleton instance of [ActiveSubscriptionService].
  static late ActiveSubscriptionService instance;

  /// The current environment (development, production, testing).
  final StoycoEnvironment environment;

  /// Firebase Auth instance for automatic token management.
  final FirebaseAuth firebaseAuth;

  /// Duration for which cached data remains valid.
  final Duration cacheDuration;

  late final ActiveSubscriptionDataSource _dataSource;
  late final ActiveSubscriptionRepository _repository;

  /// Cached subscription response.
  ActiveUserPlanResponse? _cachedResponse;

  /// Timestamp of when the cache was last updated.
  DateTime? _lastCacheUpdate;

  /// Subscription to Firebase Auth state changes.
  StreamSubscription<User?>? _authStateSubscription;

  /// Sets up listener for Firebase Auth state changes to clear cache on logout.
  void _setupAuthStateListener() {
    _authStateSubscription = firebaseAuth.authStateChanges().listen((
      User? user,
    ) {
      if (user == null) {
        // User logged out, clear cache
        clearCache();
      }
    });
  }

  /// Clears the cached subscription data.
  ///
  /// This is useful when you want to force a fresh fetch from the API
  /// or when the user logs out.
  ///
  /// Example:
  /// ```dart
  /// service.clearCache();
  /// final freshData = await service.getActiveUserSubscriptions();
  /// ```
  void clearCache() {
    _cachedResponse = null;
    _lastCacheUpdate = null;
  }

  /// Checks if the current cache is still valid based on [cacheDuration].
  bool get _isCacheValid {
    if (_cachedResponse == null || _lastCacheUpdate == null) {
      return false;
    }
    final Duration timeSinceUpdate = DateTime.now().difference(
      _lastCacheUpdate!,
    );
    return timeSinceUpdate < cacheDuration;
  }

  /// Disposes resources, particularly the auth state subscription.
  void dispose() {
    _authStateSubscription?.cancel();
  }

  /// Handles silent push notification to refresh cache.
  ///
  /// Call this method when your app receives a silent push notification
  /// indicating that subscription data has changed on the server.
  ///
  /// This is useful for:
  /// - New subscription purchased
  /// - Subscription cancelled/expired
  /// - Plan changes or updates
  /// - Access permissions modified
  ///
  /// Example with Firebase Cloud Messaging:
  /// ```dart
  /// FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  ///   if (message.data['type'] == 'subscription_update') {
  ///     // Force refresh cache from server
  ///     await service.refreshCacheFromPush();
  ///   }
  /// });
  /// ```
  ///
  /// Example with background handler:
  /// ```dart
  /// FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  ///   if (message.data['type'] == 'subscription_update') {
  ///     final service = ActiveSubscriptionService.instance;
  ///     await service.refreshCacheFromPush();
  ///   }
  /// });
  /// ```
  Future<void> refreshCacheFromPush() async {
    try {
      // Clear old cache
      clearCache();

      // Fetch fresh data from API
      final Either<Failure, ActiveUserPlanResponse> result =
          await getActiveUserSubscriptions(forceRefresh: true);

      result.fold(
        (Failure failure) {
          // Log error but don't throw
          // Silent push should not crash the app
          StoyCoLogger.info(
            'Failed to refresh subscription cache from push: ${failure.message}',
          );
        },
        (ActiveUserPlanResponse response) {
          // Cache is already updated in getActiveUserSubscriptions
          StoyCoLogger.info(
            'Cache refreshed successfully from push notification',
          );
        },
      );
    } catch (e, stackTrace) {
      // Catch any unexpected errors
      StoyCoLogger.error(
        'Error refreshing cache from push: $e',
        stackTrace: stackTrace,
      );
    }
  }

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
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  /// Fetches the active subscription plans for the authenticated user.
  ///
  /// Returns an [Either] with [ActiveUserPlanResponse] on success or [Failure] on error.
  ///
  /// **Caching Behavior:**
  /// - Returns cached data if available and still valid (within [cacheDuration])
  /// - Fetches from API if cache is invalid or [forceRefresh] is true
  /// - Automatically updates cache after successful API fetch
  ///
  /// Parameters:
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// The response contains:
  /// - `count`: Number of active subscriptions
  /// - `data`: List of [ActiveUserPlan] objects with subscription details
  ///
  /// Example:
  /// ```dart
  /// // Use cache if available
  /// final result = await service.getActiveUserSubscriptions();
  ///
  /// // Force fresh data from API
  /// final freshResult = await service.getActiveUserSubscriptions(forceRefresh: true);
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (response) => print('Active subscriptions: ${response.count}'),
  /// );
  /// ```
  Future<Either<Failure, ActiveUserPlanResponse>> getActiveUserSubscriptions({
    bool forceRefresh = false,
  }) async {
    // Return cached data if valid and not forcing refresh
    if (!forceRefresh && _isCacheValid) {
      return Right<Failure, ActiveUserPlanResponse>(_cachedResponse!);
    }

    // Fetch fresh data from API
    try {
      await _updateTokenInLayers();
      final ActiveUserPlanResponse response = await _repository
          .getActiveUserSubscriptions();

      // Update cache
      _cachedResponse = response;
      _lastCacheUpdate = DateTime.now();

      return Right<Failure, ActiveUserPlanResponse>(response);
    } on DioException catch (error) {
      return Left<Failure, ActiveUserPlanResponse>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, ActiveUserPlanResponse>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, ActiveUserPlanResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }

  /// Fetches the server time from the API for validation purposes.
  ///
  /// Returns an [Either] with [ServerTime] on success or falls back to device time on error.
  ///
  /// **Fallback Behavior:**
  /// - If the API request fails for any reason (network error, server error, etc.),
  ///   the method will return the current device time instead of returning a [Failure].
  /// - This ensures that time-based validations can still proceed even when offline.
  ///
  /// **Warning:**
  /// - Device time can be manipulated by users, so use this fallback with caution
  ///   for critical validation scenarios.
  ///
  /// Example:
  /// ```dart
  /// final result = await service.getServerTime();
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'), // This should never happen due to fallback
  ///   (serverTime) {
  ///     print('UTC DateTime: ${serverTime.utcDateTime}');
  ///     print('Unix Timestamp: ${serverTime.unixTimestamp}');
  ///     print('ISO 8601: ${serverTime.iso8601}');
  ///   },
  /// );
  /// ```
  Future<ServerTime> getServerTime() async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dataSource.getServerTime();

      if (response.data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Response data is null',
        );
      }
      final ServerTime serverTime = ServerTime.fromJson(response.data!);
      return serverTime;
    } catch (e) {
      // Fallback to device time if server request fails
      StoyCoLogger.warning(
        'Failed to fetch server time, using device time as fallback: $e',
      );
      
      final DateTime deviceTime = DateTime.now().toUtc();
      final ServerTime fallbackTime = ServerTime(
        utcDateTime: deviceTime,
        unixTimestamp: deviceTime.millisecondsSinceEpoch ~/ 1000,
        iso8601: deviceTime.toIso8601String(),
      );
      
      return fallbackTime;
    }
  }

  /// Checks if the authenticated user has at least one active subscription.
  ///
  /// Returns an [Either] with a [bool] on success or [Failure] on error.
  /// - `true`: User has at least one active subscription
  /// - `false`: User has no active subscriptions
  ///
  /// This is a convenience method that wraps [getActiveUserSubscriptions]
  /// and returns a simple boolean result.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// Parameters:
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// Example:
  /// ```dart
  /// // Use cache if available
  /// final result = await service.hasActiveSubscription();
  ///
  /// // Force fresh check from API
  /// final freshResult = await service.hasActiveSubscription(forceRefresh: true);
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (hasSubscription) {
  ///     if (hasSubscription) {
  ///       print('User has active subscription');
  ///     } else {
  ///       print('User does not have active subscription');
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<Failure, bool>> hasActiveSubscription({
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) => Left<Failure, bool>(failure),
      (ActiveUserPlanResponse response) =>
          Right<Failure, bool>(response.count > 0 && response.data.isNotEmpty),
    );
  }

  /// Checks if the authenticated user has an active subscription for a specific partner.
  ///
  /// Returns an [Either] with a [bool] on success or [Failure] on error.
  /// - `true`: User has an active subscription for the specified partner
  /// - `false`: User does not have an active subscription for the partner
  ///
  /// This method filters the user's active subscriptions by partner ID.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// Parameters:
  /// - [partnerId]: The MongoDB ObjectId of the partner to check
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// Example:
  /// ```dart
  /// // Check if user has subscription for a specific partner
  /// final result = await service.hasActiveSubscriptionForPartner(
  ///   partnerId: '507f1f77bcf86cd799439012',
  /// );
  ///
  /// // Force fresh check from API
  /// final freshResult = await service.hasActiveSubscriptionForPartner(
  ///   partnerId: '507f1f77bcf86cd799439012',
  ///   forceRefresh: true,
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (hasSubscription) {
  ///     if (hasSubscription) {
  ///       print('✅ User has active subscription for this partner');
  ///     } else {
  ///       print('❌ User does not have subscription for this partner');
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<Failure, bool>> hasActiveSubscriptionForPartner({
    required String partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold((Failure failure) => Left<Failure, bool>(failure), (
      ActiveUserPlanResponse response,
    ) {
      // Filter subscriptions by partner ID
      final bool hasPartnerSubscription = response.data.any(
        (ActiveUserPlan plan) => plan.partnerId == partnerId && plan.isActive,
      );
      return Right<Failure, bool>(hasPartnerSubscription);
    });
  }

  /// Gets all active subscription plans for a specific partner.
  ///
  /// Returns an [Either] with a list of [ActiveUserPlan] on success or [Failure] on error.
  ///
  /// This method filters the user's active subscriptions by partner ID and returns
  /// the complete plan details.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// Parameters:
  /// - [partnerId]: The MongoDB ObjectId of the partner to filter by
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// Example:
  /// ```dart
  /// final result = await service.getActiveSubscriptionsForPartner(
  ///   partnerId: '507f1f77bcf86cd799439012',
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (subscriptions) {
  ///     if (subscriptions.isEmpty) {
  ///       print('No subscriptions for this partner');
  ///     } else {
  ///       for (final subscription in subscriptions) {
  ///         print('Plan: ${subscription.plan.name}');
  ///         print('Recurrence: ${subscription.recurrence}');
  ///         print('Active: ${subscription.isActive}');
  ///       }
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<Failure, List<ActiveUserPlan>>> getActiveSubscriptionsForPartner({
    required String partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result = await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) => Left<Failure, List<ActiveUserPlan>>(failure),
      (ActiveUserPlanResponse response) {
        // Filter subscriptions by partner ID and active status
        final List<ActiveUserPlan> partnerSubscriptions = response.data
            .where(
              (ActiveUserPlan plan) =>
                  plan.partnerId == partnerId && plan.isActive,
            )
            .toList();
        return Right<Failure, List<ActiveUserPlan>>(partnerSubscriptions);
      },
    );
  }

  /// Checks if the user has access to a specific content.
  ///
  /// Returns an [Either] with a [bool] on success or [Failure] on error.
  /// - `true`: User has access to the specified content
  /// - `false`: User does not have access to the content
  ///
  /// This method checks if any of the user's active subscriptions includes
  /// access to the content by matching the plan IDs from the user's subscriptions
  /// with the plan IDs specified in the [AccessContent] object.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// **Parameters:**
  /// - [content]: The [AccessContent] object containing content information and
  ///   authorized plan IDs
  /// - [partnerId]: Optional partner ID to restrict the search to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// **Example:**
  /// ```dart
  /// // Create an AccessContent object
  /// final eventContent = AccessContent(
  ///   contentId: 'event_123',
  ///   partnerId: '507f1f77bcf86cd799439012',
  ///   planIds: ['plan_1', 'plan_2', 'plan_3'],
  ///   visibleFrom: DateTime(2024, 1, 1),
  ///   visibleUntil: DateTime(2024, 12, 31),
  /// );
  ///
  /// // Check if user has access to this content
  /// final result = await service.hasAccessToContent(
  ///   content: eventContent,
  /// );
  ///
  /// // Check if user has access from a specific partner
  /// final partnerResult = await service.hasAccessToContent(
  ///   content: eventContent,
  ///   partnerId: '507f1f77bcf86cd799439012',
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (hasAccess) {
  ///     if (hasAccess) {
  ///       print('✅ User has access to this content');
  ///     } else {
  ///       print('❌ User does not have access to this content');
  ///     }
  ///   },
  /// );
  /// ```
  Future<bool> hasAccessToContent({
    required AccessContent? accessContent,
    required bool isSubscriptionOnly,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    StoyCoLogger.info(
      '[>>] [hasAccessToContent] Starting access validation',
      tag: 'ACCESS_CHECK',
    );
    StoyCoLogger.info(
      '[INFO] [hasAccessToContent] Parameters: isSubscriptionOnly=$isSubscriptionOnly, partnerId=$partnerId, forceRefresh=$forceRefresh',
      tag: 'ACCESS_CHECK',
    );
    StoyCoLogger.info(
      '[DATA] [hasAccessToContent] AccessContent: ${accessContent?.toJson()}',
      tag: 'ACCESS_CHECK',
    );

    // Public content - immediate access (no authentication required)
    if (!isSubscriptionOnly) {
      StoyCoLogger.info(
        '[OK] [hasAccessToContent] Content is PUBLIC - granting immediate access (no auth required)',
        tag: 'ACCESS_CHECK',
      );
      return true;
    }

    StoyCoLogger.info(
      '[LOCK] [hasAccessToContent] Content is SUBSCRIPTION-ONLY - validating access',
      tag: 'ACCESS_CHECK',
    );

    // Validate access_content dates BEFORE checking authentication
    // This allows content with invalid dates to become public even without login
    final ServerTime getServerTimeResult = await getServerTime();
    
    StoyCoLogger.info(
      '[TIME] [hasAccessToContent] Server time: ${getServerTimeResult.utcDateTime} (ISO: ${getServerTimeResult.iso8601})',
      tag: 'ACCESS_CHECK',
    );

    final bool isVisibleForSubscribers = accessContent?.isVisibleForSubscribers(
      currentDate: getServerTimeResult.utcDateTime,
    ) ?? true;

    StoyCoLogger.info(
      '[DATE] [hasAccessToContent] Date validation (isVisibleForSubscribers): $isVisibleForSubscribers',
      tag: 'ACCESS_CHECK',
    );
    
    if (accessContent != null) {
      StoyCoLogger.info(
        '[DATE] [hasAccessToContent] Visibility window: from=${accessContent.visibleFrom}, until=${accessContent.visibleUntil}',
        tag: 'ACCESS_CHECK',
      );
    }

    // If content is NOT in valid date range (future or expired), grant public access
    if (!isVisibleForSubscribers) {
      StoyCoLogger.info(
        '[OK] [hasAccessToContent] Content NOT in valid date range (future or expired) - granting public access (no auth required)',
        tag: 'ACCESS_CHECK',
      );
      return true;
    }

    StoyCoLogger.info(
      '[LOCK] [hasAccessToContent] Content IS in valid date range - checking authentication',
      tag: 'ACCESS_CHECK',
    );

    // Check if user is authenticated before proceeding with subscription validation
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      StoyCoLogger.warning(
        '[DENIED] [hasAccessToContent] User not authenticated - denying access to subscription-only content',
        tag: 'ACCESS_CHECK',
      );
      return false;
    }

    final Either<Failure, ActiveUserPlanResponse> result = await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return await result.fold(
      (Failure failure) async {
        StoyCoLogger.error(
          '[ERROR] [hasAccessToContent] Failed to fetch user subscriptions: ${failure.message}',
          tag: 'ACCESS_CHECK',
        );
        // On error, deny access to subscription-only content for safety
        return false;
      },
      (ActiveUserPlanResponse response) async {
        StoyCoLogger.info(
          '[STATS] [hasAccessToContent] User has ${response.count} active subscription(s)',
          tag: 'ACCESS_CHECK',
        );

        final Iterable<ActiveUserPlan> filteredSubscriptions = partnerId != null
            ? response.data.where(
                (ActiveUserPlan plan) => plan.partnerId == partnerId,
              )
            : response.data;

        StoyCoLogger.info(
          '[FILTER] [hasAccessToContent] After partner filter: ${filteredSubscriptions.length} subscription(s)',
          tag: 'ACCESS_CHECK',
        );

        final Set<String> userPlanIds = filteredSubscriptions.map((ActiveUserPlan plan) => plan.plan.id).toSet();
        
        StoyCoLogger.info(
          '[PLANS] [hasAccessToContent] User plan IDs: ${userPlanIds.toList()}',
          tag: 'ACCESS_CHECK',
        );

        // Validate AccessContent fields
        final bool hasValidAccessContent = accessContent != null;
        final bool hasContentId = accessContent?.contentId.isNotEmpty ?? false;
        final bool hasPartnerId = accessContent?.partnerId.isNotEmpty ?? false;
        final bool hasPlanIds = accessContent?.planIds.isNotEmpty ?? false;

        StoyCoLogger.info(
          '[CHECK] [hasAccessToContent] AccessContent validation: hasValidAccessContent=$hasValidAccessContent, hasContentId=$hasContentId, hasPartnerId=$hasPartnerId, hasPlanIds=$hasPlanIds',
          tag: 'ACCESS_CHECK',
        );

        if (accessContent != null && accessContent.planIds.isNotEmpty) {
          StoyCoLogger.info(
            '[PLANS] [hasAccessToContent] Required plan IDs: ${accessContent.planIds}',
            tag: 'ACCESS_CHECK',
          );
        }

        // Check all conditions
        final bool hasAccess = accessContent != null &&
          accessContent.contentId.isNotEmpty &&
          accessContent.partnerId.isNotEmpty &&
          accessContent.planIds.isNotEmpty &&
          accessContent.planIds.any(userPlanIds.contains);

        if (hasAccess) {
          StoyCoLogger.info(
            '[OK] [hasAccessToContent] ACCESS GRANTED - User has valid subscription plan',
            tag: 'ACCESS_CHECK',
          );
        } else {
          StoyCoLogger.warning(
            '[DENIED] [hasAccessToContent] ACCESS DENIED - User does not have required subscription plan',
            tag: 'ACCESS_CHECK',
          );
        }

        return hasAccess;
      },
    );
  }

  /// Checks user access for a generic list of models and returns them populated with access status.
  ///
  /// This method efficiently determines access for each item in [contents],
  /// populating the model with its access status based on subscription rules.
  ///
  /// **Access Logic:**
  /// - If [getIsSubscriptionOnly] returns `false`, user is granted immediate public access
  /// - If [getIsSubscriptionOnly] returns `true`, access is validated against:
  ///   - User's active subscription plan IDs
  ///   - Item's [AccessContent] (must have valid contentId, partnerId, and planIds)
  /// - The [hasAccessToContent] callback is used to return the model with its access field populated
  ///
  /// **Access Validation for Subscription-Only Content:**
  /// - Returns `false` if [AccessContent] is null
  /// - Returns `false` if contentId is null or empty
  /// - Returns `false` if partnerId is null or empty
  /// - Returns `false` if planIds is null or empty
  /// - Returns `true` if user has any of the required plan IDs
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// **Parameters:**
  /// - [contents]: List of models to check access for
  /// - [getAccessContent]: Function that returns the [AccessContent] for a given model
  /// - [hasAccessToContent]: Function that returns the model with its access field set
  /// - [getIsSubscriptionOnly]: Function that returns whether the model requires subscription-only access
  /// - [partnerId]: Optional partner filter for subscription validation
  /// - [forceRefresh]: If true, bypasses cache and fetches fresh data
  ///
  /// **Returns:**
  /// A list of models of type `T` with their access status populated.
  ///
  /// **Example:**
  /// ```dart
  /// // With Event model
  /// final events = await service.hasAccessToMultiplesContent<Event>(
  ///   contents: eventList,
  ///   getAccessContent: (event) => event.accessContent,
  ///   hasAccessToContent: (event, hasAccess) => event.copyWith(hasAccess: hasAccess),
  ///   getIsSubscriptionOnly: (event) => event.isSubscriptionOnly,
  /// );
  ///
  /// // With CulturalAsset model
  /// final assets = await service.hasAccessToMultiplesContent<CulturalAsset>(
  ///   contents: assetList,
  ///   getAccessContent: (asset) => asset.accessContent,
  ///   hasAccessToContent: (asset, hasAccess) => asset.copyWith(hasAccess: hasAccess),
  ///   getIsSubscriptionOnly: (asset) => asset.requiresSubscription,
  ///   partnerId: '507f1f77bcf86cd799439012',
  /// );
  ///
  /// // Process results
  /// for (final event in events) {
  ///   if (event.hasAccess) {
  ///     print('✅ ${event.title} - Accessible');
  ///   } else {
  ///     print('🔒 ${event.title} - Locked');
  ///   }
  /// }
  /// ```
  Future<List<T>> hasAccessToMultiplesContent<T>({
    required List<T> contents,
    required AccessContent? Function(T) getAccessContent,
    required T Function(T, bool) hasAccessToContent,
    required bool Function(T) getIsSubscriptionOnly,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    StoyCoLogger.info(
      '[>>] [hasAccessToMultiplesContent] Starting bulk access validation for ${contents.length} item(s)',
      tag: 'BULK_ACCESS_CHECK',
    );
    StoyCoLogger.info(
      '[INFO] [hasAccessToMultiplesContent] Parameters: partnerId=$partnerId, forceRefresh=$forceRefresh',
      tag: 'BULK_ACCESS_CHECK',
    );

    // Get server time FIRST to validate dates before checking authentication
    final ServerTime getServerTimeResult = await getServerTime();

    StoyCoLogger.info(
      '[TIME] [hasAccessToMultiplesContent] Server time: ${getServerTimeResult.utcDateTime} (ISO: ${getServerTimeResult.iso8601})',
      tag: 'BULK_ACCESS_CHECK',
    );

    // Check if user is authenticated
    final User? currentUser = firebaseAuth.currentUser;
    final bool isAuthenticated = currentUser != null;
    
    StoyCoLogger.info(
      '[AUTH] [hasAccessToMultiplesContent] User authentication status: ${isAuthenticated ? "authenticated" : "not authenticated"}',
      tag: 'BULK_ACCESS_CHECK',
    );

    // If user is not authenticated, validate dates and grant access based on visibility
    if (!isAuthenticated) {
      StoyCoLogger.warning(
        '[AUTH] [hasAccessToMultiplesContent] User not authenticated - validating content dates',
        tag: 'BULK_ACCESS_CHECK',
      );
      return _handleUnauthenticatedContents<T>(
        contents: contents,
        getAccessContent: getAccessContent,
        getIsSubscriptionOnly: getIsSubscriptionOnly,
        hasAccessToContent: hasAccessToContent,
        serverTime: getServerTimeResult,
      );
    }

    final Either<Failure, ActiveUserPlanResponse> result = await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) {
        StoyCoLogger.error(
          '[ERROR] [hasAccessToMultiplesContent] Failed to fetch user subscriptions: ${failure.message}',
          tag: 'BULK_ACCESS_CHECK',
        );
        return _handleErrorContents<T>(
          contents: contents,
          getAccessContent: getAccessContent,
          getIsSubscriptionOnly: getIsSubscriptionOnly,
          hasAccessToContent: hasAccessToContent,
          serverTime: getServerTimeResult,
        );
      },
      (ActiveUserPlanResponse response) {
        StoyCoLogger.info(
          '[STATS] [hasAccessToMultiplesContent] User has ${response.count} active subscription(s)',
          tag: 'BULK_ACCESS_CHECK',
        );

        final Iterable<ActiveUserPlan> filteredSubscriptions = partnerId != null
            ? response.data.where(
                (ActiveUserPlan plan) => plan.partnerId == partnerId,
              )
            : response.data;

        StoyCoLogger.info(
          '[FILTER] [hasAccessToMultiplesContent] After partner filter: ${filteredSubscriptions.length} subscription(s)',
          tag: 'BULK_ACCESS_CHECK',
        );

        final Set<String> userPlanIds = filteredSubscriptions
            .map((ActiveUserPlan plan) => plan.plan.id)
            .toSet();

        StoyCoLogger.info(
          '[PLANS] [hasAccessToMultiplesContent] User plan IDs: ${userPlanIds.toList()}',
          tag: 'BULK_ACCESS_CHECK',
        );

        int itemIndex = 0;
        int publicCount = 0;
        int grantedCount = 0;
        int deniedCount = 0;

        final List<T> result = contents.map((T item) {
          itemIndex++;
          final bool isSubscriptionOnly = getIsSubscriptionOnly(item);

          StoyCoLogger.info(
            '[ITEM] [hasAccessToMultiplesContent] Item #$itemIndex: isSubscriptionOnly=$isSubscriptionOnly',
            tag: 'BULK_ACCESS_CHECK',
          );

          // Public content - immediate access
          if (!isSubscriptionOnly) {
            publicCount++;
            StoyCoLogger.info(
              '[OK] [hasAccessToMultiplesContent] Item #$itemIndex: PUBLIC - granting access',
              tag: 'BULK_ACCESS_CHECK',
            );
            return hasAccessToContent(item, true);
          }

          // Subscription-only content - validate all conditions
          final AccessContent? accessContent = getAccessContent(item);

          StoyCoLogger.info(
            '[DATA] [hasAccessToMultiplesContent] Item #$itemIndex AccessContent: ${accessContent?.toJson()}',
            tag: 'BULK_ACCESS_CHECK',
          );

          final bool isVisibleForSubscribers = accessContent?.isVisibleForSubscribers(
            currentDate: getServerTimeResult.utcDateTime,
          ) ?? true;

          StoyCoLogger.info(
            '[DATE] [hasAccessToMultiplesContent] Item #$itemIndex: Date validation (isVisibleForSubscribers)=$isVisibleForSubscribers',
            tag: 'BULK_ACCESS_CHECK',
          );

          if (accessContent != null) {
            StoyCoLogger.info(
              '[DATE] [hasAccessToMultiplesContent] Item #$itemIndex: Visibility window: from=${accessContent.visibleFrom}, until=${accessContent.visibleUntil}',
              tag: 'BULK_ACCESS_CHECK',
            );
          }

          if (!isVisibleForSubscribers) {
            publicCount++;
            StoyCoLogger.info(
              '[OK] [hasAccessToMultiplesContent] Item #$itemIndex: NOT in valid date range (future or expired) - granting public access',
              tag: 'BULK_ACCESS_CHECK',
            );
            return hasAccessToContent(item, true);
          }

          // Validate AccessContent fields
          final bool hasValidAccessContent = accessContent != null;
          final bool hasContentId = accessContent?.contentId.isNotEmpty ?? false;
          final bool hasPartnerId = accessContent?.partnerId.isNotEmpty ?? false;
          final bool hasPlanIds = accessContent?.planIds.isNotEmpty ?? false;

          StoyCoLogger.info(
            '[CHECK] [hasAccessToMultiplesContent] Item #$itemIndex: Validation - hasValidAccessContent=$hasValidAccessContent, hasContentId=$hasContentId, hasPartnerId=$hasPartnerId, hasPlanIds=$hasPlanIds',
            tag: 'BULK_ACCESS_CHECK',
          );

          if (accessContent != null && accessContent.planIds.isNotEmpty) {
            StoyCoLogger.info(
              '[PLANS] [hasAccessToMultiplesContent] Item #$itemIndex: Required plan IDs: ${accessContent.planIds}',
              tag: 'BULK_ACCESS_CHECK',
            );
          }

          final bool hasAccess =
              accessContent != null &&
              accessContent.contentId.isNotEmpty &&
              accessContent.partnerId.isNotEmpty &&
              accessContent.planIds.isNotEmpty &&
              accessContent.planIds.any(userPlanIds.contains);

          if (hasAccess) {
            grantedCount++;
            StoyCoLogger.info(
              '[OK] [hasAccessToMultiplesContent] Item #$itemIndex: ACCESS GRANTED',
              tag: 'BULK_ACCESS_CHECK',
            );
          } else {
            deniedCount++;
            StoyCoLogger.warning(
              '[DENIED] [hasAccessToMultiplesContent] Item #$itemIndex: ACCESS DENIED',
              tag: 'BULK_ACCESS_CHECK',
            );
          }

          return hasAccessToContent(item, hasAccess);
        }).toList();

        StoyCoLogger.info(
          '[SUMMARY] [hasAccessToMultiplesContent] Summary: Total=$itemIndex, Public=$publicCount, Granted=$grantedCount, Denied=$deniedCount',
          tag: 'BULK_ACCESS_CHECK',
        );

        return result;
      },
    );
  }

  /// Returns contents with hasAccess set based on authentication status.
  ///
  /// This helper method is used when the user is not authenticated.
  /// It ensures that:
  /// - Public content ([getIsSubscriptionOnly] returns false) remains accessible
  /// - Subscription-only content with invalid dates (future or expired) becomes accessible
  /// - Subscription-only content with valid dates is marked as inaccessible
  ///
  /// **Parameters:**
  /// - [contents]: List of content items to process
  /// - [getAccessContent]: Function to get AccessContent from the model
  /// - [getIsSubscriptionOnly]: Function to determine if content requires subscription
  /// - [hasAccessToContent]: Function to update the model with access status
  /// - [serverTime]: Server time for date validation
  ///
  /// **Returns:**
  /// A list of models with access status set based on subscription requirement and date validation.
  List<T> _handleUnauthenticatedContents<T>({
    required List<T> contents,
    required AccessContent? Function(T) getAccessContent,
    required bool Function(T) getIsSubscriptionOnly,
    required T Function(T, bool) hasAccessToContent,
    required ServerTime serverTime,
  }) {
    int publicCount = 0;
    int dateBasedPublicCount = 0;
    int lockedCount = 0;

    final List<T> result = contents.map((T item) {
      final bool isSubscriptionOnly = getIsSubscriptionOnly(item);
      
      // Public content - always accessible
      if (!isSubscriptionOnly) {
        publicCount++;
        return hasAccessToContent(item, true);
      }

      // Subscription-only content - check dates
      final AccessContent? accessContent = getAccessContent(item);
      final bool isVisibleForSubscribers = accessContent?.isVisibleForSubscribers(
        currentDate: serverTime.utcDateTime,
      ) ?? true;

      // If content is NOT in valid date range (future or expired), grant public access
      if (!isVisibleForSubscribers) {
        dateBasedPublicCount++;
        StoyCoLogger.info(
          '[OK] [handleUnauthenticatedContents] Content with invalid dates - granting public access',
          tag: 'BULK_ACCESS_CHECK',
        );
        return hasAccessToContent(item, true);
      }

      // Content is subscription-only and in valid date range - deny access
      lockedCount++;
      return hasAccessToContent(item, false);
    }).toList();

    StoyCoLogger.info(
      '[SUMMARY] [handleUnauthenticatedContents] Result: Total=${contents.length}, Public=$publicCount, DateBasedPublic=$dateBasedPublicCount, Locked=$lockedCount',
      tag: 'BULK_ACCESS_CHECK',
    );

    return result;
  }

  /// Returns contents with hasAccess set to false for items where getIsSubscriptionOnly is true.
  ///
  /// This helper method is used when there's an error fetching subscription data.
  /// It ensures that:
  /// - Public content ([getIsSubscriptionOnly] returns false) remains accessible
  /// - Subscription-only content with invalid dates (future or expired) becomes accessible
  /// - Subscription-only content with valid dates is marked as inaccessible for safety
  ///
  /// **Parameters:**
  /// - [contents]: List of content items to process
  /// - [getAccessContent]: Function to get AccessContent from the model
  /// - [getIsSubscriptionOnly]: Function to determine if content requires subscription
  /// - [hasAccessToContent]: Function to update the model with access status
  /// - [serverTime]: Server time for date validation
  ///
  /// **Returns:**
  /// A list of models with access status set based on subscription requirement and date validation.
  List<T> _handleErrorContents<T>({
    required List<T> contents,
    required AccessContent? Function(T) getAccessContent,
    required bool Function(T) getIsSubscriptionOnly,
    required T Function(T, bool) hasAccessToContent,
    required ServerTime serverTime,
  }) => contents.map((T item) {
    final bool isSubscriptionOnly = getIsSubscriptionOnly(item);
    
    // Public content - always accessible
    if (!isSubscriptionOnly) {
      return hasAccessToContent(item, true);
    }

    // Subscription-only content - check dates
    final AccessContent? accessContent = getAccessContent(item);
    final bool isVisibleForSubscribers = accessContent?.isVisibleForSubscribers(
      currentDate: serverTime.utcDateTime,
    ) ?? true;

    // If content is NOT in valid date range (future or expired), grant public access
    if (!isVisibleForSubscribers) {
      return hasAccessToContent(item, true);
    }

    // Content is subscription-only and in valid date range - deny access for safety
    return hasAccessToContent(item, false);
  }).toList();

  /// Gets all available content accesses for the user.
  ///
  /// Returns an [Either] with a [Set<String>] on success or [Failure] on error.
  /// The set contains all unique content IDs the user has access to.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// Parameters:
  /// - [partnerId]: Optional partner ID to get accesses only from a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// Example:
  /// ```dart
  /// final result = await service.getAllUserAccesses();
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (accesses) {
  ///     print('User has access to: ${accesses.join(", ")}');
  ///   },
  /// );
  /// ```
  Future<Either<Failure, Set<String>>> getAllUserAccesses({
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result = await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) => Left<Failure, Set<String>>(failure),
      (ActiveUserPlanResponse response) {
        // Filter active subscriptions
        final Iterable<ActiveUserPlan> activeSubscriptions = response.data
            .where((ActiveUserPlan plan) => plan.isActive);

        // Apply partner filter if provided
        final Iterable<ActiveUserPlan> filteredSubscriptions = partnerId != null
            ? activeSubscriptions.where(
                (ActiveUserPlan plan) => plan.partnerId == partnerId,
              )
            : activeSubscriptions;

        // Collect all unique accesses
        final Set<String> allAccesses = <String>{};
        for (final ActiveUserPlan plan in filteredSubscriptions) {
          allAccesses.addAll(plan.plan.accesses);
        }

        return Right<Failure, Set<String>>(allAccesses);
      },
    );
  }
}

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
  Future<Either<Failure, List<ActiveUserPlan>>>
  getActiveSubscriptionsForPartner({
    required String partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

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
  /// the specified content access in their plan's accesses list.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// Parameters:
  /// - [contentId]: The content/access identifier to check (e.g., 'events', 'exclusive_content')
  /// - [partnerId]: Optional partner ID to restrict the search to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// Example:
  /// ```dart
  /// // Check if user has access to events content
  /// final result = await service.hasAccessToContent(
  ///   contentId: 'events',
  /// );
  ///
  /// // Check if user has access to events from a specific partner
  /// final partnerResult = await service.hasAccessToContent(
  ///   contentId: 'events',
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
  Future<Either<Failure, bool>> hasAccessToContent({
    required String contentId,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold((Failure failure) => Left<Failure, bool>(failure), (
      ActiveUserPlanResponse response,
    ) {
      // Filter active subscriptions
      final Iterable<ActiveUserPlan> activeSubscriptions = response.data.where(
        (ActiveUserPlan plan) => plan.isActive,
      );

      // Apply partner filter if provided
      final Iterable<ActiveUserPlan> filteredSubscriptions = partnerId != null
          ? activeSubscriptions.where(
              (ActiveUserPlan plan) => plan.partnerId == partnerId,
            )
          : activeSubscriptions;

      // Check if any subscription has access to the content
      final bool hasAccess = filteredSubscriptions.any(
        (ActiveUserPlan plan) => plan.plan.accesses.contains(contentId),
      );

      return Right<Failure, bool>(hasAccess);
    });
  }

  /// Checks user access to multiple contents at once.
  ///
  /// Returns an [Either] with a [Map<String, bool>] on success or [Failure] on error.
  /// The map keys are content IDs and values indicate whether the user has access.
  ///
  /// This method is more efficient than calling [hasAccessToContent] multiple times
  /// because it only fetches the subscriptions once.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// Parameters:
  /// - [contentIds]: List of content/access identifiers to check
  /// - [partnerId]: Optional partner ID to restrict the search to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// Example:
  /// ```dart
  /// final result = await service.checkMultipleContentAccess(
  ///   contentIds: ['events', 'exclusive_content', 'cultural_assets'],
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (accessMap) {
  ///     accessMap.forEach((contentId, hasAccess) {
  ///       print('$contentId: ${hasAccess ? "✅" : "❌"}');
  ///     });
  ///   },
  /// );
  ///
  /// // Example output:
  /// // events: ✅
  /// // exclusive_content: ✅
  /// // cultural_assets: ❌
  /// ```
  Future<Either<Failure, Map<String, bool>>> checkMultipleContentAccess({
    required List<String> contentIds,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) => Left<Failure, Map<String, bool>>(failure),
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

        // Collect all accesses from filtered subscriptions
        final Set<String> availableAccesses = <String>{};
        for (final ActiveUserPlan plan in filteredSubscriptions) {
          availableAccesses.addAll(plan.plan.accesses);
        }

        // Build result map
        final Map<String, bool> accessMap = <String, bool>{};
        for (final String contentId in contentIds) {
          accessMap[contentId] = availableAccesses.contains(contentId);
        }

        return Right<Failure, Map<String, bool>>(accessMap);
      },
    );
  }

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
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

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

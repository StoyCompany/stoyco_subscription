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
  Future<Either<Failure, bool>> hasAccessToContent({
    required AccessContent content,
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

      // Collect all plan IDs from filtered subscriptions
      final Set<String> userPlanIds = filteredSubscriptions
          .map((ActiveUserPlan plan) => plan.plan.id)
          .toSet();

      final bool hasAccess = content.planIds.any(userPlanIds.contains);

      return Right<Failure, bool>(hasAccess);
    });
  }

  /// Checks user access to multiple contents at once.
  ///
  /// Returns an [Either] with a [Map<AccessContent, bool>] on success or [Failure] on error.
  /// The map keys are [AccessContent] objects and values indicate whether the user has access.
  ///
  /// This method is more efficient than calling [hasAccessToContent] multiple times
  /// because it only fetches the subscriptions once and processes all content checks
  /// in a single operation.
  ///
  /// **Caching Behavior:**
  /// - Uses the same caching strategy as [getActiveUserSubscriptions]
  /// - Pass [forceRefresh] to bypass cache
  ///
  /// **Parameters:**
  /// - [contents]: List of [AccessContent] objects to check access for
  /// - [partnerId]: Optional partner ID to restrict the search to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh data from API
  ///
  /// **Example:**
  /// ```dart
  /// // Create multiple AccessContent objects
  /// final eventContent = AccessContent(
  ///   contentId: 'event_123',
  ///   partnerId: '507f1f77bcf86cd799439012',
  ///   planIds: ['plan_1', 'plan_2'],
  ///   visibleFrom: DateTime(2024, 1, 1),
  ///   visibleUntil: DateTime(2024, 12, 31),
  /// );
  ///
  /// final exclusiveContent = AccessContent(
  ///   contentId: 'exclusive_456',
  ///   partnerId: '507f1f77bcf86cd799439012',
  ///   planIds: ['plan_3', 'plan_4'],
  ///   visibleFrom: DateTime(2024, 1, 1),
  ///   visibleUntil: DateTime(2024, 12, 31),
  /// );
  ///
  /// final culturalAssetContent = AccessContent(
  ///   contentId: 'asset_789',
  ///   partnerId: '507f1f77bcf86cd799439012',
  ///   planIds: ['plan_5'],
  ///   visibleFrom: DateTime(2024, 1, 1),
  ///   visibleUntil: DateTime(2024, 12, 31),
  /// );
  ///
  /// // Check access to multiple contents
  /// final result = await service.checkMultipleContentAccess(
  ///   contents: [eventContent, exclusiveContent, culturalAssetContent],
  /// );
  ///
  /// // With partner filter
  /// final filteredResult = await service.checkMultipleContentAccess(
  ///   contents: [eventContent, exclusiveContent, culturalAssetContent],
  ///   partnerId: '507f1f77bcf86cd799439012',
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (accessMap) {
  ///     accessMap.forEach((content, hasAccess) {
  ///       print('${content.contentId}: ${hasAccess ? "✅" : "❌"}');
  ///     });
  ///   },
  /// );
  ///
  /// // Example output:
  /// // event_123: ✅
  /// // exclusive_456: ✅
  /// // asset_789: ❌
  /// ```
  Future<Either<Failure, Map<AccessContent, bool>>> checkMultipleContentAccess({
    required List<AccessContent> contents,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result =
        await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) => Left<Failure, Map<AccessContent, bool>>(failure),
      (ActiveUserPlanResponse response) {
        // Apply partner filter if provided
        final Iterable<ActiveUserPlan> filteredSubscriptions = partnerId != null
            ? response.data.where(
                (ActiveUserPlan plan) => plan.partnerId == partnerId,
              )
            : response.data;

        // Collect all accesses from filtered subscriptions
        final Set<String> userPlanIds = filteredSubscriptions
            .map((ActiveUserPlan plan) => plan.plan.id)
            .toSet();

        // Build result map
        final Map<AccessContent, bool> accessMap = <AccessContent, bool>{};
        for (final AccessContent content in contents) {
          accessMap[content] = content.planIds.any(userPlanIds.contains);
        }
        return Right<Failure, Map<AccessContent, bool>>(accessMap);
      },
    );
  }

  /// Checks user access for a generic list of models and returns them populated with access status.
  ///
  /// This method efficiently determines access for each item in [contents],
  /// populating the model with its access status based on subscription rules.
  ///
  /// - If [getIsSubscriptionOnly] returns `false`, the user is granted immediate public access.
  /// - If [getIsSubscriptionOnly] returns `true`, access is validated against the user's active subscription plan IDs and the item's [AccessContent].
  /// - The [hasAccessToContent] callback is used to return the model with its access field populated.
  ///
  /// ### Parameters
  /// - `contents`: List of models to check access for.
  /// - `getAccessContent`: Returns the [AccessContent] for a given model.
  /// - `hasAccessToContent`: Returns the model with its access field set.
  /// - `getIsSubscriptionOnly`: Returns whether the model requires subscription-only access.
  /// - `partnerId`: Optional partner filter for subscription validation.
  /// - `forceRefresh`: If true, bypasses cache and fetches fresh data.
  ///
  /// ### Returns
  /// An [Either] containing a list of models of type `T` with their access status populated, or a [Failure] on error.
  ///
  /// ### Example
  /// ```dart
  /// final result = await service.checkMultipleContentAccessGenerated<MyModel>(
  ///   contents: myModelList,
  ///   getAccessContent: (model) => model.accessContent,
  ///   hasAccessToContent: (model, hasAccess) => model.copyWith(hasAccess: hasAccess),
  ///   getIsSubscriptionOnly: (model) => model.isSubscriptionOnly,
  /// );
  /// ```
  Future<Either<Failure, List<T>>> checkMultipleContentAccessGenerated<T>({
    required List<T> contents,
    required AccessContent? Function(T) getAccessContent,
    required T Function(T, bool) hasAccessToContent,
    required bool Function(T) getIsSubscriptionOnly,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, ActiveUserPlanResponse> result = await getActiveUserSubscriptions(forceRefresh: forceRefresh);

    return result.fold(
      (Failure failure) => Left<Failure, List<T>>(failure),
      (ActiveUserPlanResponse response) {
        final Iterable<ActiveUserPlan> filteredSubscriptions = partnerId != null ? response.data.where((ActiveUserPlan plan) => plan.partnerId == partnerId) : response.data;

        final Set<String> userPlanIds = filteredSubscriptions.map((ActiveUserPlan plan) => plan.plan.id).toSet();

        final List<T> resultList = contents.map((T item) {
          final bool isSubscriptionOnly = getIsSubscriptionOnly(item);
          bool hasAccess;
          if (!isSubscriptionOnly) {
            hasAccess = true;
          } else {
            final AccessContent? content = getAccessContent(item);
            if (content == null) {
              hasAccess = false;
            } else {
              hasAccess = content.planIds.any(userPlanIds.contains);
            }
          }
          return hasAccessToContent(item, hasAccess);
        }).toList();

        return Right<Failure, List<T>>(resultList);
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

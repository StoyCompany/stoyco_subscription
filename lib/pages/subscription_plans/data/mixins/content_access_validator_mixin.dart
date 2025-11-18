import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';

/// {@template content_access_validator_mixin}
/// Mixin that provides content access validation capabilities using [ActiveSubscriptionService].
///
/// This mixin can be used with any class that has one or more [AccessContent] properties
/// to validate if the current user has access to that content based on their active subscriptions.
///
/// **Usage:**
/// ```dart
/// class Event with ContentAccessValidatorMixin {
///   final String id;
///   final String title;
///   final AccessContent accessControl;
///
///   Event({
///     required this.id,
///     required this.title,
///     required this.accessControl,
///   });
///
///   // Implement the abstract method
///   @override
///   AccessContent get contentAccess => accessControl;
///
///   // Now you can use the validation methods
///   Future<bool> canUserAccess() async {
///     final result = await validateAccess(
///       service: ActiveSubscriptionService.instance,
///     );
///     return result.fold((failure) => false, (hasAccess) => hasAccess);
///   }
/// }
/// ```
/// {@endtemplate}
mixin ContentAccessValidatorMixin {
  /// The [AccessContent] object that defines access rules for this content.
  ///
  /// This must be implemented by the class using this mixin.
  AccessContent get contentAccess;

  /// Validates if the current user has access to this content.
  ///
  /// Returns an [Either] with a [bool] on success or [Failure] on error.
  /// - `true`: User has access to this content
  /// - `false`: User does not have access to this content
  ///
  /// **Parameters:**
  /// - [service]: The [ActiveSubscriptionService] instance to use for validation
  /// - [partnerId]: Optional partner ID to restrict validation to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh subscription data
  ///
  /// Example:
  /// ```dart
  /// class MyContent with ContentAccessValidatorMixin {
  ///   final AccessContent contentAccess;
  ///   MyContent(this.contentAccess);
  /// }
  ///
  /// final content = MyContent(accessContent);
  /// final result = await content.validateAccess(
  ///   service: ActiveSubscriptionService.instance,
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: failure.message'),
  ///   (hasAccess) => print('Has access: hasAccess'),
  /// );
  /// ```
  Future<Either<Failure, bool>> validateAccess({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    return service.hasAccessToContent(
      content: contentAccess,
      partnerId: partnerId,
      forceRefresh: forceRefresh,
    );
  }

  /// Validates if the current user has access to this content.
  ///
  /// This is a simpler version that returns a boolean directly instead of an Either.
  /// Returns `false` if there's an error.
  ///
  /// **Parameters:**
  /// - [service]: The [ActiveSubscriptionService] instance to use for validation
  /// - [partnerId]: Optional partner ID to restrict validation to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh subscription data
  ///
  /// **Example:**
  /// ```dart
  /// final hasAccess = await content.hasAccess(
  ///   service: ActiveSubscriptionService.instance,
  /// );
  ///
  /// if (hasAccess) {
  ///   print('User can view this content');
  /// } else {
  ///   print('User needs a subscription to view this content');
  /// }
  /// ```
  Future<bool> hasAccess({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, bool> result = await validateAccess(
      service: service,
      partnerId: partnerId,
      forceRefresh: forceRefresh,
    );
    return result.fold(
      (Failure failure) => false,
      (bool hasAccess) => hasAccess,
    );
  }

  /// Checks if the content is currently visible based on time window.
  ///
  /// Returns `true` if the current time is within the [visibleFrom] and [visibleUntil] window.
  ///
  /// This check is independent of subscription status and only validates the time window.
  ///
  /// **Example:**
  /// ```dart
  /// if (content.isCurrentlyVisible()) {
  ///   print('Content is in its visibility window');
  /// } else {
  ///   print('Content is not yet available or has expired');
  /// }
  /// ```
  bool isCurrentlyVisible() {
    if (contentAccess.visibleFrom == null ||
        contentAccess.visibleUntil == null) {
      // If no time restrictions, consider it always visible
      return true;
    }
    final DateTime now = DateTime.now();
    return now.isAfter(contentAccess.visibleFrom!) &&
        now.isBefore(contentAccess.visibleUntil!);
  }

  /// Checks both time visibility and subscription access.
  ///
  /// Returns `true` only if:
  /// 1. Content is within its visibility window
  /// 2. User has an active subscription that grants access
  ///
  /// This is a convenience method that combines [isCurrentlyVisible] and [hasAccess].
  ///
  /// **Parameters:**
  /// - [service]: The [ActiveSubscriptionService] instance to use for validation
  /// - [partnerId]: Optional partner ID to restrict validation to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh subscription data
  ///
  /// **Example:**
  /// ```dart
  /// final canView = await content.canAccessNow(
  ///   service: ActiveSubscriptionService.instance,
  /// );
  ///
  /// if (canView) {
  ///   // Show content
  ///   showContent();
  /// } else {
  ///   // Show paywall or "not available" message
  ///   showPaywall();
  /// }
  /// ```
  Future<bool> canAccessNow({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    // First check time window (cheap operation)
    if (!isCurrentlyVisible()) {
      return false;
    }

    // Then check subscription access
    return hasAccess(
      service: service,
      partnerId: partnerId,
      forceRefresh: forceRefresh,
    );
  }

  /// Gets the reason why access might be denied.
  ///
  /// Returns a user-friendly message explaining why access is not available.
  ///
  /// **Parameters:**
  /// - [service]: The [ActiveSubscriptionService] instance to use for validation
  /// - [partnerId]: Optional partner ID to restrict validation to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh subscription data
  ///
  /// **Returns:**
  /// - `null` if user has access
  /// - A string message if access is denied
  ///
  /// **Example:**
  /// ```dart
  /// final reason = await content.getAccessDeniedReason(
  ///   service: ActiveSubscriptionService.instance,
  /// );
  ///
  /// if (reason != null) {
  ///   showDialog(
  ///     title: 'Acceso restringido',
  ///     message: reason,
  ///   );
  /// }
  /// ```
  Future<String?> getAccessDeniedReason({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final DateTime now = DateTime.now();

    // Check if content is not yet available
    if (contentAccess.visibleFrom != null &&
        now.isBefore(contentAccess.visibleFrom!)) {
      return 'Este contenido estará disponible a partir del ${_formatDate(contentAccess.visibleFrom!)}';
    }

    // Check if content has expired
    if (contentAccess.visibleUntil != null &&
        now.isAfter(contentAccess.visibleUntil!)) {
      return 'Este contenido ya no está disponible. Estuvo disponible hasta el ${_formatDate(contentAccess.visibleUntil!)}';
    }

    // Check subscription access
    final bool hasValidSubscription = await hasAccess(
      service: service,
      partnerId: partnerId,
      forceRefresh: forceRefresh,
    );

    if (!hasValidSubscription) {
      return 'Necesitas una suscripción activa para acceder a este contenido';
    }

    // User has access
    return null;
  }

  /// Formats a date for display in Spanish.
  String _formatDate(DateTime date) {
    final List<String> months = <String>[
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

/// {@template multi_content_access_validator_mixin}
/// Mixin for classes that have multiple [AccessContent] properties.
///
/// This is useful for content that has different access rules for different parts
/// (e.g., a video with preview access and full access).
///
/// **Usage:**
/// ```dart
/// class Video with MultiContentAccessValidatorMixin {
///   final String id;
///   final String title;
///   final AccessContent previewAccess;
///   final AccessContent fullAccess;
///
///   Video({
///     required this.id,
///     required this.title,
///     required this.previewAccess,
///     required this.fullAccess,
///   });
///
///   @override
///   List<AccessContent> get contentAccesses => [previewAccess, fullAccess];
///
///   // Check if user can at least see the preview
///   Future<bool> canSeePreview() async {
///     return hasAccessToAny(
///       service: ActiveSubscriptionService.instance,
///     );
///   }
///
///   // Check if user can see full content
///   Future<bool> canSeeFull() async {
///     final result = await validateMultipleAccess(
///       service: ActiveSubscriptionService.instance,
///     );
///     return result.fold(
///       (failure) => false,
///       (accessMap) => accessMap[fullAccess] ?? false,
///     );
///   }
/// }
/// ```
/// {@endtemplate}
mixin MultiContentAccessValidatorMixin {
  /// List of [AccessContent] objects that define access rules for this content.
  ///
  /// This must be implemented by the class using this mixin.
  List<AccessContent> get contentAccesses;

  /// Validates access for all content access rules.
  ///
  /// Returns an [Either] with a [Map] where keys are [AccessContent] objects
  /// and values are booleans indicating if user has access.
  ///
  /// **Parameters:**
  /// - [service]: The [ActiveSubscriptionService] instance to use for validation
  /// - [partnerId]: Optional partner ID to restrict validation to a specific partner
  /// - [forceRefresh]: Set to true to bypass cache and fetch fresh subscription data
  ///
  /// **Example:**
  /// ```dart
  /// final result = await content.validateMultipleAccess(
  ///   service: ActiveSubscriptionService.instance,
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (accessMap) {
  ///     accessMap.forEach((content, hasAccess) {
  ///       print('${content.contentId}: $hasAccess');
  ///     });
  ///   },
  /// );
  /// ```
  Future<Either<Failure, Map<AccessContent, bool>>> validateMultipleAccess({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    return service.checkMultipleContentAccess(
      contents: contentAccesses,
      partnerId: partnerId,
      forceRefresh: forceRefresh,
    );
  }

  /// Checks if user has access to at least one of the content access rules.
  ///
  /// Returns `true` if user has access to any of the content accesses.
  ///
  /// **Example:**
  /// ```dart
  /// if (await content.hasAccessToAny(service: service)) {
  ///   print('User has some level of access');
  /// }
  /// ```
  Future<bool> hasAccessToAny({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, Map<AccessContent, bool>> result =
        await validateMultipleAccess(
          service: service,
          partnerId: partnerId,
          forceRefresh: forceRefresh,
        );

    return result.fold(
      (Failure failure) => false,
      (Map<AccessContent, bool> accessMap) =>
          accessMap.values.any((bool hasAccess) => hasAccess),
    );
  }

  /// Checks if user has access to all content access rules.
  ///
  /// Returns `true` only if user has access to every content access.
  ///
  /// **Example:**
  /// ```dart
  /// if (await content.hasAccessToAll(service: service)) {
  ///   print('User has full access to everything');
  /// }
  /// ```
  Future<bool> hasAccessToAll({
    required ActiveSubscriptionService service,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    final Either<Failure, Map<AccessContent, bool>> result =
        await validateMultipleAccess(
          service: service,
          partnerId: partnerId,
          forceRefresh: forceRefresh,
        );

    return result.fold(
      (Failure failure) => false,
      (Map<AccessContent, bool> accessMap) =>
          accessMap.values.every((bool hasAccess) => hasAccess),
    );
  }
}

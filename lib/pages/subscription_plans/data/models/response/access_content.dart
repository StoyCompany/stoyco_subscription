import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/logger.dart';

part 'access_content.g.dart';

/// {@template access_content}
/// Represents access control information for content within the Stoyco platform.
///
/// This model defines which subscription plans are required to access specific
/// content, along with visibility time windows for that content.
///
/// All fields are nullable to support partial data scenarios.
///
/// **Use Cases:**
/// - Content gating based on subscription plans
/// - Time-limited content availability
/// - Partner-specific content access control
/// - Multi-plan content sharing
///
/// **Example:**
/// ```dart
/// // Complete data
/// final eventAccess = AccessContent(
///   contentId: 'event_123',
///   partnerId: '507f1f77bcf86cd799439012',
///   planIds: ['basic_plan', 'premium_plan'],
///   visibleFrom: DateTime(2024, 1, 1),
///   visibleUntil: DateTime(2024, 12, 31),
/// );
///
/// // Partial data
/// final partialAccess = AccessContent(
///   contentId: 'public_content',
/// );
/// ```
/// {@endtemplate}
@JsonSerializable()
class AccessContent extends Equatable {
  /// {@macro access_content}
  /// {@macro access_content}
  const AccessContent({
    this.contentId = '',
    this.partnerId = '',
    this.planIds = const <String>[],
    this.visibleFrom,
    this.visibleUntil,
  });

  /// Creates an [AccessContent] from a JSON object.
  ///
  /// This factory uses the generated JSON serialization code.
  /// Handles empty strings by converting them to null.
  ///
  /// **Example:**
  /// ```dart
  /// final json = {
  ///   'contentId': 'event_123',
  ///   'partnerId': '507f1f77bcf86cd799439012',
  ///   'planIds': ['plan_1', 'plan_2'],
  ///   'visibleFrom': '2024-01-01T00:00:00.000Z',
  ///   'visibleUntil': '2024-12-31T23:59:59.999Z',
  /// };
  ///
  /// final accessContent = AccessContent.fromJson(json);
  /// ```
  factory AccessContent.fromJson(Map<String, dynamic> json) =>
      _$AccessContentFromJson(json);

  /// Unique identifier for the content.
  ///
  /// This is typically a MongoDB ObjectId or similar unique identifier that
  /// references the actual content (event, exclusive material, cultural asset, etc.).
  ///
  /// Can be null or empty string if content ID is not available.
  ///
  /// **Example:** `'6914f916eb0355ca86422025'`
  @JsonKey(fromJson: _nullToEmptyString)
  final String contentId;

  /// Unique identifier for the partner who owns this content.
  ///
  /// Used to filter and manage content access on a per-partner basis.
  ///
  /// Can be null or empty string if partner information is not available.
  ///
  /// **Example:** `'66f5bd918d77fca522545f01'`
  @JsonKey(fromJson: _nullToEmptyString)
  final String partnerId;

  /// List of subscription plan IDs that grant access to this content.
  ///
  /// If a user has any of these plans active, they can access the content.
  /// Multiple plans can be specified to allow different subscription tiers
  /// to access the same content.
  ///
  /// Can be null if no specific plans are required (public content) or
  /// if plan information is not available.
  ///
  /// **Example:**
  /// ```dart
  /// planIds: ['basic_plan', 'premium_plan', 'vip_plan']
  /// // Users with any of these three plans can access the content
  /// ```
  @JsonKey(fromJson: _nullToEmptyList)
  final List<String> planIds;

  /// The date and time from which the content becomes visible.
  ///
  /// Content will not be accessible before this date, even if the user
  /// has the required subscription plan.
  ///
  /// Can be null if there's no start date restriction.
  ///
  /// **Example:**
  /// ```dart
  /// visibleFrom: DateTime(2024, 1, 1, 0, 0, 0)
  /// // Content available starting January 1, 2024
  /// ```
  final DateTime? visibleFrom;

  /// The date and time until which the content remains visible.
  ///
  /// Content will not be accessible after this date, even if the user
  /// has the required subscription plan.
  ///
  /// Can be null if there's no end date restriction.
  ///
  /// **Example:**
  /// ```dart
  /// visibleUntil: DateTime(2024, 12, 31, 23, 59, 59)
  /// // Content available until December 31, 2024
  /// ```
  final DateTime? visibleUntil;

  /// Converts null to empty string during serialization.
  static String _nullToEmptyString(String? value) {
    return value ?? '';
  }

  static List<String> _nullToEmptyList(List<dynamic>? value) {
    return value?.map((dynamic e) => e as String).toList() ?? <String>[];
  }

  /// Converts this [AccessContent] to a JSON object.
  ///
  /// Uses the generated JSON serialization code.
  ///
  /// **Example:**
  /// ```dart
  /// final accessContent = AccessContent(
  ///   contentId: 'event_123',
  ///   partnerId: '507f1f77bcf86cd799439012',
  ///   planIds: ['plan_1', 'plan_2'],
  ///   visibleFrom: DateTime(2024, 1, 1),
  ///   visibleUntil: DateTime(2024, 12, 31),
  /// );
  ///
  /// final json = accessContent.toJson();
  /// print(json);
  /// // Output: {contentId: event_123, partnerId: 507f1f77bcf86cd799439012, ...}
  /// ```
  Map<String, dynamic> toJson() => _$AccessContentToJson(this);

    /// Validates if subscriber-only content is available based on visibility date range.
  ///
  /// This method checks whether content should be visible to subscribers based on
  /// the [visibleFrom] and [visibleUntil] date boundaries.
  ///
  /// **Important:** This method compares only dates, ignoring time components.
  /// - If [visibleFrom] is set to 2024-01-15, content is visible from 2024-01-15 00:00:00
  /// - If [visibleUntil] is set to 2024-12-31, content is visible until 2024-12-31 23:59:59
  ///
  /// **Date Configuration Scenarios:**
  /// 1. **Both null**: Content is always in valid range (permanent exclusive content)
  /// 2. **Only visibleFrom**: Content is valid from that date onwards (no expiration)
  /// 3. **Only visibleUntil**: Content is valid until that date (valid from the beginning)
  /// 4. **Both dates**: Content is valid only within the specified range
  ///
  /// **Parameters:**
  /// - [currentDate]: Server date to use for validation (required to prevent client-side manipulation)
  ///
  /// **Returns:**
  /// - `true`: If dates are null (no time restriction) OR current date is within range
  /// - `false`: If current date is before [visibleFrom] OR after [visibleUntil]
  ///
  /// **Example:**
  /// ```dart
  /// // Get server time first
  /// final serverTime = await api.getServerTime();
  ///
  /// // Check if content is visible
  /// final isVisible = accessContent.isVisibleForSubscribers(
  ///   currentDate: serverTime,
  /// );
  ///
  /// if (isVisible) {
  ///   // Show content
  /// } else {
  ///   // Content not available yet or expired
  /// }
  /// ```
  bool isVisibleForSubscribers({
    required DateTime currentDate,
  }) {
    StoyCoLogger.info(
      '[>>] [isVisibleForSubscribers] === Starting date validation ===',
      tag: 'DATE_VALIDATION',
    );
    StoyCoLogger.info(
      '[INFO] [isVisibleForSubscribers] visibleFrom: $visibleFrom, visibleUntil: $visibleUntil, currentDate: $currentDate',
      tag: 'DATE_VALIDATION',
    );

    // If both dates are null, content is available without time restriction
    if (visibleFrom == null && visibleUntil == null) {
      StoyCoLogger.info(
        '[OK] [isVisibleForSubscribers] CASE 1: Both dates NULL - content is ALWAYS valid (permanent exclusive)',
        tag: 'DATE_VALIDATION',
      );
      return true;
    }

    // Normalize dates to compare only date parts (ignore time)
    final DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
    StoyCoLogger.info(
      '[CHECK] [isVisibleForSubscribers] Normalized current date: ${currentDateOnly.toIso8601String()}',
      tag: 'DATE_VALIDATION',
    );

    // Case 2: Only visibleFrom is set (valid from that date onwards, no expiration)
    if (visibleFrom != null && visibleUntil == null) {
      final DateTime visibleFromDateOnly = DateTime(visibleFrom!.year, visibleFrom!.month, visibleFrom!.day);
      StoyCoLogger.info(
        '[CHECK] [isVisibleForSubscribers] CASE 2: Only START date set (${visibleFromDateOnly.toIso8601String()})',
        tag: 'DATE_VALIDATION',
      );
      
      if (currentDateOnly.isBefore(visibleFromDateOnly)) {
        StoyCoLogger.warning(
          '[DENIED] [isVisibleForSubscribers] Current date is BEFORE start date - content NOT YET valid',
          tag: 'DATE_VALIDATION',
        );
        return false;
      }
      
      StoyCoLogger.info(
        '[OK] [isVisibleForSubscribers] Current date is ON or AFTER start date - content IS valid (no end date)',
        tag: 'DATE_VALIDATION',
      );
      return true;
    }

    // Case 3: Only visibleUntil is set (valid until that date, from the beginning)
    if (visibleFrom == null && visibleUntil != null) {
      final DateTime visibleUntilDateOnly = DateTime(visibleUntil!.year, visibleUntil!.month, visibleUntil!.day);
      StoyCoLogger.info(
        '[CHECK] [isVisibleForSubscribers] CASE 3: Only END date set (${visibleUntilDateOnly.toIso8601String()})',
        tag: 'DATE_VALIDATION',
      );
      
      if (currentDateOnly.isAfter(visibleUntilDateOnly)) {
        StoyCoLogger.warning(
          '[DENIED] [isVisibleForSubscribers] Current date is AFTER end date - content EXPIRED',
          tag: 'DATE_VALIDATION',
        );
        return false;
      }
      
      StoyCoLogger.info(
        '[OK] [isVisibleForSubscribers] Current date is ON or BEFORE end date - content IS valid (no start date)',
        tag: 'DATE_VALIDATION',
      );
      return true;
    }

    // Case 4: Both dates are set (valid only within the range)
    StoyCoLogger.info(
      '[CHECK] [isVisibleForSubscribers] CASE 4: Both dates set - validating range',
      tag: 'DATE_VALIDATION',
    );
    
    final DateTime visibleFromDateOnly = DateTime(visibleFrom!.year, visibleFrom!.month, visibleFrom!.day);
    final DateTime visibleUntilDateOnly = DateTime(visibleUntil!.year, visibleUntil!.month, visibleUntil!.day);
    
    StoyCoLogger.info(
      '[CLOCK] [isVisibleForSubscribers] Range: ${visibleFromDateOnly.toIso8601String()} to ${visibleUntilDateOnly.toIso8601String()}',
      tag: 'DATE_VALIDATION',
    );
    
    if (currentDateOnly.isBefore(visibleFromDateOnly)) {
      StoyCoLogger.warning(
        '[DENIED] [isVisibleForSubscribers] Current date is BEFORE start date - content NOT YET valid',
        tag: 'DATE_VALIDATION',
      );
      return false;
    }
    
    if (currentDateOnly.isAfter(visibleUntilDateOnly)) {
      StoyCoLogger.warning(
        '[DENIED] [isVisibleForSubscribers] Current date is AFTER end date - content EXPIRED',
        tag: 'DATE_VALIDATION',
      );
      return false;
    }

    StoyCoLogger.info(
      '[OK] [isVisibleForSubscribers] Current date is WITHIN range - content IS valid',
      tag: 'DATE_VALIDATION',
    );
    return true;
  }

  @override
  List<Object?> get props => <Object?>[
    contentId,
    partnerId,
    planIds,
    visibleFrom,
    visibleUntil,
  ];
}

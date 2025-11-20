import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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
  const AccessContent({
    this.contentId,
    this.partnerId,
    this.planIds,
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
  @JsonKey(
    fromJson: _emptyStringToNull,
    toJson: _nullToEmptyString,
  )
  final String? contentId;

  /// Unique identifier for the partner who owns this content.
  ///
  /// Used to filter and manage content access on a per-partner basis.
  ///
  /// Can be null or empty string if partner information is not available.
  ///
  /// **Example:** `'66f5bd918d77fca522545f01'`
  @JsonKey(
    fromJson: _emptyStringToNull,
    toJson: _nullToEmptyString,
  )
  final String? partnerId;

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
  final List<String>? planIds;

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

  /// Converts empty string to null during deserialization.
  static String? _emptyStringToNull(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  /// Converts null to empty string during serialization.
  static String? _nullToEmptyString(String? value) {
    return value ?? '';
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

  @override
  List<Object?> get props => <Object?>[
        contentId,
        partnerId,
        planIds,
        visibleFrom,
        visibleUntil,
      ];
}

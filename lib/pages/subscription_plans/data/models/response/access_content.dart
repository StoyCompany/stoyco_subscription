import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'access_content.g.dart';

/// {@template access_content}
/// Represents access control information for content within the Stoyco platform.
///
/// This model defines which subscription plans are required to access specific
/// content, along with visibility time windows for that content.
///
/// **Use Cases:**
/// - Content gating based on subscription plans
/// - Time-limited content availability
/// - Partner-specific content access control
/// - Multi-plan content sharing
///
/// **Example:**
/// ```dart
/// final eventAccess = AccessContent(
///   contentId: 'event_123',
///   partnerId: '507f1f77bcf86cd799439012',
///   planIds: ['basic_plan', 'premium_plan'],
///   visibleFrom: DateTime(2024, 1, 1),
///   visibleUntil: DateTime(2024, 12, 31),
/// );
/// ```
/// {@endtemplate}
@JsonSerializable()
class AccessContent extends Equatable {
  /// {@macro access_content}
  AccessContent({
    this.contentId = '',
    this.partnerId = '',
    this.planIds = const <String>[],
    DateTime? visibleFrom,
    DateTime? visibleUntil,
  }) : visibleFrom = visibleFrom ?? _defaultDateTime,
       visibleUntil = visibleUntil ?? _defaultDateTime;

  /// Default DateTime used when no date is provided.
  static final DateTime _defaultDateTime = DateTime(1970, 1, 1);

  /// Creates an [AccessContent] from a JSON object.
  ///
  /// This factory uses the generated JSON serialization code.
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

  /// Creates an [AccessContent] instance from a map.
  ///
  /// This is useful when working with raw map data that needs to be converted
  /// to an [AccessContent] object without going through JSON serialization.
  ///
  /// This factory handles flexible DateTime parsing, accepting both String
  /// (ISO 8601 format) and DateTime objects. Missing fields use default values.
  ///
  /// **Parameters:**
  /// - [map]: Map containing the access content data with keys:
  ///   - `contentId`: String - Unique identifier (defaults to empty string)
  ///   - `partnerId`: String - Partner ID (defaults to empty string)
  ///   - `planIds`: List<String> - Plan IDs (defaults to empty list)
  ///   - `visibleFrom`: String or DateTime (defaults to 1970-01-01)
  ///   - `visibleUntil`: String or DateTime (defaults to 1970-01-01)
  ///
  /// **Example:**
  /// ```dart
  /// // Complete data
  /// final map1 = {
  ///   'contentId': 'event_123',
  ///   'partnerId': '507f1f77bcf86cd799439012',
  ///   'planIds': ['plan_1', 'plan_2', 'plan_3'],
  ///   'visibleFrom': '2024-01-01T00:00:00.000Z',
  ///   'visibleUntil': '2024-12-31T23:59:59.999Z',
  /// };
  /// final accessContent1 = AccessContent.fromMap(map1);
  ///
  /// // Partial data (uses defaults)
  /// final map2 = {
  ///   'contentId': 'event_456',
  /// };
  /// final accessContent2 = AccessContent.fromMap(map2);
  /// // contentId: 'event_456'
  /// // partnerId: ''
  /// // planIds: []
  /// // visibleFrom: DateTime(1970, 1, 1)
  /// // visibleUntil: DateTime(1970, 1, 1)
  /// ```
  factory AccessContent.fromMap(Map<String, dynamic> map) {
    return AccessContent(
      contentId: map['contentId'] as String? ?? '',
      partnerId: map['partnerId'] as String? ?? '',
      planIds: map['planIds'] != null
          ? (map['planIds'] as List<dynamic>).map((e) => e as String).toList()
          : const <String>[],
      visibleFrom: map['visibleFrom'] != null
          ? (map['visibleFrom'] is String
                ? DateTime.parse(map['visibleFrom'] as String)
                : map['visibleFrom'] as DateTime)
          : null,
      visibleUntil: map['visibleUntil'] != null
          ? (map['visibleUntil'] is String
                ? DateTime.parse(map['visibleUntil'] as String)
                : map['visibleUntil'] as DateTime)
          : null,
    );
  }

  /// Unique identifier for the content.
  ///
  /// This is typically a MongoDB ObjectId or similar unique identifier that
  /// references the actual content (event, exclusive material, cultural asset, etc.).
  ///
  /// Defaults to empty string if not provided.
  ///
  /// **Example:** `'6914f916eb0355ca86422025'`
  final String contentId;

  /// Unique identifier for the partner who owns this content.
  ///
  /// Used to filter and manage content access on a per-partner basis.
  ///
  /// Defaults to empty string if not provided.
  ///
  /// **Example:** `'66f5bd918d77fca522545f01'`
  final String partnerId;

  /// List of subscription plan IDs that grant access to this content.
  ///
  /// If a user has any of these plans active, they can access the content.
  /// Multiple plans can be specified to allow different subscription tiers
  /// to access the same content.
  ///
  /// Defaults to empty list if not provided.
  ///
  /// **Example:**
  /// ```dart
  /// planIds: ['basic_plan', 'premium_plan', 'vip_plan']
  /// // Users with any of these three plans can access the content
  /// ```
  final List<String> planIds;

  /// The date and time from which the content becomes visible.
  ///
  /// Content will not be accessible before this date, even if the user
  /// has the required subscription plan.
  ///
  /// Defaults to `DateTime(1970, 1, 1)` if not provided.
  ///
  /// **Example:**
  /// ```dart
  /// visibleFrom: DateTime(2024, 1, 1, 0, 0, 0)
  /// // Content available starting January 1, 2024
  /// ```
  final DateTime visibleFrom;

  /// The date and time until which the content remains visible.
  ///
  /// Content will not be accessible after this date, even if the user
  /// has the required subscription plan.
  ///
  /// Defaults to `DateTime(1970, 1, 1)` if not provided.
  ///
  /// **Example:**
  /// ```dart
  /// visibleUntil: DateTime(2024, 12, 31, 23, 59, 59)
  /// // Content available until December 31, 2024
  /// ```
  final DateTime visibleUntil;

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

  /// Converts this [AccessContent] to a map with DateTime values as ISO 8601 strings.
  ///
  /// This is useful for database operations or API requests where DateTime
  /// objects need to be serialized as strings.
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
  /// final map = accessContent.toMap();
  /// print(map['visibleFrom']); // "2024-01-01T00:00:00.000Z"
  /// print(map['visibleUntil']); // "2024-12-31T00:00:00.000Z"
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      'partnerId': partnerId,
      'planIds': planIds,
      'visibleFrom': visibleFrom.toIso8601String(),
      'visibleUntil': visibleUntil.toIso8601String(),
    };
  }

  /// Returns the properties used for equality comparison.
  ///
  /// Two [AccessContent] instances are considered equal if all their
  /// properties are equal.
  @override
  List<Object?> get props => <Object?>[
    contentId,
    partnerId,
    planIds,
    visibleFrom,
    visibleUntil,
  ];
}

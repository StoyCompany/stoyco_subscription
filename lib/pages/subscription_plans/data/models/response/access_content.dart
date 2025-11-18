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
  const AccessContent({
    required this.contentId,
    required this.partnerId,
    required this.planIds,
    required this.visibleFrom,
    required this.visibleUntil,
  });

  /// Creates an empty [AccessContent] with default values.
  ///
  /// This is useful for initialization or placeholder scenarios.
  ///
  /// **Example:**
  /// ```dart
  /// final emptyAccess = AccessContent.empty();
  /// ```
  AccessContent.empty()
    : contentId = null,
      partnerId = null,
      planIds = null,
      visibleFrom = null,
      visibleUntil = null;

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
  /// (ISO 8601 format) and DateTime objects.
  ///
  /// **Parameters:**
  /// - [map]: Map containing the access content data with keys:
  ///   - `contentId`: String - Unique identifier for the content
  ///   - `partnerId`: String - Partner who owns the content
  ///   - `planIds`: List<String> - Subscription plans that grant access
  ///   - `visibleFrom`: String or DateTime - Start of visibility period
  ///   - `visibleUntil`: String or DateTime - End of visibility period
  ///
  /// **Example:**
  /// ```dart
  /// // With String dates (ISO 8601)
  /// final map1 = {
  ///   'contentId': 'event_123',
  ///   'partnerId': '507f1f77bcf86cd799439012',
  ///   'planIds': ['plan_1', 'plan_2', 'plan_3'],
  ///   'visibleFrom': '2024-01-01T00:00:00.000Z',
  ///   'visibleUntil': '2024-12-31T23:59:59.999Z',
  /// };
  /// final accessContent1 = AccessContent.fromMap(map1);
  ///
  /// // With DateTime objects
  /// final map2 = {
  ///   'contentId': 'exclusive_456',
  ///   'partnerId': '507f1f77bcf86cd799439012',
  ///   'planIds': ['premium_plan'],
  ///   'visibleFrom': DateTime(2024, 6, 1),
  ///   'visibleUntil': DateTime(2024, 6, 30),
  /// };
  /// final accessContent2 = AccessContent.fromMap(map2);
  /// ```
  factory AccessContent.fromMap(Map<String, dynamic> map) {
    return AccessContent(
      contentId: map['contentId'] as String,
      partnerId: map['partnerId'] as String,
      planIds: (map['planIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      visibleFrom: map['visibleFrom'] is String
          ? DateTime.parse(map['visibleFrom'] as String)
          : map['visibleFrom'] as DateTime,
      visibleUntil: map['visibleUntil'] is String
          ? DateTime.parse(map['visibleUntil'] as String)
          : map['visibleUntil'] as DateTime,
    );
  }

  /// Unique identifier for the content.
  ///
  /// This is typically a MongoDB ObjectId or similar unique identifier that
  /// references the actual content (event, exclusive material, cultural asset, etc.).
  ///
  /// **Example:** `'6914f916eb0355ca86422025'`
  final String? contentId;

  /// Unique identifier for the partner who owns this content.
  ///
  /// Used to filter and manage content access on a per-partner basis.
  ///
  /// **Example:** `'66f5bd918d77fca522545f01'`
  final String? partnerId;

  /// List of subscription plan IDs that grant access to this content.
  ///
  /// If a user has any of these plans active, they can access the content.
  /// Multiple plans can be specified to allow different subscription tiers
  /// to access the same content.
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
  /// **Example:**
  /// ```dart
  /// visibleUntil: DateTime(2024, 12, 31, 23, 59, 59)
  /// // Content available until December 31, 2024
  /// ```
  final DateTime? visibleUntil;

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
      'visibleFrom': visibleFrom?.toIso8601String(),
      'visibleUntil': visibleUntil?.toIso8601String(),
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

  /// Checks if this [AccessContent] instance is empty.
  bool get isEmpty => this == AccessContent.empty();
}

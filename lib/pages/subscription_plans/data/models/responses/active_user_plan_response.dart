import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'active_user_plan_response.g.dart';

/// {@template active_user_plan_response}
/// Response model containing active subscription plans for a user.
///
/// Includes metadata (error code, messages, count) and a list of
/// [ActiveUserPlan] objects representing the user's active subscriptions.
///
/// **Example:**
/// ```dart
/// final response = ActiveUserPlanResponse.fromJson(apiResponse);
/// print('User has ${response.count} active subscriptions');
/// for (final plan in response.data) {
///   print('Plan: ${plan.plan.name}');
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class ActiveUserPlanResponse extends Equatable {
  /// {@macro active_user_plan_response}
  const ActiveUserPlanResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  /// Creates an [ActiveUserPlanResponse] from JSON.
  factory ActiveUserPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveUserPlanResponseFromJson(json);

  /// Error code (0 = success, non-zero = error).
  final int error;

  /// User-friendly error message.
  final String messageError;

  /// Technical error message for debugging.
  final String tecMessageError;

  /// Number of active subscription plans.
  final int count;

  /// List of active user subscription plans.
  final List<ActiveUserPlan> data;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => _$ActiveUserPlanResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[
        error,
        messageError,
        tecMessageError,
        count,
        data,
      ];
}

/// {@template active_user_plan}
/// Represents a user's active subscription plan.
///
/// Contains plan details, partner info, subscription dates, trial information,
/// and recurrence settings. Maps to the UserPlan model from the backend.
///
/// **Example:**
/// ```dart
/// final userPlan = ActiveUserPlan.fromJson(json);
/// if (userPlan.isActive) {
///   print('Active until: ${userPlan.endDate}');
///   print('Accesses: ${userPlan.plan.accesses.join(", ")}');
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class ActiveUserPlan extends Equatable {
  /// {@macro active_user_plan}
  const ActiveUserPlan({
    required this.id,
    required this.plan,
    required this.partnerId,
    required this.userId,
    required this.recurrence,
    required this.subscribedAt,
    required this.isActive,
    this.trialStartDate,
    this.trialEndDate,
    required this.endDate,
    required this.createdAt,
    required this.modifiedAt,
  });

  /// Creates an [ActiveUserPlan] from JSON.
  factory ActiveUserPlan.fromJson(Map<String, dynamic> json) =>
      _$ActiveUserPlanFromJson(json);

  /// Unique identifier (MongoDB ObjectId).
  final String id;

  /// Subscription plan information.
  final PlanInfo plan;

  /// Partner's unique identifier (MongoDB ObjectId).
  final String partnerId;

  /// User's unique identifier (Firebase UID).
  final String userId;

  /// Billing recurrence (e.g., "Monthly", "Yearly").
  final String recurrence;

  /// Subscription start date.
  final DateTime subscribedAt;

  /// Whether the subscription is currently active.
  final bool isActive;

  /// Trial period start date (if applicable).
  final DateTime? trialStartDate;

  /// Trial period end date (if applicable).
  final DateTime? trialEndDate;

  /// Subscription end date.
  final DateTime endDate;

  /// Record creation date.
  final DateTime createdAt;

  /// Last modification date.
  final DateTime modifiedAt;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => _$ActiveUserPlanToJson(this);

  @override
  List<Object?> get props => <Object?>[
        id,
        plan,
        partnerId,
        userId,
        recurrence,
        subscribedAt,
        isActive,
        trialStartDate,
        trialEndDate,
        endDate,
        createdAt,
        modifiedAt,
      ];
}

/// {@template plan_info}
/// Information about a subscription plan.
///
/// Contains plan metadata including name, ID, deletion status,
/// and access permissions. Maps to the PlanInfo model from the backend.
///
/// **Example:**
/// ```dart
/// final planInfo = PlanInfo.fromJson(json);
/// if (!planInfo.isDeleted && planInfo.accesses.contains('events')) {
///   print('${planInfo.name} includes event access');
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class PlanInfo extends Equatable {
  /// {@macro plan_info}
  const PlanInfo({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.accesses,
  });

  /// Creates a [PlanInfo] from JSON.
  factory PlanInfo.fromJson(Map<String, dynamic> json) =>
      _$PlanInfoFromJson(json);

  /// Plan unique identifier (MongoDB ObjectId).
  final String id;

  /// Display name of the plan.
  final String name;

  /// Whether the plan has been soft-deleted.
  final bool isDeleted;

  /// List of content/feature access permissions (e.g., 'events', 'exclusive_content').
  final List<String> accesses;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => _$PlanInfoToJson(this);

  @override
  List<Object?> get props => <Object?>[id, name, isDeleted, accesses];
}

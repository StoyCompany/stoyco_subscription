import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'active_user_plan_response.g.dart';

/// {@template active_user_plan_response}
/// Model representing the response for active user plans API.
///
/// Contains metadata about the request (error, messages, count)
/// and a list of [ActiveUserPlan] objects.
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

  /// Creates an [ActiveUserPlanResponse] from a JSON map.
  factory ActiveUserPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveUserPlanResponseFromJson(json);

  /// Error code returned by the API.
  final int error;

  /// User-friendly error message.
  @JsonKey(name: 'messageError')
  final String messageError;

  /// Technical error message for debugging.
  @JsonKey(name: 'tecMessageError')
  final String tecMessageError;

  /// Number of active subscription plans returned.
  final int count;

  /// List of active user subscription plans.
  final List<ActiveUserPlan> data;

  /// Converts this object to a JSON map.
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
/// Model representing an active user subscription plan.
///
/// Maps to the UserPlan model from the .NET backend.
/// Contains details about the plan, partner, recurrence,
/// subscription dates, and trial information.
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

  /// Creates an [ActiveUserPlan] from a JSON map.
  factory ActiveUserPlan.fromJson(Map<String, dynamic> json) =>
      _$ActiveUserPlanFromJson(json);

  /// MongoDB ObjectId of the user plan document.
  @JsonKey(name: '_id')
  final String id;


  /// Information about the subscription plan.
  final PlanInfo plan;

  /// MongoDB ObjectId of the partner.
  final String partnerId;

  /// Firebase user ID.
  final String userId;

  /// Recurrence type (e.g., "Monthly", "Yearly").
  final String recurrence;

  /// Date when the user subscribed to this plan.
  final DateTime subscribedAt;

  /// Whether the subscription is currently active.
  final bool isActive;

  /// Start date of the trial period (if applicable).
  final DateTime? trialStartDate;

  /// End date of the trial period (if applicable).
  final DateTime? trialEndDate;

  /// Date when the subscription ends.
  final DateTime endDate;

  /// Date when the record was created.
  final DateTime createdAt;

  /// Date when the record was last modified.
  final DateTime modifiedAt;

  /// Converts this object to a JSON map.
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
/// Model representing plan information within a user subscription.
///
/// Maps to the PlanInfo model from the .NET backend.
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

  /// Creates a [PlanInfo] from a JSON map.
  factory PlanInfo.fromJson(Map<String, dynamic> json) =>
      _$PlanInfoFromJson(json);

  /// MongoDB ObjectId of the plan.
  final String id;

  /// Name of the subscription plan.
  final String name;

  /// Whether the plan has been deleted.
  final bool isDeleted;

  /// List of access permissions or features included in the plan.
  final List<String> accesses;

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => _$PlanInfoToJson(this);

  @override
  List<Object?> get props => <Object?>[id, name, isDeleted, accesses];
}

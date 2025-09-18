import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_subscription_plan_response.g.dart';

/// {@template user_subscription_plan_response}
/// Model representing the response for user subscription plans API.
///
/// Contains metadata about the request (error, messages, count)
/// and a list of [UserSubscriptionPlan] objects.
/// {@endtemplate}
@JsonSerializable()
class UserSubscriptionPlanResponse extends Equatable {
  /// {@macro user_subscription_plan_response}
  const UserSubscriptionPlanResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  /// Creates a [UserSubscriptionPlanResponse] from a JSON map.
  factory UserSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionPlanResponseFromJson(json);

  /// Error code returned by the API.
  final int error;

  /// User-friendly error message.
  final String messageError;

  /// Technical error message for debugging.
  final String tecMessageError;

  /// Number of subscription plans returned.
  final int count;

  /// List of user subscription plans.
  final List<UserSubscriptionPlan> data;

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => _$UserSubscriptionPlanResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[
    error,
    messageError,
    tecMessageError,
    count,
    data,
  ];
}

/// {@template user_subscription_plan}
/// Model representing a single user subscription plan.
///
/// Contains details about the plan, partner, recurrence, price,
/// subscription dates, and status.
/// {@endtemplate}
@JsonSerializable()
class UserSubscriptionPlan extends Equatable {
  /// {@macro user_subscription_plan}
  const UserSubscriptionPlan({
    required this.planName,
    required this.planImageUrl,
    required this.partnerName,
    required this.partnerProfile,
    required this.recurrenceType,
    required this.price,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.isActive,
  });

  /// Creates a [UserSubscriptionPlan] from a JSON map.
  factory UserSubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionPlanFromJson(json);

  /// Name of the subscription plan.
  final String planName;

  /// URL of the plan's image.
  final String planImageUrl;

  /// Name of the partner offering the plan.
  final String partnerName;

  /// Profile or category of the partner.
  final String partnerProfile;

  /// Recurrence type of the plan (e.g., Monthly, Annual).
  final String recurrenceType;

  /// Price of the subscription plan.
  final double price;

  /// Start date of the subscription.
  final DateTime subscriptionStartDate;

  /// End date of the subscription.
  final DateTime subscriptionEndDate;

  /// Indicates if the subscription is currently active.
  final bool isActive;

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => _$UserSubscriptionPlanToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planName,
    planImageUrl,
    partnerName,
    partnerProfile,
    recurrenceType,
    price,
    subscriptionStartDate,
    subscriptionEndDate,
    isActive,
  ];
}

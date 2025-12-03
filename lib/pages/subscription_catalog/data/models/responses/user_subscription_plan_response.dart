import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/enums/subscription_status.enum.dart';

part 'user_subscription_plan_response.g.dart';

/// {@template user_subscription_plan_response}
/// Model representing the response for user subscription plans API.
///
/// Contains metadata about the request (error, messages, count)
/// and a list of [UserSubscriptionPlan] objects.
///
/// Example usage:
/// ```dart
/// final response = UserSubscriptionPlanResponse.fromJson(jsonMap);
/// print(response.data.first.planName);
/// ```
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
///
/// Example usage:
/// ```dart
/// final plan = UserSubscriptionPlan.fromJson(jsonMap);
/// print(plan.planName);
/// print(plan.planStatus); // SubscriptionStatus.active
/// ```
/// {@endtemplate}
@JsonSerializable()
class UserSubscriptionPlan extends Equatable {
  /// {@macro user_subscription_plan}
  const UserSubscriptionPlan({
    required this.planId,
    required this.planName,
    required this.planImageUrl,
    required this.partnerProfile,
    required this.partnerName,
    required this.partnerId,
    required this.recurrenceType,
    required this.price,
    required this.currencyCode,
    required this.currencySymbol,
    required this.planStatus,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.hasActivePlan,
    required this.planIsDeleted,
  });

  /// Creates a [UserSubscriptionPlan] from a JSON map.
  factory UserSubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionPlanFromJson(json);

  /// The unique identifier of the plan.
  final String planId;

  /// The name of the subscription plan.
  final String planName;

  /// The URL of the plan's image.
  final String planImageUrl;

  /// The profile type of the partner (e.g., "Music", "Video").
  final String partnerProfile;

  /// The name of the partner.
  final String partnerName;

  /// The unique identifier of the partner.
  final String partnerId;

  /// The recurrence type of the subscription (e.g., "Monthly", "Annual").
  final String recurrenceType;

  /// The price of the subscription plan.
  final num price;

  /// The currency code (e.g., "USD", "MXN").
  final String currencyCode;

  /// The currency symbol (e.g., "$").
  final String currencySymbol;

  /// The current status of the subscription plan.
  ///
  /// Possible values:
  /// - [SubscriptionStatus.pendingPayment]: Payment is pending, blocks all flows
  /// - [SubscriptionStatus.trialPeriod]: Trial period active, allows cancellation
  /// - [SubscriptionStatus.paymentFailed]: Payment failed, allows renewal flow
  /// - [SubscriptionStatus.active]: Active subscription, allows cancellation
  /// - [SubscriptionStatus.scheduledToStart]: Subscription scheduled to start
  /// - [SubscriptionStatus.cancelled]: Subscription cancelled, allows purchase
  /// - [SubscriptionStatus.pendingCancellation]: Pending cancellation, blocks all flows
  /// - [SubscriptionStatus.renewalAvailable]: Renewal available, allows renewal flow
  @JsonKey(
    fromJson: _subscriptionStatusFromJson,
    toJson: _subscriptionStatusToJson,
  )
  final SubscriptionStatus planStatus;

  /// The start date of the subscription (ISO 8601 string).
  final String subscriptionStartDate;

  /// The end date of the subscription (ISO 8601 string).
  final String subscriptionEndDate;

  /// Whether the user has an active plan.
  final bool hasActivePlan;

  /// Whether the plan has been deleted.
  final bool planIsDeleted;

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => _$UserSubscriptionPlanToJson(this);

  /// Converts a JSON string value to [SubscriptionStatus] enum.
  static SubscriptionStatus _subscriptionStatusFromJson(String value) =>
      SubscriptionStatus.fromValue(value);

  /// Converts [SubscriptionStatus] enum to a JSON string value.
  static String _subscriptionStatusToJson(SubscriptionStatus status) =>
      status.toValue();

  @override
  List<Object?> get props => <Object?>[
    planId,
    planName,
    planImageUrl,
    partnerProfile,
    partnerName,
    partnerId,
    recurrenceType,
    price,
    currencyCode,
    currencySymbol,
    planStatus,
    subscriptionStartDate,
    subscriptionEndDate,
    hasActivePlan,
    planIsDeleted,
  ];
}

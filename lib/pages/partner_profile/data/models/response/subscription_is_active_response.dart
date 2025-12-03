import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/enums/subscription_status.enum.dart';

part 'subscription_is_active_response.g.dart';

/// {@template subscription_is_active_response}
/// Model representing the response for checking if a user has an active subscription.
///
/// Contains details about the user's subscription plan, including status,
/// dates, pricing, and partner information.
///
/// Example usage:
/// ```dart
/// final response = SubscriptionIsActiveResponse.fromJson(jsonMap);
/// print(response.planName);
/// if (response.planStatus == SubscriptionStatus.active) {
///   print('Subscription is active');
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class SubscriptionIsActiveResponse extends Equatable {
  /// {@macro subscription_is_active_response}
  const SubscriptionIsActiveResponse({
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

  /// Creates a [SubscriptionIsActiveResponse] from a JSON map.
  factory SubscriptionIsActiveResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionIsActiveResponseFromJson(json);

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
  Map<String, dynamic> toJson() => _$SubscriptionIsActiveResponseToJson(this);

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

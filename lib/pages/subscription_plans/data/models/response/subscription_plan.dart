import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_plan.g.dart';

/// Model representing a subscription plan option (child).
@JsonSerializable()
class SubscriptionPlan extends Equatable {
  /// Creates a [SubscriptionPlan] model.
  ///
  /// [name] - The name/title of the plan.
  /// [imageUrl] - The image URL for the plan.
  /// [description] - The HTML description of the plan's benefits.
  /// [price] - The price of the plan.
  /// [currencyCode] - The currency code or text (e.g., 'MXN').
  /// [currencySymbol] - The currency symbol (e.g., '$').
  /// [subscribed] - Whether the user is currently subscribed to this plan.
  /// [subscribedIsActive] - Whether the plan is currently active.
  /// [subscribedAt] - The date/time when the user subscribed.
  /// [expiresAt] - The date/time when the subscription expires.
  /// [recommended] - Whether this plan is recommended.
  /// [priceDiscount] - The discounted price, if any.
  /// [porcentageDiscount] - The discount percentage, if any.
  /// [messageDiscount] - The message to display for the discount.
  /// [messageSuscriptionStatus] - The message to display for the subscription status.
  /// [messageTrial] - The message to display for the trial status.
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.currencySymbol,
    this.subscribed = false,
    this.subscribedIsActive = false,
    this.subscribedIsPendingActivation = false,
    this.subscribedAt,
    this.expiresAt,
    this.trialStart,
    this.trialEnd,
    this.recommended = false,
    this.priceDiscount = 0.0,
    this.porcentageDiscount = 0.0,
    this.messageDiscount = '',
    this.messageSuscriptionStatus = '',
    this.messageTrial = '',
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanFromJson(json);

  /// The unique identifier of the plan.
  final String id;

  /// The name/title of the plan.
  final String name;

  /// The image URL for the plan.
  final String imageUrl;

  /// The HTML description of the plan's benefits.
  final String description;

  /// The price of the plan.
  final double price;

  /// The currency code or text (e.g., 'MXN').
  final String currencyCode;

  /// The currency symbol (e.g., '$').
  final String currencySymbol;

  /// Whether the user is currently subscribed to this plan.
  final bool subscribed;

  /// Whether the plan is currently active.
  final bool subscribedIsActive;

  /// Whether the subscription is pending activation.
  final bool subscribedIsPendingActivation;

  /// The date/time when the user subscribed.
  final DateTime? subscribedAt;

  /// The date/time when the subscription expires.
  final DateTime? expiresAt;

  /// The date/time when the trial starts.
  final DateTime? trialStart;

  /// The date/time when the trial ends.
  final DateTime? trialEnd;

  /// Whether this plan is recommended.
  final bool recommended;

  /// The discounted price, if any.
  final double priceDiscount;

  /// The discount percentage, if any.
  final double porcentageDiscount;

  /// The message to display for the discount.
  final String messageDiscount;

  /// The message to display for the subscription status.
  final String messageSuscriptionStatus;

  /// The message to display for the trial status.
  final String messageTrial;

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    imageUrl,
    description,
    price,
    currencyCode,
    subscribed,
    subscribedIsActive,
    subscribedAt,
    expiresAt,
    recommended,
    priceDiscount,
    porcentageDiscount,
    messageDiscount,
    messageSuscriptionStatus,
    messageTrial,
    currencySymbol,
  ];
}

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
  /// [subscribed] - Whether the user is currently subscribed to this plan.
  /// [isActive] - Whether the plan is currently active.
  /// [subscribedAt] - The date/time when the user subscribed.
  /// [expiresAt] - The date/time when the subscription expires.
  /// [recommended] - Whether this plan is recommended.
  /// [priceDiscount] - The discounted price, if any.
  /// [porcentageDiscount] - The discount percentage, if any.
  /// [messageDiscount] - The message to display for the discount.
  const SubscriptionPlan({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.subscribed,
    this.isActive = false,
    this.subscribedAt,
    this.expiresAt,
    this.recommended = false,
    this.priceDiscount = 0.0,
    this.porcentageDiscount = 0.0,
    this.messageDiscount = '',
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanFromJson(json);

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

  /// Whether the user is currently subscribed to this plan.
  final bool subscribed;

  /// Whether the plan is currently active.
  final bool isActive;

  /// The date/time when the user subscribed.
  final DateTime? subscribedAt;

  /// The date/time when the subscription expires.
  final DateTime? expiresAt;

  /// Whether this plan is recommended.
  final bool recommended;

  /// The discounted price, if any.
  final double priceDiscount;

  /// The discount percentage, if any.
  final double porcentageDiscount;

  /// The message to display for the discount.
  final String messageDiscount;

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  @override
  List<Object?> get props => <Object?>[
    name,
    imageUrl,
    description,
    price,
    currencyCode,
    subscribed,
    isActive,
    subscribedAt,
    expiresAt,
    recommended,
    priceDiscount,
    porcentageDiscount,
    messageDiscount,
  ];
}

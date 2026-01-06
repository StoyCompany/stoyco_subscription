import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/utils/platform_access.dart';

part 'subscription_plan.g.dart';


/// Model representing a subscription plan option (child).
@JsonSerializable()
class SubscriptionPlan extends Equatable {
  /// Creates a [SubscriptionPlan] model.
  /// [userStatus] - The user status for this plan (can be null).
  /// [actions] - The actions available for this plan (can be null).
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.currencySymbol,
    required this.actions,
    this.recommended = false,
    this.userStatus,
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

  /// Whether this plan is recommended.
  final bool recommended;

  /// The user status for this plan (can be null).
  final UserStatus? userStatus;

  /// The actions available for this plan (can be null).
  final PlanActions actions;

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  /// returns true if the user has access to the current platform.
  bool hasPlatformAccess() {
    final UserStatus? userStatus = this.userStatus;
    if (userStatus == null) {
      return true;
    }
    return userStatus.userPlatform == getCurrentPlatform();
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    imageUrl,
    description,
    price,
    currencyCode,
    currencySymbol,
    recommended,
    userStatus,
    actions,
  ];
}

/// Model representing the user status for a subscription plan.
@JsonSerializable()
class UserStatus extends Equatable {
  const UserStatus({
    this.isSubscribed = false,
    this.isActive = false,
    this.isPendingActivation = false,
    this.isCurrent = false,
    this.messageSubscriptionStatus = '',
    this.subscribedAt,
    this.expiresAt,
    this.trialStart,
    this.trialEnd,
    this.platform=''
  });

  const UserStatus.empty() : 
    isSubscribed = false,
    isActive = false,
    isPendingActivation = false,
    isCurrent = false,
    messageSubscriptionStatus = '',
    subscribedAt = null,
    expiresAt = null,
    trialStart = null,
    platform='',
    trialEnd = null;

  factory UserStatus.fromJson(Map<String, dynamic> json) => _$UserStatusFromJson(json);

  final bool isSubscribed;
  final bool isActive;
  final bool isPendingActivation;
  final bool isCurrent;
  final String messageSubscriptionStatus;
  @JsonKey(includeIfNull: true)
  final DateTime? subscribedAt;
  @JsonKey(includeIfNull: true)
  final DateTime? expiresAt;
  @JsonKey(includeIfNull: true)
  final DateTime? trialStart;
  @JsonKey(includeIfNull: true)
  final DateTime? trialEnd;
  @JsonKey(includeIfNull: true)
  final String platform;

  Map<String, dynamic> toJson() => _$UserStatusToJson(this);


  String get userPlatform => platform;

  @override
  List<Object?> get props => <Object?>[
    isSubscribed,
    isActive,
    isPendingActivation,
    isCurrent,
    messageSubscriptionStatus,
    subscribedAt,
    expiresAt,
    trialStart,
    trialEnd,
    platform,
  ];
}

/// Model representing the actions available for a subscription plan.
@JsonSerializable()
class PlanActions extends Equatable {
  const PlanActions({
    this.showBuy = false,
    this.showRenew = false,
    this.showCancel = false,
    this.errorRenewSubscription = false,
    this.priceDiscount = 0.0,
    this.porcentageDiscount = 0.0,
    this.messageDiscount = '',
    this.messageTrial = '',
    this.buttonText = 'Continuar',
  });

  factory PlanActions.fromJson(Map<String, dynamic> json) => _$PlanActionsFromJson(json);

  final bool showBuy;
  final bool showRenew;
  final bool showCancel;
  final bool errorRenewSubscription;
  final double priceDiscount;
  final double porcentageDiscount;
  final String messageDiscount;
  final String messageTrial;
  final String buttonText;

  Map<String, dynamic> toJson() => _$PlanActionsToJson(this);

  @override
  List<Object?> get props => <Object?>[
    showBuy,
    showRenew,
    showCancel,
    errorRenewSubscription,
    priceDiscount,
    porcentageDiscount,
    messageDiscount,
    messageTrial,
    buttonText,
  ];
}

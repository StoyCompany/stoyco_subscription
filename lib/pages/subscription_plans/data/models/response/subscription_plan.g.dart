// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      currencySymbol: json['currencySymbol'] as String,
      actions: PlanActions.fromJson(json['actions'] as Map<String, dynamic>),
      recommended: json['recommended'] as bool? ?? false,
      userStatus: json['userStatus'] == null
          ? null
          : UserStatus.fromJson(json['userStatus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubscriptionPlanToJson(SubscriptionPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'price': instance.price,
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
      'recommended': instance.recommended,
      'userStatus': instance.userStatus,
      'actions': instance.actions,
    };

UserStatus _$UserStatusFromJson(Map<String, dynamic> json) => UserStatus(
  isSubscribed: json['isSubscribed'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? false,
  isPendingActivation: json['isPendingActivation'] as bool? ?? false,
  isCurrent: json['isCurrent'] as bool? ?? false,
  messageSubscriptionStatus: json['messageSubscriptionStatus'] as String? ?? '',
  subscribedAt: json['subscribedAt'] == null
      ? null
      : DateTime.parse(json['subscribedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  trialStart: json['trialStart'] == null
      ? null
      : DateTime.parse(json['trialStart'] as String),
  trialEnd: json['trialEnd'] == null
      ? null
      : DateTime.parse(json['trialEnd'] as String),
  platform: json['platform'] as String? ?? '',
);

Map<String, dynamic> _$UserStatusToJson(UserStatus instance) =>
    <String, dynamic>{
      'isSubscribed': instance.isSubscribed,
      'isActive': instance.isActive,
      'isPendingActivation': instance.isPendingActivation,
      'isCurrent': instance.isCurrent,
      'messageSubscriptionStatus': instance.messageSubscriptionStatus,
      'subscribedAt': instance.subscribedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'trialStart': instance.trialStart?.toIso8601String(),
      'trialEnd': instance.trialEnd?.toIso8601String(),
      'platform': instance.platform,
    };

PlanActions _$PlanActionsFromJson(Map<String, dynamic> json) => PlanActions(
  showBuy: json['showBuy'] as bool? ?? false,
  showRenew: json['showRenew'] as bool? ?? false,
  showCancel: json['showCancel'] as bool? ?? false,
  errorRenewSubscription: json['errorRenewSubscription'] as bool? ?? false,
  priceDiscount: (json['priceDiscount'] as num?)?.toDouble() ?? 0.0,
  porcentageDiscount: (json['porcentageDiscount'] as num?)?.toDouble() ?? 0.0,
  messageDiscount: json['messageDiscount'] as String? ?? '',
  messageTrial: json['messageTrial'] as String? ?? '',
  buttonText: json['buttonText'] as String? ?? 'Continuar',
);

Map<String, dynamic> _$PlanActionsToJson(PlanActions instance) =>
    <String, dynamic>{
      'showBuy': instance.showBuy,
      'showRenew': instance.showRenew,
      'showCancel': instance.showCancel,
      'errorRenewSubscription': instance.errorRenewSubscription,
      'priceDiscount': instance.priceDiscount,
      'porcentageDiscount': instance.porcentageDiscount,
      'messageDiscount': instance.messageDiscount,
      'messageTrial': instance.messageTrial,
      'buttonText': instance.buttonText,
    };

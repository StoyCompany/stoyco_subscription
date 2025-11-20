// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlan _$SubscriptionPlanFromJson(
  Map<String, dynamic> json,
) => SubscriptionPlan(
  id: json['id'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  currencyCode: json['currencyCode'] as String,
  currencySymbol: json['currencySymbol'] as String,
  subscribed: json['subscribed'] as bool? ?? false,
  subscribedIsActive: json['subscribedIsActive'] as bool? ?? false,
  subscribedIsPendingActivation:
      json['subscribedIsPendingActivation'] as bool? ?? false,
  isCurrentPlan: json['isCurrentPlan'] as bool? ?? false,
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
  recommended: json['recommended'] as bool? ?? false,
  priceDiscount: (json['priceDiscount'] as num?)?.toDouble() ?? 0.0,
  porcentageDiscount: (json['porcentageDiscount'] as num?)?.toDouble() ?? 0.0,
  errorRenewSubscription: json['errorRenewSubscription'] as bool? ?? false,
  messageDiscount: json['messageDiscount'] as String? ?? '',
  messageSuscriptionStatus: json['messageSuscriptionStatus'] as String? ?? '',
  messageTrial: json['messageTrial'] as String? ?? '',
  showBuy: json['showBuy'] as bool? ?? false,
  showCancel: json['showCancel'] as bool? ?? false,
  showRenew: json['showRenew'] as bool? ?? false,
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
      'subscribed': instance.subscribed,
      'subscribedIsActive': instance.subscribedIsActive,
      'subscribedIsPendingActivation': instance.subscribedIsPendingActivation,
      'subscribedAt': instance.subscribedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'trialStart': instance.trialStart?.toIso8601String(),
      'trialEnd': instance.trialEnd?.toIso8601String(),
      'recommended': instance.recommended,
      'priceDiscount': instance.priceDiscount,
      'porcentageDiscount': instance.porcentageDiscount,
      'messageDiscount': instance.messageDiscount,
      'messageSuscriptionStatus': instance.messageSuscriptionStatus,
      'messageTrial': instance.messageTrial,
      'isCurrentPlan': instance.isCurrentPlan,
      'errorRenewSubscription': instance.errorRenewSubscription,
      'showBuy': instance.showBuy,
      'showCancel': instance.showCancel,
      'showRenew': instance.showRenew,
    };

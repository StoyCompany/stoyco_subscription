// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    SubscriptionPlan(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      subscribed: json['subscribed'] as bool,
      isActive: json['isActive'] as bool? ?? false,
      subscribedAt: json['subscribedAt'] == null
          ? null
          : DateTime.parse(json['subscribedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      recommended: json['recommended'] as bool? ?? false,
      priceDiscount: (json['priceDiscount'] as num?)?.toDouble() ?? 0.0,
      porcentageDiscount:
          (json['porcentageDiscount'] as num?)?.toDouble() ?? 0.0,
      messageDiscount: json['messageDiscount'] as String? ?? '',
    );

Map<String, dynamic> _$SubscriptionPlanToJson(SubscriptionPlan instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'price': instance.price,
      'currencyCode': instance.currencyCode,
      'subscribed': instance.subscribed,
      'isActive': instance.isActive,
      'subscribedAt': instance.subscribedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'recommended': instance.recommended,
      'priceDiscount': instance.priceDiscount,
      'porcentageDiscount': instance.porcentageDiscount,
      'messageDiscount': instance.messageDiscount,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_is_active_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionIsActiveResponse _$SubscriptionIsActiveResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionIsActiveResponse(
  planId: json['planId'] as String,
  planName: json['planName'] as String,
  planImageUrl: json['planImageUrl'] as String,
  partnerProfile: json['partnerProfile'] as String,
  partnerName: json['partnerName'] as String,
  partnerId: json['partnerId'] as String,
  recurrenceType: json['recurrenceType'] as String,
  price: json['price'] as num,
  currencyCode: json['currencyCode'] as String,
  currencySymbol: json['currencySymbol'] as String,
  subscribedIsActive: json['subscribedIsActive'] as bool,
  subscriptionStartDate: json['subscriptionStartDate'] as String,
  subscriptionEndDate: json['subscriptionEndDate'] as String,
  hasActivePlan: json['hasActivePlan'] as bool,
);

Map<String, dynamic> _$SubscriptionIsActiveResponseToJson(
  SubscriptionIsActiveResponse instance,
) => <String, dynamic>{
  'planId': instance.planId,
  'planName': instance.planName,
  'planImageUrl': instance.planImageUrl,
  'partnerProfile': instance.partnerProfile,
  'partnerName': instance.partnerName,
  'partnerId': instance.partnerId,
  'recurrenceType': instance.recurrenceType,
  'price': instance.price,
  'currencyCode': instance.currencyCode,
  'currencySymbol': instance.currencySymbol,
  'subscribedIsActive': instance.subscribedIsActive,
  'subscriptionStartDate': instance.subscriptionStartDate,
  'subscriptionEndDate': instance.subscriptionEndDate,
  'hasActivePlan': instance.hasActivePlan,
};

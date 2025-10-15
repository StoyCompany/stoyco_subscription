// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionHistoryResponse _$SubscriptionHistoryResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionHistoryResponse(
  error: (json['error'] as num).toInt(),
  messageError: json['messageError'] as String,
  tecMessageError: json['tecMessageError'] as String,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => SubscriptionHistoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubscriptionHistoryResponseToJson(
  SubscriptionHistoryResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'messageError': instance.messageError,
  'tecMessageError': instance.tecMessageError,
  'count': instance.count,
  'data': instance.data,
};

SubscriptionHistoryItem _$SubscriptionHistoryItemFromJson(
  Map<String, dynamic> json,
) => SubscriptionHistoryItem(
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

Map<String, dynamic> _$SubscriptionHistoryItemToJson(
  SubscriptionHistoryItem instance,
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

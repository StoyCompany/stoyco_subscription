// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_modification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModificationRequest _$SubscriptionModificationRequestFromJson(
  Map<String, dynamic> json,
) => SubscriptionModificationRequest(
  planId: json['planId'] as String,
  planRecurrence: json['planRecurrence'] as String,
);

Map<String, dynamic> _$SubscriptionModificationRequestToJson(
  SubscriptionModificationRequest instance,
) => <String, dynamic>{
  'planId': instance.planId,
  'planRecurrence': instance.planRecurrence,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_method_modification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionMethodModificationRequest
_$SubscriptionMethodModificationRequestFromJson(Map<String, dynamic> json) =>
    SubscriptionMethodModificationRequest(
      planId: json['planId'] as String,
      planRecurrence: json['planRecurrence'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$SubscriptionMethodModificationRequestToJson(
  SubscriptionMethodModificationRequest instance,
) => <String, dynamic>{
  'planId': instance.planId,
  'planRecurrence': instance.planRecurrence,
  'paymentMethodId': instance.paymentMethodId,
};

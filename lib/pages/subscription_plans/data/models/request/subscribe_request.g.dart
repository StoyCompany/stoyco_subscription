// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeRequest _$SubscribeRequestFromJson(Map<String, dynamic> json) =>
    SubscribeRequest(
      planId: json['planId'] as String,
      planRecurrence: json['planRecurrence'] as String,
      isAutomatic: json['isAutomatic'] as bool,
      paymentMethodId: json['paymentMethodId'] as String?,
      setupIntentId: json['setupIntentId'] as String?,
    );

Map<String, dynamic> _$SubscribeRequestToJson(SubscribeRequest instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'planRecurrence': instance.planRecurrence,
      'isAutomatic': instance.isAutomatic,
      'paymentMethodId': instance.paymentMethodId,
      'setupIntentId': instance.setupIntentId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_for_app_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeForAppRequest _$SubscribeForAppRequestFromJson(
  Map<String, dynamic> json,
) => SubscribeForAppRequest(
  planId: json['planId'] as String,
  planRecurrence: json['planRecurrence'] as String,
  platform: json['platform'] as String,
  appVersion: json['appVersion'] as String,
  storeIdentifier: json['storeIdentifier'] as String,
  transactionIdentifier: json['transactionIdentifier'] as String,
  productIdentifier: json['productIdentifier'] as String,
  purchaseDate: json['purchaseDate'] as String,
);

Map<String, dynamic> _$SubscribeForAppRequestToJson(
  SubscribeForAppRequest instance,
) => <String, dynamic>{
  'planId': instance.planId,
  'planRecurrence': instance.planRecurrence,
  'platform': instance.platform,
  'appVersion': instance.appVersion,
  'storeIdentifier': instance.storeIdentifier,
  'transactionIdentifier': instance.transactionIdentifier,
  'productIdentifier': instance.productIdentifier,
  'purchaseDate': instance.purchaseDate,
};

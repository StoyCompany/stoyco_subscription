// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lowest_price_plan_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LowestPricePlanResponseModel _$LowestPricePlanResponseModelFromJson(
  Map<String, dynamic> json,
) => LowestPricePlanResponseModel(
  id: json['id'] as String?,
  partnerId: json['partnerId'] as String?,
  name: json['name'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  currencyCode: json['currencyCode'] as String?,
  currencySymbol: json['currencySymbol'] as String?,
);

Map<String, dynamic> _$LowestPricePlanResponseModelToJson(
  LowestPricePlanResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'partnerId': instance.partnerId,
  'name': instance.name,
  'amount': instance.amount,
  'currencyCode': instance.currencyCode,
  'currencySymbol': instance.currencySymbol,
};

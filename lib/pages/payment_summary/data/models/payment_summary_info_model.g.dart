// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummaryInfoModel _$PaymentSummaryInfoModelFromJson(
  Map<String, dynamic> json,
) => PaymentSummaryInfoModel(
  planName: json['planName'] as String,
  totalPrice: (json['totalPrice'] as num).toDouble(),
  shortDescription: json['shortDescription'] as String,
  startDate: json['startDate'] as String,
  planPrice: (json['planPrice'] as num).toDouble(),
  iva: (json['iva'] as num).toDouble(),
  currencySymbol: json['currencySymbol'] as String,
  currencyCode: json['currencyCode'] as String,
);

Map<String, dynamic> _$PaymentSummaryInfoModelToJson(
  PaymentSummaryInfoModel instance,
) => <String, dynamic>{
  'planName': instance.planName,
  'totalPrice': instance.totalPrice,
  'shortDescription': instance.shortDescription,
  'startDate': instance.startDate,
  'planPrice': instance.planPrice,
  'iva': instance.iva,
  'currencySymbol': instance.currencySymbol,
  'currencyCode': instance.currencyCode,
};

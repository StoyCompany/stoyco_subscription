// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_symmary_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummaryInfoResponse _$PaymentSummaryInfoResponseFromJson(
  Map<String, dynamic> json,
) => PaymentSummaryInfoResponse(
  title: json['title'] as String,
  formattedPrice: json['formattedPrice'] as String,
  trialSubtitle: json['trialSubtitle'] as String,
  paymentStartNote: json['paymentStartNote'] as String,
  breakdown: PaymentBreakdown.fromJson(
    json['breakdown'] as Map<String, dynamic>,
  ),
  formattedTotal: json['formattedTotal'] as String,
);

Map<String, dynamic> _$PaymentSummaryInfoResponseToJson(
  PaymentSummaryInfoResponse instance,
) => <String, dynamic>{
  'title': instance.title,
  'formattedPrice': instance.formattedPrice,
  'trialSubtitle': instance.trialSubtitle,
  'paymentStartNote': instance.paymentStartNote,
  'breakdown': instance.breakdown.toJson(),
  'formattedTotal': instance.formattedTotal,
};

PaymentBreakdown _$PaymentBreakdownFromJson(Map<String, dynamic> json) =>
    PaymentBreakdown(
      planDescription: json['planDescription'] as String,
      planAmount: (json['planAmount'] as num).toDouble(),
      ivaAmount: (json['ivaAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      currencySymbol: json['currencySymbol'] as String,
    );

Map<String, dynamic> _$PaymentBreakdownToJson(PaymentBreakdown instance) =>
    <String, dynamic>{
      'planDescription': instance.planDescription,
      'planAmount': instance.planAmount,
      'ivaAmount': instance.ivaAmount,
      'totalAmount': instance.totalAmount,
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
    };

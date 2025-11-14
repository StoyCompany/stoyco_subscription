// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      paymentMethodId: json['paymentMethodId'] as String?,
      brand: json['brand'] as String?,
      last5: json['last5'] as String?,
      paymentCardType: $enumDecodeNullable(
        _$PaymentCardTypeEnumMap,
        json['paymentCardType'],
      ),
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
      'brand': instance.brand,
      'last5': instance.last5,
      'paymentCardType': _$PaymentCardTypeEnumMap[instance.paymentCardType],
    };

const _$PaymentCardTypeEnumMap = {
  PaymentCardType.visa: 'visa',
  PaymentCardType.mastercard: 'mastercard',
  PaymentCardType.americanExpress: 'americanExpress',
  PaymentCardType.discover: 'discover',
  PaymentCardType.dinersClub14: 'dinersClub14',
  PaymentCardType.dinersClub: 'dinersClub',
  PaymentCardType.bccard: 'bccard',
  PaymentCardType.dinacard: 'dinacard',
  PaymentCardType.jcb: 'jcb',
  PaymentCardType.unionPay: 'unionPay',
  PaymentCardType.unknown: 'unknown',
};

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_card_type.dart';

part 'payment_method_model.g.dart';

@JsonSerializable()
class PaymentMethodModel extends Equatable {
  const PaymentMethodModel({
    this.paymentMethodId,
    this.brand,
    this.last5,
    this.paymentCardType,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  final String? paymentMethodId;
  final String? brand;
  final String? last5;
  final PaymentCardType? paymentCardType;

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
    paymentMethodId,
    brand,
    last5,
    paymentCardType,
  ];
}

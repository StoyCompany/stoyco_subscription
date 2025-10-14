import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_card_type.dart';

part 'payment_method_model.g.dart';

/// {@template payment_method_model}
/// Model representing a user's payment method, such as a credit or debit card.
///
/// This model includes the payment method's unique ID, brand, last digits, and card type.
/// It supports JSON serialization and value equality.
/// {@endtemplate}
@JsonSerializable()
class PaymentMethodModel extends Equatable {
  /// {@macro payment_method_model}
  const PaymentMethodModel({
    this.paymentMethodId,
    this.brand,
    this.last5,
    this.paymentCardType,
  });

  /// Creates a [PaymentMethodModel] from a JSON map.
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  /// Unique identifier for the payment method.
  final String? paymentMethodId;

  /// Brand of the payment method (e.g., Visa, Mastercard).
  final String? brand;

  /// Last five digits of the card number.
  final String? last5;

  /// The type of the payment card.
  final PaymentCardType? paymentCardType;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
    paymentMethodId,
    brand,
    last5,
    paymentCardType,
  ];
}

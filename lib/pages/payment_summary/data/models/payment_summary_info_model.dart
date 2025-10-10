import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_summary_info_model.g.dart';

@JsonSerializable()
class PaymentSummaryInfoModel extends Equatable {
  final String planName;
  final double totalPrice;
  final String shortDescription;
  final String startDate;
  final double planPrice;
  final double iva;
  final String currencySymbol;
  final String currencyCode;

  const PaymentSummaryInfoModel({
    required this.planName,
    required this.totalPrice,
    required this.shortDescription,
    required this.startDate,
    required this.planPrice,
    required this.iva,
    required this.currencySymbol,
    required this.currencyCode,
  });

  factory PaymentSummaryInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSummaryInfoModelToJson(this);

  @override
  List<Object?> get props => [
    planName,
    totalPrice,
    shortDescription,
    startDate,
    planPrice,
    iva,
    currencySymbol,
    currencyCode,
  ];
}

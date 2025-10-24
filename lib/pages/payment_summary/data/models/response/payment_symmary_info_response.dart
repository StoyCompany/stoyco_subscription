import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_symmary_info_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentSummaryInfoResponse extends Equatable {
  const PaymentSummaryInfoResponse({
    required this.title,
    required this.formattedPrice,
    required this.trialSubtitle,
    required this.paymentStartNote,
    required this.breakdown,
    required this.formattedTotal,
  });

  factory PaymentSummaryInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryInfoResponseFromJson(json);
  final String title;
  final String formattedPrice;
  final String trialSubtitle;
  final String paymentStartNote;
  final PaymentBreakdown breakdown;
  final String formattedTotal;

  Map<String, dynamic> toJson() => _$PaymentSummaryInfoResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[
    title,
    formattedPrice,
    trialSubtitle,
    paymentStartNote,
    breakdown,
    formattedTotal,
  ];
}

@JsonSerializable()
class PaymentBreakdown extends Equatable {
  const PaymentBreakdown({
    required this.planDescription,
    required this.planAmount,
    required this.ivaAmount,
    required this.totalAmount,
    required this.currencyCode,
    required this.currencySymbol,
  });

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PaymentBreakdownFromJson(json);
  final String planDescription;
  final double planAmount;
  final double ivaAmount;
  final double totalAmount;
  final String currencyCode;
  final String currencySymbol;

  Map<String, dynamic> toJson() => _$PaymentBreakdownToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planDescription,
    planAmount,
    ivaAmount,
    totalAmount,
    currencyCode,
    currencySymbol,
  ];
}

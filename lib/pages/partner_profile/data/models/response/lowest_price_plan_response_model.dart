import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lowest_price_plan_response_model.g.dart';

@JsonSerializable()
class LowestPricePlanResponseModel extends Equatable {
  const LowestPricePlanResponseModel({
     this.id,
     this.partnerId,
     this.name,
     this.amount,
     this.currencyCode,
     this.currencySymbol,
  });

  factory LowestPricePlanResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LowestPricePlanResponseModelFromJson(json);
  final String? id;
  final String? partnerId;
  final String? name;
  final double? amount;
  final String? currencyCode;
  final String? currencySymbol;

  Map<String, dynamic> toJson() => _$LowestPricePlanResponseModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
    id,
    partnerId,
    name,
    amount,
    currencyCode,
    currencySymbol,
  ];
}

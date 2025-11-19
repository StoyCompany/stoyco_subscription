import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscribe_request.g.dart';

@JsonSerializable()
class SubscribeRequest extends Equatable {

  const SubscribeRequest({
    required this.planId,
    required this.planRecurrence,
    required this.isAutomatic,
    required this.paymentMethodId,
  });

  factory SubscribeRequest.fromJson(Map<String, dynamic> json) => _$SubscribeRequestFromJson(json);

  final String planId;

  final String planRecurrence;

  final bool isAutomatic;

  final String paymentMethodId;
  
  Map<String, dynamic> toJson() => _$SubscribeRequestToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planId,
    planRecurrence,
    isAutomatic,
    paymentMethodId,
  ];
}


import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_method_modification_request.g.dart';

@JsonSerializable()
class SubscriptionMethodModificationRequest extends Equatable {

  const SubscriptionMethodModificationRequest({
    required this.planId,
    required this.paymentMethodId,
  });

  factory SubscriptionMethodModificationRequest.fromJson(Map<String, dynamic> json) => _$SubscriptionMethodModificationRequestFromJson(json);

  final String planId;
  final String paymentMethodId;
  
  @override
  List<Object?> get props => <Object?>[
    planId,
    paymentMethodId,
  ];

  Map<String, dynamic> toJson() => _$SubscriptionMethodModificationRequestToJson(this);
}

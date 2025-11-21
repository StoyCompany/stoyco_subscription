import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_modification_request.g.dart';

@JsonSerializable()
class SubscriptionModificationRequest extends Equatable {

  const SubscriptionModificationRequest({
    required this.planId,
    required this.planRecurrence,
  });

  factory SubscriptionModificationRequest.fromJson(Map<String, dynamic> json) => _$SubscriptionModificationRequestFromJson(json);

  final String planId;

  final String planRecurrence;
  
  Map<String, dynamic> toJson() => _$SubscriptionModificationRequestToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planId,
    planRecurrence,
  ];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_is_active_response.g.dart';

@JsonSerializable()
class SubscriptionIsActiveResponse extends Equatable {
  const SubscriptionIsActiveResponse({
    required this.planId,
    required this.planName,
    required this.planImageUrl,
    required this.partnerProfile,
    required this.partnerName,
    required this.partnerId,
    required this.recurrenceType,
    required this.price,
    required this.currencyCode,
    required this.currencySymbol,
    required this.subscribedIsActive,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.hasActivePlan,
  });

  factory SubscriptionIsActiveResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionIsActiveResponseFromJson(json);
  final String planId;
  final String planName;
  final String planImageUrl;
  final String partnerProfile;
  final String partnerName;
  final String partnerId;
  final String recurrenceType;
  final num price;
  final String currencyCode;
  final String currencySymbol;
  final bool subscribedIsActive;
  final String subscriptionStartDate;
  final String subscriptionEndDate;
  final bool hasActivePlan;

  Map<String, dynamic> toJson() => _$SubscriptionIsActiveResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planId,
    planName,
    planImageUrl,
    partnerProfile,
    partnerName,
    partnerId,
    recurrenceType,
    price,
    currencyCode,
    currencySymbol,
    subscribedIsActive,
    subscriptionStartDate,
    subscriptionEndDate,
    hasActivePlan,
  ];
}

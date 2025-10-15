import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_history_response.g.dart';

/// Model for the subscription history response.
@JsonSerializable()
class SubscriptionHistoryResponse extends Equatable {
  final int error;
  final String messageError;
  final String tecMessageError;
  final int count;
  final List<SubscriptionHistoryItem> data;

  const SubscriptionHistoryResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  factory SubscriptionHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionHistoryResponseToJson(this);

  @override
  List<Object?> get props => [
        error,
        messageError,
        tecMessageError,
        count,
        data,
      ];
}

/// Model for a single subscription history item.
@JsonSerializable()
class SubscriptionHistoryItem extends Equatable {
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

  const SubscriptionHistoryItem({
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

  factory SubscriptionHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionHistoryItemToJson(this);

  @override
  List<Object?> get props => [
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



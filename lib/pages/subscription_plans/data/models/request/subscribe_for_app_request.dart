import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscribe_for_app_request.g.dart';

@JsonSerializable()
class SubscribeForAppRequest extends Equatable {

  const SubscribeForAppRequest({
    required this.planId,
    required this.planRecurrence,
    required this.platform,
    required this.appVersion,
    required this.storeIdentifier,
    required this.transactionIdentifier,
    required this.productIdentifier,
    required this.purchaseDate,
  });

  factory SubscribeForAppRequest.fromJson(Map<String, dynamic> json) => _$SubscribeForAppRequestFromJson(json);

  final String planId;

  final String planRecurrence;

  final String platform;

  final String appVersion;

  final String storeIdentifier;

  final String transactionIdentifier;

  final String productIdentifier;

  final String purchaseDate;

  
  Map<String, dynamic> toJson() => _$SubscribeForAppRequestToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planId,
    planRecurrence,
    platform,
    appVersion,
    storeIdentifier,
    transactionIdentifier,
    productIdentifier,
    purchaseDate,
  ];
}

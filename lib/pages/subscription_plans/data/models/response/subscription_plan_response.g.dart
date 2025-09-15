// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlanResponse _$SubscriptionPlanResponseFromJson(
  Map<String, dynamic> json,
) => SubscriptionPlanResponse(
  partnerID: json['partnerID'] as String,
  partnerName: json['partnerName'] as String,
  monthlyPlans: (json['monthlyPlans'] as List<dynamic>)
      .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
      .toList(),
  annualPlans: (json['annualPlans'] as List<dynamic>)
      .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SubscriptionPlanResponseToJson(
  SubscriptionPlanResponse instance,
) => <String, dynamic>{
  'partnerID': instance.partnerID,
  'partnerName': instance.partnerName,
  'monthlyPlans': instance.monthlyPlans,
  'annualPlans': instance.annualPlans,
};

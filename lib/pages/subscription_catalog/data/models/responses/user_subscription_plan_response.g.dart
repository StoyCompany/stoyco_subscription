// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscription_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSubscriptionPlanResponse _$UserSubscriptionPlanResponseFromJson(
  Map<String, dynamic> json,
) => UserSubscriptionPlanResponse(
  error: (json['error'] as num).toInt(),
  messageError: json['messageError'] as String,
  tecMessageError: json['tecMessageError'] as String,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => UserSubscriptionPlan.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserSubscriptionPlanResponseToJson(
  UserSubscriptionPlanResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'messageError': instance.messageError,
  'tecMessageError': instance.tecMessageError,
  'count': instance.count,
  'data': instance.data,
};

UserSubscriptionPlan _$UserSubscriptionPlanFromJson(
  Map<String, dynamic> json,
) => UserSubscriptionPlan(
  planName: json['planName'] as String,
  planImageUrl: json['planImageUrl'] as String,
  partnerName: json['partnerName'] as String,
  partnerProfile: json['partnerProfile'] as String,
  recurrenceType: json['recurrenceType'] as String,
  price: (json['price'] as num).toDouble(),
  subscriptionStartDate: DateTime.parse(
    json['subscriptionStartDate'] as String,
  ),
  subscriptionEndDate: DateTime.parse(json['subscriptionEndDate'] as String),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$UserSubscriptionPlanToJson(
  UserSubscriptionPlan instance,
) => <String, dynamic>{
  'planName': instance.planName,
  'planImageUrl': instance.planImageUrl,
  'partnerName': instance.partnerName,
  'partnerProfile': instance.partnerProfile,
  'recurrenceType': instance.recurrenceType,
  'price': instance.price,
  'subscriptionStartDate': instance.subscriptionStartDate.toIso8601String(),
  'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
  'isActive': instance.isActive,
};

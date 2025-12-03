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
  planId: json['planId'] as String,
  planName: json['planName'] as String,
  planImageUrl: json['planImageUrl'] as String,
  partnerProfile: json['partnerProfile'] as String,
  partnerName: json['partnerName'] as String,
  partnerId: json['partnerId'] as String,
  recurrenceType: json['recurrenceType'] as String,
  price: json['price'] as num,
  currencyCode: json['currencyCode'] as String,
  currencySymbol: json['currencySymbol'] as String,
  planStatus: UserSubscriptionPlan._subscriptionStatusFromJson(
    json['planStatus'] as String,
  ),
  subscriptionStartDate: json['subscriptionStartDate'] as String,
  subscriptionEndDate: json['subscriptionEndDate'] as String,
  hasActivePlan: json['hasActivePlan'] as bool,
  planIsDeleted: json['planIsDeleted'] as bool,
);

Map<String, dynamic> _$UserSubscriptionPlanToJson(
  UserSubscriptionPlan instance,
) => <String, dynamic>{
  'planId': instance.planId,
  'planName': instance.planName,
  'planImageUrl': instance.planImageUrl,
  'partnerProfile': instance.partnerProfile,
  'partnerName': instance.partnerName,
  'partnerId': instance.partnerId,
  'recurrenceType': instance.recurrenceType,
  'price': instance.price,
  'currencyCode': instance.currencyCode,
  'currencySymbol': instance.currencySymbol,
  'planStatus': UserSubscriptionPlan._subscriptionStatusToJson(
    instance.planStatus,
  ),
  'subscriptionStartDate': instance.subscriptionStartDate,
  'subscriptionEndDate': instance.subscriptionEndDate,
  'hasActivePlan': instance.hasActivePlan,
  'planIsDeleted': instance.planIsDeleted,
};

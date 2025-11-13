// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_user_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveUserPlanResponse _$ActiveUserPlanResponseFromJson(
  Map<String, dynamic> json,
) => ActiveUserPlanResponse(
  error: (json['error'] as num).toInt(),
  messageError: json['messageError'] as String,
  tecMessageError: json['tecMessageError'] as String,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => ActiveUserPlan.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ActiveUserPlanResponseToJson(
  ActiveUserPlanResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'messageError': instance.messageError,
  'tecMessageError': instance.tecMessageError,
  'count': instance.count,
  'data': instance.data,
};

ActiveUserPlan _$ActiveUserPlanFromJson(Map<String, dynamic> json) =>
    ActiveUserPlan(
      id: json['_id'] as String,
      plan: PlanInfo.fromJson(json['plan'] as Map<String, dynamic>),
      partnerId: json['partnerId'] as String,
      userId: json['userId'] as String,
      recurrence: json['recurrence'] as String,
      subscribedAt: DateTime.parse(json['subscribedAt'] as String),
      isActive: json['isActive'] as bool,
      trialStartDate: json['trialStartDate'] == null
          ? null
          : DateTime.parse(json['trialStartDate'] as String),
      trialEndDate: json['trialEndDate'] == null
          ? null
          : DateTime.parse(json['trialEndDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$ActiveUserPlanToJson(ActiveUserPlan instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'plan': instance.plan,
      'partnerId': instance.partnerId,
      'userId': instance.userId,
      'recurrence': instance.recurrence,
      'subscribedAt': instance.subscribedAt.toIso8601String(),
      'isActive': instance.isActive,
      'trialStartDate': instance.trialStartDate?.toIso8601String(),
      'trialEndDate': instance.trialEndDate?.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
    };

PlanInfo _$PlanInfoFromJson(Map<String, dynamic> json) => PlanInfo(
  id: json['id'] as String,
  name: json['name'] as String,
  isDeleted: json['isDeleted'] as bool,
  accesses: (json['accesses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PlanInfoToJson(PlanInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isDeleted': instance.isDeleted,
  'accesses': instance.accesses,
};

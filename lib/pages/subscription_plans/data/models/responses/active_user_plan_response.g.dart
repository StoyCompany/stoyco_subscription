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
      plan: PlanInfo.fromJson(json['Plan'] as Map<String, dynamic>),
      partnerId: json['Partner_id'] as String,
      userId: json['User_id'] as String,
      recurrence: json['Recurrence'] as String,
      subscribedAt: DateTime.parse(json['Subscribed_at'] as String),
      isActive: json['Is_active'] as bool,
      trialStartDate: json['Trial_start_date'] == null
          ? null
          : DateTime.parse(json['Trial_start_date'] as String),
      trialEndDate: json['Trial_end_date'] == null
          ? null
          : DateTime.parse(json['Trial_end_date'] as String),
      endDate: DateTime.parse(json['End_date'] as String),
      createdAt: DateTime.parse(json['Created_at'] as String),
      modifiedAt: DateTime.parse(json['Modified_at'] as String),
    );

Map<String, dynamic> _$ActiveUserPlanToJson(ActiveUserPlan instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'Plan': instance.plan,
      'Partner_id': instance.partnerId,
      'User_id': instance.userId,
      'Recurrence': instance.recurrence,
      'Subscribed_at': instance.subscribedAt.toIso8601String(),
      'Is_active': instance.isActive,
      'Trial_start_date': instance.trialStartDate?.toIso8601String(),
      'Trial_end_date': instance.trialEndDate?.toIso8601String(),
      'End_date': instance.endDate.toIso8601String(),
      'Created_at': instance.createdAt.toIso8601String(),
      'Modified_at': instance.modifiedAt.toIso8601String(),
    };

PlanInfo _$PlanInfoFromJson(Map<String, dynamic> json) => PlanInfo(
  id: json['_id'] as String,
  name: json['Name'] as String,
  isDeleted: json['Is_deleted'] as bool,
  accesses: (json['Accesses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PlanInfoToJson(PlanInfo instance) => <String, dynamic>{
  '_id': instance.id,
  'Name': instance.name,
  'Is_deleted': instance.isDeleted,
  'Accesses': instance.accesses,
};

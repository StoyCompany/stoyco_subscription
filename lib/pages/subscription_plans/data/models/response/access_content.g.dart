// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessContent _$AccessContentFromJson(Map<String, dynamic> json) =>
    AccessContent(
      contentId: json['contentId'] as String?,
      partnerId: json['partnerId'] as String?,
      planIds: (json['planIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visibleFrom: json['visibleFrom'] == null
          ? null
          : DateTime.parse(json['visibleFrom'] as String),
      visibleUntil: json['visibleUntil'] == null
          ? null
          : DateTime.parse(json['visibleUntil'] as String),
    );

Map<String, dynamic> _$AccessContentToJson(AccessContent instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'partnerId': instance.partnerId,
      'planIds': instance.planIds,
      'visibleFrom': instance.visibleFrom?.toIso8601String(),
      'visibleUntil': instance.visibleUntil?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessContent _$AccessContentFromJson(Map<String, dynamic> json) =>
    AccessContent(
      contentId: json['contentId'] == null
          ? ''
          : AccessContent._nullToEmptyString(json['contentId'] as String?),
      partnerId: json['partnerId'] == null
          ? ''
          : AccessContent._nullToEmptyString(json['partnerId'] as String?),
      planIds: json['planIds'] == null
          ? const []
          : AccessContent._nullToEmptyList(json['planIds'] as List?),
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

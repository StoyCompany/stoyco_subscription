// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerTime _$ServerTimeFromJson(Map<String, dynamic> json) => ServerTime(
  utcDateTime: DateTime.parse(json['utcDateTime'] as String),
  unixTimestamp: (json['unixTimestamp'] as num).toInt(),
  iso8601: json['iso8601'] as String,
);

Map<String, dynamic> _$ServerTimeToJson(ServerTime instance) =>
    <String, dynamic>{
      'utcDateTime': instance.utcDateTime.toIso8601String(),
      'unixTimestamp': instance.unixTimestamp,
      'iso8601': instance.iso8601,
    };

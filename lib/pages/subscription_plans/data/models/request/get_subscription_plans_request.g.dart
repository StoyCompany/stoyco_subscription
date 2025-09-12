// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_subscription_plans_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSubscriptionPlansRequest _$GetSubscriptionPlansRequestFromJson(
  Map<String, dynamic> json,
) => GetSubscriptionPlansRequest(
  idPartner: json['idPartner'] as String,
  idUser: json['idUser'] as String,
);

Map<String, dynamic> _$GetSubscriptionPlansRequestToJson(
  GetSubscriptionPlansRequest instance,
) => <String, dynamic>{
  'idPartner': instance.idPartner,
  'idUser': instance.idUser,
};

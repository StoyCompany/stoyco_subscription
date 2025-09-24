// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_catalog_item_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionCatalogItemMap _$SubscriptionCatalogItemMapFromJson(
  Map<String, dynamic> json,
) => SubscriptionCatalogItemMap(
  id: json['id'] as String,
  imageUrl: json['imageUrl'] as String,
  title: json['title'] as String,
  subscribed: json['subscribed'] as bool,
  partnerId: json['partnerId'] as String,
  profile: json['profile'] as String,
);

Map<String, dynamic> _$SubscriptionCatalogItemMapToJson(
  SubscriptionCatalogItemMap instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'subscribed': instance.subscribed,
  'partnerId': instance.partnerId,
  'profile': instance.profile,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_catalog_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionCatalogItem _$SubscriptionCatalogItemFromJson(
  Map<String, dynamic> json,
) => SubscriptionCatalogItem(
  id: json['id'] as String,
  imageUrl: json['imageUrl'] as String,
  title: json['title'] as String,
  subscribed: json['subscribed'] as bool,
);

Map<String, dynamic> _$SubscriptionCatalogItemToJson(
  SubscriptionCatalogItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'subscribed': instance.subscribed,
};

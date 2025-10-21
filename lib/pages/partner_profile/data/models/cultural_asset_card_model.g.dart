// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cultural_asset_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CulturalAssetCardModel _$CulturalAssetCardModelFromJson(
  Map<String, dynamic> json,
) => CulturalAssetCardModel(
  image: json['image'] as String,
  title: json['title'] as String,
  price: json['price'] as num,
  subscribersOnly: json['subscribersOnly'] as bool,
  hasAccess: json['hasAccess'] as bool?,
);

Map<String, dynamic> _$CulturalAssetCardModelToJson(
  CulturalAssetCardModel instance,
) => <String, dynamic>{
  'image': instance.image,
  'title': instance.title,
  'price': instance.price,
  'subscribersOnly': instance.subscribersOnly,
  'hasAccess': instance.hasAccess,
};

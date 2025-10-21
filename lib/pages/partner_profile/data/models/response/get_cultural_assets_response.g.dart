// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cultural_assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCulturalAssetsResponse _$GetCulturalAssetsResponseFromJson(
  Map<String, dynamic> json,
) => GetCulturalAssetsResponse(
  error: (json['error'] as num).toInt(),
  messageError: json['messageError'] as String,
  tecMessageError: json['tecMessageError'] as String,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => CulturalAssetItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetCulturalAssetsResponseToJson(
  GetCulturalAssetsResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'messageError': instance.messageError,
  'tecMessageError': instance.tecMessageError,
  'count': instance.count,
  'data': instance.data.map((e) => e.toJson()).toList(),
};

CulturalAssetItemModel _$CulturalAssetItemModelFromJson(
  Map<String, dynamic> json,
) => CulturalAssetItemModel(
  id: json['id'] as String?,
  web3CollectionId: json['web3CollectionId'] as String,
  collectionId: (json['collectionId'] as num).toInt(),
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  maxSupply: (json['maxSupply'] as num).toInt(),
  minted: (json['minted'] as num).toInt(),
  contractAddress: json['contractAddress'] as String,
  imageUri: json['imageUri'] as String,
  avatarBackgroundImageUri: json['avatarBackgroundImageUri'] as String?,
  artistOrBrandId: json['artistOrBrandId'] as String,
  artistOrBrandName: json['artistOrBrandName'] as String,
  communityId: json['communityId'] as String,
  experienceOrProductName: json['experienceOrProductName'] as String,
  isExclusive: json['isExclusive'] as bool,
  isSubscriberOnly: json['isSubscriberOnly'] as bool,
  isActive: json['isActive'] as bool,
  accessContent: json['accessContent'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CulturalAssetItemModelToJson(
  CulturalAssetItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'web3CollectionId': instance.web3CollectionId,
  'collectionId': instance.collectionId,
  'name': instance.name,
  'symbol': instance.symbol,
  'maxSupply': instance.maxSupply,
  'minted': instance.minted,
  'contractAddress': instance.contractAddress,
  'imageUri': instance.imageUri,
  'avatarBackgroundImageUri': instance.avatarBackgroundImageUri,
  'artistOrBrandId': instance.artistOrBrandId,
  'artistOrBrandName': instance.artistOrBrandName,
  'communityId': instance.communityId,
  'experienceOrProductName': instance.experienceOrProductName,
  'isExclusive': instance.isExclusive,
  'isSubscriberOnly': instance.isSubscriberOnly,
  'isActive': instance.isActive,
  'accessContent': instance.accessContent,
};

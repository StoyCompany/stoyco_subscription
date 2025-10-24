// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cultural_assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCulturalAssetsResponse _$GetCulturalAssetsResponseFromJson(
  Map<String, dynamic> json,
) => GetCulturalAssetsResponse(
  error: (json['error'] as num?)?.toInt(),
  messageError: json['messageError'] as String?,
  tecMessageError: json['tecMessageError'] as String?,
  count: (json['count'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CulturalAssetItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetCulturalAssetsResponseToJson(
  GetCulturalAssetsResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'messageError': instance.messageError,
  'tecMessageError': instance.tecMessageError,
  'count': instance.count,
  'data': instance.data?.map((e) => e.toJson()).toList(),
};

CulturalAssetItemModel _$CulturalAssetItemModelFromJson(
  Map<String, dynamic> json,
) => CulturalAssetItemModel(
  id: json['id'] as String?,
  web3CollectionId: json['web3CollectionId'] as String?,
  collectionId: (json['collectionId'] as num?)?.toInt(),
  name: json['name'] as String?,
  symbol: json['symbol'] as String?,
  maxSupply: (json['maxSupply'] as num?)?.toInt(),
  stock: (json['stock'] as num?)?.toInt(),
  stoyCoins: (json['stoyCoins'] as num?)?.toInt(),
  minted: (json['minted'] as num?)?.toInt(),
  contractAddress: json['contractAddress'] as String?,
  txHash: json['txHash'] as String?,
  metadataUri: json['metadataUri'] as String?,
  imageUri: json['imageUri'] as String?,
  avatarBackgroundImageUri: json['avatarBackgroundImageUri'] as String?,
  burned: json['burned'] as bool?,
  artistOrBrandId: json['artistOrBrandId'] as String?,
  artistOrBrandName: json['artistOrBrandName'] as String?,
  communityId: json['communityId'] as String?,
  experienceOrProductName: json['experienceOrProductName'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  isExclusive: json['isExclusive'] as bool?,
  isSubscriberOnly: json['isSubscriberOnly'] as bool?,
  hasAccess: json['hasAccess'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  accessContent: json['accessContent'] == null
      ? null
      : AccessContentModel.fromJson(
          json['accessContent'] as Map<String, dynamic>,
        ),
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
  'stock': instance.stock,
  'stoyCoins': instance.stoyCoins,
  'minted': instance.minted,
  'contractAddress': instance.contractAddress,
  'txHash': instance.txHash,
  'metadataUri': instance.metadataUri,
  'imageUri': instance.imageUri,
  'avatarBackgroundImageUri': instance.avatarBackgroundImageUri,
  'burned': instance.burned,
  'artistOrBrandId': instance.artistOrBrandId,
  'artistOrBrandName': instance.artistOrBrandName,
  'communityId': instance.communityId,
  'experienceOrProductName': instance.experienceOrProductName,
  'categories': instance.categories?.map((e) => e.toJson()).toList(),
  'isExclusive': instance.isExclusive,
  'isSubscriberOnly': instance.isSubscriberOnly,
  'hasAccess': instance.hasAccess,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'accessContent': instance.accessContent?.toJson(),
};

AccessContentModel _$AccessContentModelFromJson(Map<String, dynamic> json) =>
    AccessContentModel(
      id: json['id'] as String?,
      planIds: (json['planIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      contentType: json['contentType'] as String?,
      contentId: json['contentId'] as String?,
      visibleFrom: json['visibleFrom'] == null
          ? null
          : DateTime.parse(json['visibleFrom'] as String),
      visibleUntil: json['visibleUntil'] == null
          ? null
          : DateTime.parse(json['visibleUntil'] as String),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$AccessContentModelToJson(AccessContentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planIds': instance.planIds,
      'contentType': instance.contentType,
      'contentId': instance.contentId,
      'visibleFrom': instance.visibleFrom?.toIso8601String(),
      'visibleUntil': instance.visibleUntil?.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      benefits: (json['benefits'] as List<dynamic>?)
          ?.map((e) => BenefitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'benefits': instance.benefits?.map((e) => e.toJson()).toList(),
      'brands': instance.brands?.map((e) => e.toJson()).toList(),
    };

BenefitModel _$BenefitModelFromJson(Map<String, dynamic> json) => BenefitModel(
  type: json['type'] as String?,
  selected: json['selected'] as bool?,
);

Map<String, dynamic> _$BenefitModelToJson(BenefitModel instance) =>
    <String, dynamic>{'type': instance.type, 'selected': instance.selected};

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) =>
    BrandModel(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

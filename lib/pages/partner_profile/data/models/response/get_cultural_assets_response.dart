import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_cultural_assets_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetCulturalAssetsResponse extends Equatable {
  const GetCulturalAssetsResponse({
    this.error,
    this.messageError,
    this.tecMessageError,
    this.count,
    this.data,
  });
  factory GetCulturalAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCulturalAssetsResponseFromJson(json);
  final int? error;
  final String? messageError;
  final String? tecMessageError;
  final int? count;
  final List<CulturalAssetItemModel>? data;

  Map<String, dynamic> toJson() => _$GetCulturalAssetsResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[
    error,
    messageError,
    tecMessageError,
    count,
    data,
  ];
}

@JsonSerializable(explicitToJson: true)
class CulturalAssetItemModel extends Equatable {
  const CulturalAssetItemModel({
    this.id,
    this.web3CollectionId,
    this.collectionId,
    this.name,
    this.symbol,
    this.maxSupply,
    this.minted,
    this.contractAddress,
    this.txHash,
    this.metadataUri,
    this.imageUri,
    this.avatarBackgroundImageUri,
    this.burned,
    this.artistOrBrandId,
    this.artistOrBrandName,
    this.communityId,
    this.experienceOrProductName,
    this.categories,
    this.isExclusive,
    this.isSubscriberOnly,
    this.createdAt,
    this.updatedAt,
    this.accessContent,
  });
  factory CulturalAssetItemModel.fromJson(Map<String, dynamic> json) =>
      _$CulturalAssetItemModelFromJson(json);
  final String? id;
  final String? web3CollectionId;
  final int? collectionId;
  final String? name;
  final String? symbol;
  final int? maxSupply;
  final int? minted;
  final String? contractAddress;
  final String? txHash;
  final String? metadataUri;
  final String? imageUri;
  final String? avatarBackgroundImageUri;
  final bool? burned;
  final String? artistOrBrandId;
  final String? artistOrBrandName;
  final String? communityId;
  final String? experienceOrProductName;
  final List<CategoryModel>? categories;
  final bool? isExclusive;
  final bool? isSubscriberOnly;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AccessContentModel? accessContent;

  Map<String, dynamic> toJson() => _$CulturalAssetItemModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
    id,
    web3CollectionId,
    collectionId,
    name,
    symbol,
    maxSupply,
    minted,
    contractAddress,
    txHash,
    metadataUri,
    imageUri,
    avatarBackgroundImageUri,
    burned,
    artistOrBrandId,
    artistOrBrandName,
    communityId,
    experienceOrProductName,
    categories,
    isExclusive,
    isSubscriberOnly,
    createdAt,
    updatedAt,
    accessContent,
  ];
}

@JsonSerializable()
class AccessContentModel extends Equatable {
  const AccessContentModel({
    this.id,
    this.planIds,
    this.contentType,
    this.contentId,
    this.visibleFrom,
    this.visibleUntil,
    this.isActive,
    this.createdAt,
    this.modifiedAt,
  });

  factory AccessContentModel.fromJson(Map<String, dynamic> json) =>
      _$AccessContentModelFromJson(json);

  final String? id;
  final List<String>? planIds;
  final String? contentType;
  final String? contentId;
  final DateTime? visibleFrom;
  final DateTime? visibleUntil;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  Map<String, dynamic> toJson() => _$AccessContentModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    planIds,
    contentType,
    contentId,
    visibleFrom,
    visibleUntil,
    isActive,
    createdAt,
    modifiedAt,
  ];
}

@JsonSerializable(explicitToJson: true)
class CategoryModel extends Equatable {
  const CategoryModel({
    this.id,
    this.name,
    this.benefits,
    this.brands,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  final String? id;
  final String? name;
  final List<BenefitModel>? benefits;
  final List<BrandModel>? brands;

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  List<Object?> get props => [id, name, benefits, brands];
}

@JsonSerializable()
class BenefitModel extends Equatable {
  const BenefitModel({
    this.type,
    this.selected,
  });

  factory BenefitModel.fromJson(Map<String, dynamic> json) =>
      _$BenefitModelFromJson(json);

  final String? type;
  final bool? selected;

  Map<String, dynamic> toJson() => _$BenefitModelToJson(this);

  @override
  List<Object?> get props => [type, selected];
}

@JsonSerializable()
class BrandModel extends Equatable {
  const BrandModel({
    this.id,
    this.name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}

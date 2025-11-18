import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';

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
    this.stock,
    this.stoyCoins,
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
    this.createdAt,
    this.updatedAt,
    this.isSubscriberOnly = false,
    bool? hasAccess,
    this.accessContent,
  }) : hasAccess = hasAccess ?? !isSubscriberOnly;

  factory CulturalAssetItemModel.fromJson(Map<String, dynamic> json) => _$CulturalAssetItemModelFromJson(json);

  final String? id;
  final String? web3CollectionId;
  final int? collectionId;
  final String? name;
  final String? symbol;
  final int? maxSupply;
  final int? stock;
  final int? stoyCoins;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSubscriberOnly;
  /// This value is constructed in the frontend and is not mapped from backend JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool hasAccess;
  final AccessContent? accessContent;

  CulturalAssetItemModel copyWith({
    String? id,
    String? web3CollectionId,
    int? collectionId,
    String? name,
    String? symbol,
    int? maxSupply,
    int? stock,
    int? stoyCoins,
    int? minted,
    String? contractAddress,
    String? txHash,
    String? metadataUri,
    String? imageUri,
    String? avatarBackgroundImageUri,
    bool? burned,
    String? artistOrBrandId,
    String? artistOrBrandName,
    String? communityId,
    String? experienceOrProductName,
    List<CategoryModel>? categories,
    bool? isExclusive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSubscriberOnly,
    bool? hasAccess,
    AccessContent? accessContent,
  }) {
    return CulturalAssetItemModel(
      id: id ?? this.id,
      web3CollectionId: web3CollectionId ?? this.web3CollectionId,
      collectionId: collectionId ?? this.collectionId,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      maxSupply: maxSupply ?? this.maxSupply,
      stock: stock ?? this.stock,
      stoyCoins: stoyCoins ?? this.stoyCoins,
      minted: minted ?? this.minted,
      contractAddress: contractAddress ?? this.contractAddress,
      txHash: txHash ?? this.txHash,
      metadataUri: metadataUri ?? this.metadataUri,
      imageUri: imageUri ?? this.imageUri,
      avatarBackgroundImageUri: avatarBackgroundImageUri ?? this.avatarBackgroundImageUri,
      burned: burned ?? this.burned,
      artistOrBrandId: artistOrBrandId ?? this.artistOrBrandId,
      artistOrBrandName: artistOrBrandName ?? this.artistOrBrandName,
      communityId: communityId ?? this.communityId,
      experienceOrProductName: experienceOrProductName ?? this.experienceOrProductName,
      categories: categories ?? this.categories,
      isExclusive: isExclusive ?? this.isExclusive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSubscriberOnly: isSubscriberOnly ?? this.isSubscriberOnly,
      hasAccess: hasAccess ?? this.hasAccess,
      accessContent: accessContent ?? this.accessContent,
    );
  }

  Map<String, dynamic> toJson() => _$CulturalAssetItemModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
    id,
    web3CollectionId,
    collectionId,
    name,
    symbol,
    maxSupply,
    stock,
    stoyCoins,
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
    hasAccess,
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
  List<Object?> get props => <Object?>[
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
  const CategoryModel({this.id, this.name, this.benefits, this.brands});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  final String? id;
  final String? name;
  final List<BenefitModel>? benefits;
  final List<BrandModel>? brands;

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  List<Object?> get props => <Object?>[id, name, benefits, brands];
}

@JsonSerializable()
class BenefitModel extends Equatable {
  const BenefitModel({this.type, this.selected});

  factory BenefitModel.fromJson(Map<String, dynamic> json) =>
      _$BenefitModelFromJson(json);

  final String? type;
  final bool? selected;

  Map<String, dynamic> toJson() => _$BenefitModelToJson(this);

  @override
  List<Object?> get props => <Object?>[type, selected];
}

@JsonSerializable()
class BrandModel extends Equatable {
  const BrandModel({this.id, this.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  @override
  List<Object?> get props => <Object?>[id, name];
}

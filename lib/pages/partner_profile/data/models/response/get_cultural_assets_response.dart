import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_cultural_assets_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetCulturalAssetsResponse extends Equatable {
  const GetCulturalAssetsResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });
  factory GetCulturalAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCulturalAssetsResponseFromJson(json);
  final int error;
  final String messageError;
  final String tecMessageError;
  final int count;
  final List<CulturalAssetItemModel> data;

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
    required this.web3CollectionId,
    required this.collectionId,
    required this.name,
    required this.symbol,
    required this.maxSupply,
    required this.minted,
    required this.contractAddress,
    required this.imageUri,
    this.avatarBackgroundImageUri,
    required this.artistOrBrandId,
    required this.artistOrBrandName,
    required this.communityId,
    required this.experienceOrProductName,
    required this.isExclusive,
    required this.isSubscriberOnly,
    required this.isActive,
    this.accessContent,
  });
  factory CulturalAssetItemModel.fromJson(Map<String, dynamic> json) =>
      _$CulturalAssetItemModelFromJson(json);
  final String? id;
  final String web3CollectionId;
  final int collectionId;
  final String name;
  final String symbol;
  final int maxSupply;
  final int minted;
  final String contractAddress;
  final String imageUri;
  final String? avatarBackgroundImageUri;
  final String artistOrBrandId;
  final String artistOrBrandName;
  final String communityId;
  final String experienceOrProductName;
  final bool isExclusive;
  final bool isSubscriberOnly;
  final bool isActive;
  final Map<String, dynamic>? accessContent;

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
    imageUri,
    avatarBackgroundImageUri,
    artistOrBrandId,
    artistOrBrandName,
    communityId,
    experienceOrProductName,
    isExclusive,
    isSubscriberOnly,
    isActive,
    accessContent,
  ];
}

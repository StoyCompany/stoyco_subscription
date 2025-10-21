import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cultural_asset_card_model.g.dart';

@JsonSerializable()
class CulturalAssetCardModel extends Equatable {
  const CulturalAssetCardModel({
    required this.image,
    required this.title,
    required this.price,
    required this.subscribersOnly,
    bool? hasAccess,
  }) : hasAccess = hasAccess ?? !subscribersOnly;

  factory CulturalAssetCardModel.fromJson(Map<String, dynamic> json) =>
      _$CulturalAssetCardModelFromJson(json);
  final String image;
  final String title;
  final num price;
  final bool subscribersOnly;
  final bool hasAccess;

  Map<String, dynamic> toJson() => _$CulturalAssetCardModelToJson(this);

  @override
  List<Object?> get props => <Object?>[image, title, price, hasAccess, subscribersOnly];
}

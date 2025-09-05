import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_catalog_item.g.dart';

@JsonSerializable()
class SubscriptionCatalogItem extends Equatable {
  final String id;
  final String imageUrl;
  final String title;
  final bool subscribed;

  const SubscriptionCatalogItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subscribed,
  });

  factory SubscriptionCatalogItem.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCatalogItemFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionCatalogItemToJson(this);

  @override
  List<Object?> get props => [imageUrl, title, subscribed];
}

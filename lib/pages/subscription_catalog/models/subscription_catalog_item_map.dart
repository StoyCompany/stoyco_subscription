import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_catalog_item_map.g.dart';

@JsonSerializable()
class SubscriptionCatalogItemMap extends Equatable {
  const SubscriptionCatalogItemMap({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subscribed,
    required this.partnerId,
    required this.profile,
  });

  factory SubscriptionCatalogItemMap.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCatalogItemMapFromJson(json);

  final String id;
  final String imageUrl;
  final String title;
  final bool subscribed;
  final String partnerId;
  final String profile;

  Map<String, dynamic> toJson() => _$SubscriptionCatalogItemMapToJson(this);

  @override
  List<Object?> get props => <Object?>[
    id,
    imageUrl,
    title,
    subscribed,
    partnerId,
    profile,
  ];
}

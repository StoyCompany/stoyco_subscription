import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_subscription_catalog_response.g.dart';

/// {@template get_subscription_catalog_response}
/// Model representing the response for the subscription catalog API.
/// {@endtemplate}
@JsonSerializable()
class GetSubscriptionCatalogResponse extends Equatable {
  /// {@macro get_subscription_catalog_response}
  const GetSubscriptionCatalogResponse({
    required this.pagination,
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  /// Creates a [GetSubscriptionCatalogResponse] from a JSON map.
  factory GetSubscriptionCatalogResponse.fromJson(Map<String, dynamic> json) =>
      _$GetSubscriptionCatalogResponseFromJson(json);

  /// Pagination information.
  final Pagination pagination;

  /// Error code returned by the API.
  final int error;

  /// User-friendly error message.
  final String messageError;

  /// Technical error message for debugging.
  final String tecMessageError;

  /// Number of subscription items returned.
  final int count;

  /// List of subscription catalog items.
  final List<SubscriptionCatalogItem> data;

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => _$GetSubscriptionCatalogResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[
    pagination,
    error,
    messageError,
    tecMessageError,
    count,
    data,
  ];
}

@JsonSerializable()
class Pagination extends Equatable {
  const Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  Map<String, dynamic> toJson() => _$PaginationToJson(this);

  @override
  List<Object?> get props => <Object?>[
    currentPage,
    pageSize,
    totalItems,
    totalPages,
    hasPreviousPage,
    hasNextPage,
  ];
}

@JsonSerializable()
class SubscriptionCatalogItem extends Equatable {
  const SubscriptionCatalogItem({
    required this.subscriptionId,
    required this.partnerName,
    required this.partnerImageUrl,
    required this.isSubscribed,
  });

  factory SubscriptionCatalogItem.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCatalogItemFromJson(json);

  final String subscriptionId;
  final String partnerName;
  final String partnerImageUrl;
  final bool isSubscribed;

  Map<String, dynamic> toJson() => _$SubscriptionCatalogItemToJson(this);

  @override
  List<Object?> get props => <Object?>[
    subscriptionId,
    partnerName,
    partnerImageUrl,
    isSubscribed,
  ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_subscription_catalog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSubscriptionCatalogResponse _$GetSubscriptionCatalogResponseFromJson(
  Map<String, dynamic> json,
) => GetSubscriptionCatalogResponse(
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
  error: (json['error'] as num).toInt(),
  messageError: json['messageError'] as String,
  tecMessageError: json['tecMessageError'] as String,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => SubscriptionCatalogItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetSubscriptionCatalogResponseToJson(
  GetSubscriptionCatalogResponse instance,
) => <String, dynamic>{
  'pagination': instance.pagination,
  'error': instance.error,
  'messageError': instance.messageError,
  'tecMessageError': instance.tecMessageError,
  'count': instance.count,
  'data': instance.data,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['currentPage'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasPreviousPage': instance.hasPreviousPage,
      'hasNextPage': instance.hasNextPage,
    };

SubscriptionCatalogItem _$SubscriptionCatalogItemFromJson(
  Map<String, dynamic> json,
) => SubscriptionCatalogItem(
  subscriptionId: json['subscriptionId'] as String,
  partnerName: json['partnerName'] as String,
  partnerImageUrl: json['partnerImageUrl'] as String,
  isSubscribed: json['isSubscribed'] as bool,
);

Map<String, dynamic> _$SubscriptionCatalogItemToJson(
  SubscriptionCatalogItem instance,
) => <String, dynamic>{
  'subscriptionId': instance.subscriptionId,
  'partnerName': instance.partnerName,
  'partnerImageUrl': instance.partnerImageUrl,
  'isSubscribed': instance.isSubscribed,
};

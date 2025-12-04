import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/get_subscription_catalog_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_service.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/enums/subscription_profile_type.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item_map.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/logger.dart';

class SubscriptionCatalogNotifier extends ChangeNotifier {
  SubscriptionCatalogNotifier(
    TickerProvider vsync, {
    required this.service,
    int? pageSize,
  }) : pageSize = pageSize ?? 50 {
    tabController = TabController(vsync: vsync, length: tabs.length);
    tabController.addListener(_onTabChanged);
    _fetchCatalog();
    scrollController.addListener(_onScroll);
    changeTab(0);
  }
  late TabController tabController;
  int selectedIndex = 0;
  List<SubscriptionStoycoTab> tabs = <SubscriptionStoycoTab>[
    const SubscriptionStoycoTab(title: 'Music'),
    const SubscriptionStoycoTab(title: 'Sport'),
    const SubscriptionStoycoTab(title: 'Brands'),
  ];
  final ScrollController scrollController = ScrollController();
  final SubscriptionCatalogService service;

  List<SubscriptionCatalogItemMap> musicSubscriptions =
      <SubscriptionCatalogItemMap>[];
  List<SubscriptionCatalogItemMap> sportSubscriptions =
      <SubscriptionCatalogItemMap>[];
  List<SubscriptionCatalogItemMap> brandSubscriptions =
      <SubscriptionCatalogItemMap>[];

  List<SubscriptionCatalogItemMap> subscriptions =
      <SubscriptionCatalogItemMap>[];
  List<SubscriptionCatalogItemMap> filteredSubscriptions =
      <SubscriptionCatalogItemMap>[];
  String searchText = '';

  int currentPage = 1;
  final int pageSize;
  bool isLoadingMore = false;
  bool hasNextPage = true;

  void _onTabChanged() {
    if (tabController.indexIsChanging || tabController.index != selectedIndex) {
      changeTab(tabController.index);
    }
  }

  void changeTab(int index) {
    selectedIndex = index;
    switch (index) {
      case 0:
        subscriptions = List<SubscriptionCatalogItemMap>.from(
          musicSubscriptions,
        );
      case 1:
        subscriptions = List<SubscriptionCatalogItemMap>.from(
          sportSubscriptions,
        );
      case 2:
        subscriptions = List<SubscriptionCatalogItemMap>.from(
          brandSubscriptions,
        );
      default:
        subscriptions = <SubscriptionCatalogItemMap>[];
    }
    applyFilter();
    notifyListeners();
  }

  void onSearchChanged(String value) {
    searchText = value;
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    if (searchText.isEmpty) {
      filteredSubscriptions = List<SubscriptionCatalogItemMap>.from(
        subscriptions,
      );
    } else {
      filteredSubscriptions = subscriptions
          .where(
            (SubscriptionCatalogItemMap item) =>
                item.title.toLowerCase().contains(searchText.toLowerCase()),
          )
          .toList();
    }
  }

  void _onScroll() {
    if (!isLoadingMore &&
        hasNextPage &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      loadNextPage();
    }
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore || !hasNextPage) {
      return;
    }
    isLoadingMore = true;
    final int nextPage = currentPage + 1;
    final Either<Failure, GetSubscriptionCatalogResponse> result = await service.getSubscriptionCatalog(
          page: nextPage,
          pageSize: pageSize,
        );
    result.fold(
      (Failure failure) {
        StoyCoLogger.error('Error al obtener catálogo: $failure');
      },
      (GetSubscriptionCatalogResponse response) {
        final List<SubscriptionCatalogItemMap> newItems = response.data
            .map(
              (SubscriptionCatalogItem item) => SubscriptionCatalogItemMap(
                id: item.subscriptionId,
                imageUrl: item.partnerImageUrl,
                title: item.partnerName,
                subscribed: item.isSubscribed,
                partnerId: item.partnerId,
                profile: item.profile,
                hasSubscription: item.hasSubscription,
                isExpired: item.isExpired
              ),
            )
            .toList();

        musicSubscriptions.addAll(
          newItems.where(
            (SubscriptionCatalogItemMap item) =>
                parseProfileType(item.profile) == SubscriptionProfileType.music,
          ),
        );
        sportSubscriptions.addAll(
          newItems.where(
            (SubscriptionCatalogItemMap item) =>
                parseProfileType(item.profile) == SubscriptionProfileType.sport,
          ),
        );
        brandSubscriptions.addAll(
          newItems.where(
            (SubscriptionCatalogItemMap item) =>
                parseProfileType(item.profile) == SubscriptionProfileType.brand,
          ),
        );

        currentPage = nextPage;
        hasNextPage = response.pagination.hasNextPage;
        changeTab(selectedIndex);
        notifyListeners();
      },
    );
    isLoadingMore = false;
  }

  Future<void> _fetchCatalog() async {
    currentPage = 1;
    hasNextPage = true;
    isLoadingMore = false;
    musicSubscriptions.clear();
    sportSubscriptions.clear();
    brandSubscriptions.clear();

    while (hasNextPage) {
      final Either<Failure, GetSubscriptionCatalogResponse> result = await service.getSubscriptionCatalog(
            page: currentPage,
            pageSize: pageSize,
          );
      result.fold(
        (Failure failure) {
          StoyCoLogger.error('Error al obtener catálogo: $failure');
          hasNextPage = false;
        },
        (GetSubscriptionCatalogResponse response) {
          final List<SubscriptionCatalogItemMap> allItems = response.data
              .map(
                (SubscriptionCatalogItem item) => SubscriptionCatalogItemMap(
                  id: item.subscriptionId,
                  imageUrl: item.partnerImageUrl,
                  title: item.partnerName,
                  subscribed: item.isSubscribed,
                  partnerId: item.partnerId,
                  profile: item.profile,
                  hasSubscription: item.hasSubscription,
                  isExpired: item.isExpired
                ),
              )
              .toList();

          musicSubscriptions.addAll(
            allItems.where(
              (SubscriptionCatalogItemMap item) =>
                  parseProfileType(item.profile) ==
                  SubscriptionProfileType.music,
            ),
          );
          sportSubscriptions.addAll(
            allItems.where(
              (SubscriptionCatalogItemMap item) =>
                  parseProfileType(item.profile) ==
                  SubscriptionProfileType.sport,
            ),
          );
          brandSubscriptions.addAll(
            allItems.where(
              (SubscriptionCatalogItemMap item) =>
                  parseProfileType(item.profile) ==
                  SubscriptionProfileType.brand,
            ),
          );

          hasNextPage = response.pagination.hasNextPage;
          currentPage++;
        },
      );
    }

    changeTab(selectedIndex);
    notifyListeners();
  }
}

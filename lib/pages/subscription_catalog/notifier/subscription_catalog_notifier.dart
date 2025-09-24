import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/get_subscription_catalog_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_service.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item_map.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

class SubscriptionCatalogNotifier extends ChangeNotifier {
  SubscriptionCatalogNotifier(TickerProvider vsync) {
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
  final int pageSize = 20;
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
    final Either<Failure, GetSubscriptionCatalogResponse> result =
        await SubscriptionCatalogService.instance.getSubscriptionCatalog(
          page: nextPage,
          pageSize: pageSize,
        );
    result.fold(
      (Failure failure) {
        print('Error al obtener catálogo: $failure');
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
              ),
            )
            .toList();

        musicSubscriptions.addAll(
          newItems.where(
            (SubscriptionCatalogItemMap item) =>
                item.profile.toLowerCase() == 'music',
          ),
        );
        sportSubscriptions.addAll(
          newItems.where(
            (SubscriptionCatalogItemMap item) =>
                item.profile.toLowerCase() == 'sport',
          ),
        );
        brandSubscriptions.addAll(
          newItems.where(
            (SubscriptionCatalogItemMap item) =>
                item.profile.toLowerCase() == 'brands',
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
    final Either<Failure, GetSubscriptionCatalogResponse> result =
        await SubscriptionCatalogService.instance.getSubscriptionCatalog(
          page: currentPage,
          pageSize: pageSize,
        );
    result.fold(
      (Failure failure) {
        print('Error al obtener catálogo: $failure');
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
              ),
            )
            .toList();

        musicSubscriptions = allItems
            .where(
              (SubscriptionCatalogItemMap item) =>
                  response.data
                      .firstWhere(
                        (SubscriptionCatalogItem e) =>
                            e.subscriptionId == item.id,
                      )
                      .profile
                      .toLowerCase() ==
                  'music',
            )
            .toList();

        sportSubscriptions = allItems
            .where(
              (SubscriptionCatalogItemMap item) =>
                  response.data
                      .firstWhere(
                        (SubscriptionCatalogItem e) =>
                            e.subscriptionId == item.id,
                      )
                      .profile
                      .toLowerCase() ==
                  'sport',
            )
            .toList();

        brandSubscriptions = allItems
            .where(
              (SubscriptionCatalogItemMap item) =>
                  response.data
                      .firstWhere(
                        (SubscriptionCatalogItem e) =>
                            e.subscriptionId == item.id,
                      )
                      .profile
                      .toLowerCase() ==
                  'brands',
            )
            .toList();

        changeTab(selectedIndex);
        notifyListeners();
      },
    );
  }
}

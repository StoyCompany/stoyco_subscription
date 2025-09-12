import 'package:flutter/material.dart';
import 'package:stoyco_subscription/atomic_design/molecules/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item.dart'; // Importa el modelo

class SubscriptionCatalogNotifier extends ChangeNotifier {
  late TabController tabController;
  int selectedIndex = 0;
  List<SubscriptionStoycoTab> tabs = [
    const SubscriptionStoycoTab(title: 'Music'),
    const SubscriptionStoycoTab(title: 'Sport'),
    const SubscriptionStoycoTab(title: 'Brands'),
  ];
  final ScrollController scrollController = ScrollController();

  final List<SubscriptionCatalogItem> musicSubscriptions = [
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?1',
      title: 'Eladio Carrión',
      subscribed: true,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?2',
      title: 'Bad Bunny',
      subscribed: true,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?3',
      title: 'Karol G',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?4',
      title: 'Rauw Alejandro',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?5',
      title: 'Feid',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?16',
      title: 'Shakira',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?17',
      title: 'J Balvin',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?18',
      title: 'Ozuna',
      subscribed: false,
    ),
  ];

  final List<SubscriptionCatalogItem> sportSubscriptions = [
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?6',
      title: 'Cristiano Ronaldo',
      subscribed: true,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?7',
      title: 'Lionel Messi',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?8',
      title: 'Serena Williams',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?9',
      title: 'LeBron James',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?10',
      title: 'Usain Bolt',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?19',
      title: 'Michael Jordan',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?20',
      title: 'Simone Biles',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?21',
      title: 'Roger Federer',
      subscribed: false,
    ),
  ];

  final List<SubscriptionCatalogItem> brandSubscriptions = [
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?11',
      title: 'Nike',
      subscribed: true,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?12',
      title: 'Adidas',
      subscribed: true,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?13',
      title: 'Apple',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?14',
      title: 'Samsung',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?15',
      title: 'Coca-Cola',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?22',
      title: 'Microsoft',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?23',
      title: 'Google',
      subscribed: false,
    ),
    SubscriptionCatalogItem(
      id: '681bb4ed712816d61286b1af',
      imageUrl: 'https://picsum.photos/200?24',
      title: 'Amazon',
      subscribed: false,
    ),
  ];

  List<SubscriptionCatalogItem> subscriptions = [];
  List<SubscriptionCatalogItem> filteredSubscriptions = [];
  String searchText = '';

  SubscriptionCatalogNotifier(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: tabs.length);
    tabController.addListener(_onTabChanged);
    changeTab(0);
  }

  void _onTabChanged() {
    if (tabController.indexIsChanging || tabController.index != selectedIndex) {
      changeTab(tabController.index);
    }
  }

  void changeTab(int index) {
    selectedIndex = index;
    switch (index) {
      case 0:
        subscriptions = List.from(musicSubscriptions);
        break;
      case 1:
        subscriptions = List.from(sportSubscriptions);
        break;
      case 2:
        subscriptions = List.from(brandSubscriptions);
        break;
      default:
        subscriptions = [];
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
      filteredSubscriptions = List.from(subscriptions);
    } else {
      filteredSubscriptions = subscriptions
          .where(
            (item) =>
                item.title.toLowerCase().contains(searchText.toLowerCase()),
          )
          .toList();
    }
  }

  void goToDetail(SubscriptionCatalogItem item) {}
}

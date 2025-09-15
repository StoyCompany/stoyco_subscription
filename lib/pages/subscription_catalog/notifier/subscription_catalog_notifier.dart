import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item.dart'; // Importa el modelo

class SubscriptionCatalogNotifier extends ChangeNotifier {
  SubscriptionCatalogNotifier(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: tabs.length);
    tabController.addListener(_onTabChanged);
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

  final List<SubscriptionCatalogItem> musicSubscriptions =
      <SubscriptionCatalogItem>[
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?1',
          title: 'Eladio Carrión',
          subscribed: true,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?2',
          title: 'Bad Bunny',
          subscribed: true,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?3',
          title: 'Karol G',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?4',
          title: 'Rauw Alejandro',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?5',
          title: 'Feid',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?16',
          title: 'Shakira',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?17',
          title: 'J Balvin',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?18',
          title: 'Ozuna',
          subscribed: false,
        ),
      ];

  final List<SubscriptionCatalogItem> sportSubscriptions =
      <SubscriptionCatalogItem>[
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?6',
          title: 'Cristiano Ronaldo',
          subscribed: true,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?7',
          title: 'Lionel Messi',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?8',
          title: 'Serena Williams',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?9',
          title: 'LeBron James',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?10',
          title: 'Usain Bolt',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?19',
          title: 'Michael Jordan',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?20',
          title: 'Simone Biles',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?21',
          title: 'Roger Federer',
          subscribed: false,
        ),
      ];

  final List<SubscriptionCatalogItem> brandSubscriptions =
      <SubscriptionCatalogItem>[
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?11',
          title: 'Nike',
          subscribed: true,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?12',
          title: 'Adidas',
          subscribed: true,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?13',
          title: 'Apple',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?14',
          title: 'Samsung',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?15',
          title: 'Coca-Cola',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?22',
          title: 'Microsoft',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?23',
          title: 'Google',
          subscribed: false,
        ),
        const SubscriptionCatalogItem(
          id: '681bb4ed712816d61286b1af',
          imageUrl: 'https://picsum.photos/200?24',
          title: 'Amazon',
          subscribed: false,
        ),
      ];

  List<SubscriptionCatalogItem> subscriptions = <SubscriptionCatalogItem>[];
  List<SubscriptionCatalogItem> filteredSubscriptions =
      <SubscriptionCatalogItem>[];
  String searchText = '';

  void _onTabChanged() {
    if (tabController.indexIsChanging || tabController.index != selectedIndex) {
      changeTab(tabController.index);
    }
  }

  void changeTab(int index) {
    selectedIndex = index;
    switch (index) {
      case 0:
        subscriptions = List<SubscriptionCatalogItem>.from(musicSubscriptions);
      case 1:
        subscriptions = List<SubscriptionCatalogItem>.from(sportSubscriptions);
      case 2:
        subscriptions = List<SubscriptionCatalogItem>.from(brandSubscriptions);
      default:
        subscriptions = <SubscriptionCatalogItem>[];
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
      filteredSubscriptions = List<SubscriptionCatalogItem>.from(subscriptions);
    } else {
      filteredSubscriptions = subscriptions
          .where(
            (SubscriptionCatalogItem item) =>
                item.title.toLowerCase().contains(searchText.toLowerCase()),
          )
          .toList();
    }
  }

  void goToDetail(SubscriptionCatalogItem item) {}
}

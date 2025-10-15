import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/pages/subscription_history/data/models/subscription_history_response.dart';

/// A [ChangeNotifier] that manages the state for the subscription history view.
///
/// Handles loading and exposing a list of [SubscriptionHistoryItem]s, tab selection,
/// and notifies listeners when the data or selected tab changes.
///
/// Tabs include "Todos", "Activo", and "Inactivo" to filter the subscription list.
///
/// Example usage:
/// ```dart
/// final notifier = SubscriptionHistoryNotifier(vsync);
/// notifier.addListener(() {
///   // React to updates
/// });
/// ```
///
/// Call [getSubscriptionHistory] to load the subscription history data.
class SubscriptionHistoryNotifier extends ChangeNotifier {
  /// Creates a [SubscriptionHistoryNotifier] and initializes the tab controller and data.
  ///
  /// [vsync] is required for the [TabController].
  SubscriptionHistoryNotifier(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: tabs.length);
    tabController.addListener(_onTabChanged);

    getSubscriptionHistory();

    changeTab(0);
  }

  /// The list of all subscription history items.
  List<SubscriptionHistoryItem> allSubscriptions = <SubscriptionHistoryItem>[];

  /// The tab controller for switching between tabs.
  late TabController tabController;

  /// The index of the currently selected tab.
  int selectedIndex = 0;

  /// The list of tabs for filtering subscriptions.
  List<SubscriptionStoycoTab> tabs = <SubscriptionStoycoTab>[
    const SubscriptionStoycoTab(title: 'Todos'),
    const SubscriptionStoycoTab(title: 'Activo'),
    const SubscriptionStoycoTab(title: 'Inactivo'),
  ];

  /// Handles tab changes and updates the selected index.
  void _onTabChanged() {
    if (tabController.indexIsChanging || tabController.index != selectedIndex) {
      changeTab(tabController.index);
    }
  }

  /// Changes the selected tab and notifies listeners.
  void changeTab(int index) {
    selectedIndex = index;
    // You can add logic here to filter the list based on the selected tab.
    notifyListeners();
  }

  /// Loads the subscription history data and notifies listeners.
  ///
  /// This example uses mock data for demonstration purposes.
  Future<void> getSubscriptionHistory() async {
    allSubscriptions = <SubscriptionHistoryItem>[
      const SubscriptionHistoryItem(
        planId: '68daa80886a91f7c4f0f6d70',
        planName: 'Plan Básico',
        planImageUrl:
            'https://previews.123rf.com/images/chr1/chr11201/chr1120100048/12193904-orange-county-ca-usa-july-2010-mexican-dancers-performing-in-traditional-latin-american.jpg',
        partnerProfile: 'Music',
        partnerName: 'SUPIČIĆ',
        partnerId: '683775acadde9e7b1d59dacb',
        recurrenceType: 'Monthly',
        price: 80,
        currencyCode: 'MXN',
        currencySymbol: r'$',
        subscribedIsActive: true,
        subscriptionStartDate: '2025-09-23T10:00:00Z',
        subscriptionEndDate: '2025-10-30T10:00:00Z',
        hasActivePlan: true,
      ),
      const SubscriptionHistoryItem(
        planId: '68daa80886a91f7c4f0f6d71',
        planName: 'Plan Premium',
        planImageUrl:
            'https://previews.123rf.com/images/chr1/chr11201/chr1120100048/12193904-orange-county-ca-usa-july-2010-mexican-dancers-performing-in-traditional-latin-american.jpg',
        partnerProfile: 'Video',
        partnerName: 'VIDEONOW',
        partnerId: '683775acadde9e7b1d59dacd',
        recurrenceType: 'Yearly',
        price: 1200,
        currencyCode: 'MXN',
        currencySymbol: r'$',
        subscribedIsActive: false,
        subscriptionStartDate: '2024-01-01T10:00:00Z',
        subscriptionEndDate: '2025-01-01T10:00:00Z',
        hasActivePlan: false,
      ),
    ];
    notifyListeners();
  }
}

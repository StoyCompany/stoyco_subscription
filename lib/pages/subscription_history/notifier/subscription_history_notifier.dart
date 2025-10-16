import 'package:either_dart/src/either.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/requests/get_user_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/models/responses/user_subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/data/subscription_catalog_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// A [ChangeNotifier] that manages the state for the subscription history view.
///
/// Handles loading and exposing a list of [UserSubscriptionPlan]s, tab selection,
/// and notifies listeners when the data or selected tab changes.
///
/// Tabs include "Todos", "Activo", and "Inactivo" to filter the subscription list.
///
/// Example usage:
/// ```dart
/// final notifier = SubscriptionHistoryNotifier(vsync, userId: 'user123');
/// notifier.addListener(() {
///   // React to updates
/// });
/// ```
///
/// Call [getSubscriptionHistory] to load the subscription history data from the service.
class SubscriptionHistoryNotifier extends ChangeNotifier {
  /// Creates a [SubscriptionHistoryNotifier] and initializes the tab controller and data.
  ///
  /// [vsync] is required for the [TabController].
  /// [userId] is the identifier for the user whose subscriptions will be loaded.
  SubscriptionHistoryNotifier(TickerProvider vsync, {required this.userId}) {
    tabController = TabController(vsync: vsync, length: tabs.length);
    tabController.addListener(_onTabChanged);

    getSubscriptionHistory();

    changeTab(0);
  }

  /// The user ID for which to load the subscription history.
  final String userId;

  /// The list of all subscription history items.
  List<UserSubscriptionPlan> allSubscriptions = <UserSubscriptionPlan>[];

  /// The list of active subscription history items.
  List<UserSubscriptionPlan> activeSubscriptions = <UserSubscriptionPlan>[];

  /// The list of inactive subscription history items.
  List<UserSubscriptionPlan> inactiveSubscriptions = <UserSubscriptionPlan>[];

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
    notifyListeners();
  }

  /// Loads the subscription history data from the service and notifies listeners.
  ///
  /// Populates [allSubscriptions], [activeSubscriptions], and [inactiveSubscriptions]
  /// based on the [subscribedIsActive] field of each [UserSubscriptionPlan].
  Future<void> getSubscriptionHistory() async {
    final Either<Failure, UserSubscriptionPlanResponse> result =
        await SubscriptionCatalogService.instance.getUserSubscriptionPlans(
          GetUserSubscriptionPlansRequest(userId: userId),
        );
    result.fold(
      (Failure failure) {
        // Handle the error according to your logic
        allSubscriptions = <UserSubscriptionPlan>[];
        activeSubscriptions = <UserSubscriptionPlan>[];
        inactiveSubscriptions = <UserSubscriptionPlan>[];
      },
      (UserSubscriptionPlanResponse response) {
        allSubscriptions = response.data;
        activeSubscriptions = allSubscriptions
            .where((UserSubscriptionPlan e) => e.subscribedIsActive)
            .toList();
        inactiveSubscriptions = allSubscriptions
            .where((UserSubscriptionPlan e) => !e.subscribedIsActive)
            .toList();
      },
    );
    notifyListeners();
  }

  /// Returns the list to display according to the selected tab.
  ///
  /// - Tab 0 ("Todos"): returns [allSubscriptions]
  /// - Tab 1 ("Activo"): returns [activeSubscriptions]
  /// - Tab 2 ("Inactivo"): returns [inactiveSubscriptions]
  List<UserSubscriptionPlan> get subscriptionsToShow {
    switch (selectedIndex) {
      case 1:
        return activeSubscriptions;
      case 2:
        return inactiveSubscriptions;
      default:
        return allSubscriptions;
    }
  }
}

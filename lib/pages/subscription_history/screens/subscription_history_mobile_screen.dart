import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/appbars/custom_subscription_appbar.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_history_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tab_bar/tab_bar_v2.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_history/notifier/subscription_history_notifier.dart';

/// {@template subscription_history_mobile_screen}
/// A mobile screen that displays the user's subscription history.
///
/// Shows a custom app bar, a tab bar for filtering subscriptions, and a scrollable list
/// of [SubscriptionHistoryCard] widgets. The list is populated from the [SubscriptionHistoryNotifier].
///
/// Example usage:
/// ```dart
/// SubscriptionHistoryMobileScreen();
/// ```
/// {@endtemplate}
class SubscriptionHistoryMobileScreen extends StatefulWidget {
  /// Creates a [SubscriptionHistoryMobileScreen].
  const SubscriptionHistoryMobileScreen({super.key, this.userId});

  final String? userId;

  @override
  State<SubscriptionHistoryMobileScreen> createState() =>
      _SubscriptionHistoryMobileScreenState();
}

/// State for [SubscriptionHistoryMobileScreen].
class _SubscriptionHistoryMobileScreenState
    extends State<SubscriptionHistoryMobileScreen>
    with SingleTickerProviderStateMixin {
  late SubscriptionHistoryNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = SubscriptionHistoryNotifier(this, userId: widget.userId ?? '');
    notifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    notifier.removeListener(_onNotifierChanged);
    notifier.tabController.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: StoycoColors.deepCharcoal,
      child: Scaffold(
        appBar: CustomAppBar(
          leadingIcon: StoycoAssets.lib.assets.icons.leftArrow.svg(
            height: StoycoScreenSize.height(context, 24),
            width: StoycoScreenSize.width(context, 24),
            package: 'stoyco_subscription',
          ),
          onLeadingPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Historial de Suscripciones',
        ),
        body: Padding(
          padding: StoycoScreenSize.symmetric(context, horizontal: 24),
          child: Column(
            spacing: StoycoScreenSize.height(context, 16),
            children: <Widget>[
              StoycoTabBarV2(
                tabController: notifier.tabController,
                tabs: notifier.tabs,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: notifier.subscriptionsToShow.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    margin: EdgeInsets.only(
                      bottom: StoycoScreenSize.height(context, 12),
                    ),
                    child: SubscriptionHistoryCard(
                      subscriptionHistoryItem:
                          notifier.subscriptionsToShow[index],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return Gap(StoycoScreenSize.height(context, 24));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

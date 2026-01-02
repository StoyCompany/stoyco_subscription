import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/headers/subscription_breadcrumbs.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_history_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tab_bar/tab_bar_v2.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_history/notifier/subscription_history_notifier.dart';

/// {@template subscription_history_web_screen}
/// A web screen that displays the user's subscription history.
///
/// Shows breadcrumbs for navigation, a tab bar for filtering subscriptions, and a responsive
/// grid layout of [SubscriptionHistoryCard] widgets. The grid adapts to the available width.
/// The list is populated from the [SubscriptionHistoryNotifier].
///
/// Example usage:
/// ```dart
/// SubscriptionHistoryWebScreen(
///   userId: 'user123',
///   onTapSubscriptionHistoryCard: (partnerId) => print(partnerId),
/// );
/// ```
/// {@endtemplate}
class SubscriptionHistoryWebScreen extends StatefulWidget {
  /// Creates a [SubscriptionHistoryWebScreen].
  const SubscriptionHistoryWebScreen({
    super.key,
    required this.userId,
    this.onTapSubscriptionHistoryCard,
  });

  /// The user ID for which to display subscription history.
  final String userId;

  /// Callback triggered when a subscription history card is tapped.
  /// Receives the [partnerId] of the tapped subscription.
  final void Function(String partnerId)? onTapSubscriptionHistoryCard;

  @override
  State<SubscriptionHistoryWebScreen> createState() =>
      _SubscriptionHistoryWebScreenState();
}

/// State for [SubscriptionHistoryWebScreen].
class _SubscriptionHistoryWebScreenState
    extends State<SubscriptionHistoryWebScreen>
    with SingleTickerProviderStateMixin {
  late SubscriptionHistoryNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = SubscriptionHistoryNotifier(this, userId: widget.userId);
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
    return Scaffold(
      backgroundColor: StoycoColors.deepCharcoal,
      body: Container(
        padding: StoycoScreenSize.fromLTRB(
          context,
          left: 24,
          top: 32,
          right: 40,
          bottom: 32,
        ),
        child: Column(
          spacing: StoycoScreenSize.height(context, 16),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: StoycoScreenSize.fromLTRB(context, left: 7),
                  child: Breadcrumbs(
                    items: <BreadcrumbItem>[
                      BreadcrumbItem(
                        label: 'Suscripción',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      BreadcrumbItem(label: 'Historial de Suscripciones'),
                    ],
                  ),
                ),
              ],
            ),

            StoycoTabBarV2(
              tabController: notifier.tabController,
              tabs: notifier.tabs,
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double minCardWidth = StoycoScreenSize.width(
                    context,
                    350,
                  );
                  final double spacing = StoycoScreenSize.width(context, 24);
                  final double maxWidth = constraints.maxWidth;

                  int crossAxisCount =
                      ((maxWidth + spacing) / (minCardWidth + spacing)).floor();
                  crossAxisCount = crossAxisCount.clamp(1, 3);

                  final double totalSpacing = (crossAxisCount - 1) * spacing;
                  final double cardWidth =
                      (maxWidth - totalSpacing) / crossAxisCount;

                  if (cardWidth < minCardWidth && crossAxisCount > 1) {
                    crossAxisCount -= 1;
                  }

                  return ListView(
                    padding: StoycoScreenSize.fromLTRB(
                      context,
                      top: 24,
                      bottom: 24,
                    ),
                    children: <Widget>[
                      Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: List<Widget>.generate(
                          notifier.subscriptionsToShow.length,
                          (int index) {
                            final double totalSpacing =
                                (crossAxisCount - 1) * spacing;
                            final double cardWidth =
                                (maxWidth - totalSpacing) / crossAxisCount;

                            return SizedBox(
                              width: cardWidth,
                              child: SubscriptionHistoryCard(
                                subscriptionHistoryItem:
                                    notifier.subscriptionsToShow[index],
                                onTapSubscriptionHistoryCard:
                                    widget.onTapSubscriptionHistoryCard,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

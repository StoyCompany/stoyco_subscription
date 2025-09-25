import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/headers/subscription_breadcrumbs.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/inputs/subscription_search_bar.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tab_bar/tab_bar_v2.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/circular_avatar/subscription_circular_image_with_info.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item_map.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/notifier/subscription_catalog_notifier.dart';

/// {@template subscriptions_catalog_screen_web}
/// Displays the subscription catalog for web and large screens.
///
/// This widget shows a responsive grid of subscription items, a tab bar for filtering,
/// a search bar, and breadcrumbs for navigation context. It adapts the grid layout
/// based on the available width.
///
/// Optionally, you can provide callbacks for when a subscription or the subscribe button is tapped.
/// {@endtemplate}
class SubscriptionsCatalogScreenWeb extends StatefulWidget {
  /// {@macro subscriptions_catalog_screen_web}
  const SubscriptionsCatalogScreenWeb({
    this.onTapSubscription,
    this.onTapSubscribe,
    this.userId,
    super.key,
  });

  /// Callback triggered when a subscription item is tapped.
  /// Receives the [id] of the tapped subscription.
  final void Function(String id)? onTapSubscription;

  /// Callback triggered when the subscribe button is tapped.
  /// Receives the [id] of the subscription.
  final void Function(String id)? onTapSubscribe;

  final String? userId;

  @override
  State<SubscriptionsCatalogScreenWeb> createState() =>
      _SubscriptionsCatalogScreenWebState();
}

/// State for [SubscriptionsCatalogScreenWeb].
///
/// Handles the notifier, tab controller, and grid layout logic.
class _SubscriptionsCatalogScreenWebState
    extends State<SubscriptionsCatalogScreenWeb>
    with SingleTickerProviderStateMixin {
  late SubscriptionCatalogNotifier notifier;
  late void Function(String id)? onTapSubscription;

  @override
  void initState() {
    super.initState();

    onTapSubscription = widget.onTapSubscription;
    notifier = SubscriptionCatalogNotifier(this, userId: widget.userId);
    notifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    notifier.removeListener(_onNotifierChanged);
    notifier.tabController.dispose();
    notifier.scrollController.dispose();
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
          spacing: StoycoScreenSize.height(context, 32),
          children: <Widget>[
            // Breadcrumb navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: StoycoScreenSize.fromLTRB(context, left: 7),
                  child: Breadcrumbs(
                    items: <BreadcrumbItem>[
                      BreadcrumbItem(label: 'Suscripción', onTap: () {}),
                      BreadcrumbItem(label: 'Categorías'),
                    ],
                  ),
                ),
              ],
            ),

            // Tab bar and search bar
            Row(
              spacing: StoycoScreenSize.width(context, 96),
              children: <Widget>[
                Expanded(
                  child: StoycoTabBarV2(
                    tabController: notifier.tabController,
                    tabs: notifier.tabs,
                  ),
                ),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 327),
                  child: SubscriptionSearchBar(
                    onChanged: notifier.onSearchChanged,
                  ),
                ),
              ],
            ),

            // Responsive grid of subscription items
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double minCardWidth = StoycoScreenSize.width(
                    context,
                    148.1,
                  );
                  final double spacing = StoycoScreenSize.width(context, 32);
                  final double maxWidth = constraints.maxWidth;
                  int crossAxisCount =
                      ((maxWidth + spacing) / (minCardWidth + spacing)).floor();
                  crossAxisCount = crossAxisCount.clamp(1, 6);

                  final double totalSpacing = (crossAxisCount - 1) * spacing;
                  final double cardWidth =
                      (maxWidth - totalSpacing) / crossAxisCount;
                  if (cardWidth < minCardWidth && crossAxisCount > 1) {
                    crossAxisCount -= 1;
                  }

                  return GridView.builder(
                    controller: notifier.scrollController,
                    padding: const EdgeInsets.only(top: 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing - 8,
                      childAspectRatio:
                          cardWidth / StoycoScreenSize.height(context, 260),
                    ),
                    itemCount: notifier.filteredSubscriptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SubscriptionCatalogItemMap item =
                          notifier.filteredSubscriptions[index];
                      return SubscriptionCircularImageWithInfo(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        subscribed: item.subscribed,
                        onTap: () => onTapSubscription?.call(item.partnerId),
                        onTapSubscribe: () =>
                            widget.onTapSubscribe?.call(item.partnerId),
                        titleFontSize: 19.36,
                      );
                    },
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

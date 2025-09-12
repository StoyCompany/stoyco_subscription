import 'package:flutter/material.dart';
import 'package:stoyco_subscription/atomic_design/atoms/headers/subscription_breadcrumbs.dart';
import 'package:stoyco_subscription/atomic_design/atoms/subscription_search_bar.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/molecules/subscription_circular_image_with_info.dart';
import 'package:stoyco_subscription/atomic_design/molecules/tab_bar_v2.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/notifier/subscription_catalog_notifier.dart';

class SubscriptionsCatalogScreenWeb extends StatefulWidget {
  const SubscriptionsCatalogScreenWeb({this.onTapSubscription, super.key});

  /// Callback triggered when a subscription item is tapped.
  /// Receives the [id] of the tapped subscription.
  final void Function(String id)? onTapSubscription;

  @override
  State<SubscriptionsCatalogScreenWeb> createState() =>
      _SubscriptionsCatalogScreenWebState();
}

class _SubscriptionsCatalogScreenWebState
    extends State<SubscriptionsCatalogScreenWeb>
    with SingleTickerProviderStateMixin {
  late SubscriptionCatalogNotifier notifier;
  late void Function(String id)? onTapSubscription;

  @override
  void initState() {
    super.initState();

    onTapSubscription = widget.onTapSubscription;
    notifier = SubscriptionCatalogNotifier(this);
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: StoycoScreenSize.fromLTRB(context, left: 7),
                  child: Breadcrumbs(
                    items: [
                      BreadcrumbItem(label: 'Suscripción', onTap: () {}),
                      BreadcrumbItem(label: 'Categorías'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: StoycoScreenSize.height(context, 32)),
            Row(
              children: [
                Expanded(
                  child: StoycoTabBarV2(
                    tabController: notifier.tabController,
                    tabs: notifier.tabs,
                  ),
                ),
                SizedBox(width: StoycoScreenSize.width(context, 96)),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 327),
                  child: SubscriptionSearchBar(
                    onChanged: notifier.onSearchChanged,
                  ),
                ),
              ],
            ),
            SizedBox(height: StoycoScreenSize.height(context, 32)),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double minCardWidth = StoycoScreenSize.width(
                    context,
                    148.1,
                  );
                  final double spacing = StoycoScreenSize.width(context, 32);
                  final double maxWidth = constraints.maxWidth;
                  int crossAxisCount =
                      ((maxWidth + spacing) / (minCardWidth + spacing)).floor();
                  crossAxisCount = crossAxisCount.clamp(1, 6);

                  double totalSpacing = (crossAxisCount - 1) * spacing;
                  double cardWidth = (maxWidth - totalSpacing) / crossAxisCount;
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
                    itemBuilder: (context, index) {
                      final item = notifier.filteredSubscriptions[index];
                      return SubscriptionCircularImageWithInfo(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        subscribed: item.subscribed,
                        onTap: () => onTapSubscription?.call(item.id),
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

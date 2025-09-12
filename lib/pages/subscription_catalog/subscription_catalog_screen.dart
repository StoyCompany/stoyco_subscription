import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/inputs/subscription_search_bar.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tab_bar/tab_bar_v2.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/circular_avatar/subscription_circular_image_with_info.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/subscription_catalog_notifier.dart';

/// {@template subscription_catalog}
/// A catalog screen for displaying and searching subscriptions in a grid format.
///
/// This widget displays a customizable [AppBar], a search bar, a tab bar for filtering,
/// and a grid of subscription items. When a subscription is tapped, the [onTapSubscription]
/// callback is triggered with the selected subscription's id.
///
/// Example usage:
/// ```dart
/// SubscriptionCatalog(
///   buildAppbar: AppBar(title: const Text('Subscriptions')),
///   onTapSubscription: (id)
///     print('Tapped subscription with id: $id');
///   },
/// )
/// ```
///
/// {@endtemplate}
class SubscriptionCatalog extends StatefulWidget {

  /// {@macro subscription_catalog}
  const SubscriptionCatalog({
    super.key,
    required this.buildAppbar,
    this.onTapSubscription,
  });
  /// The [AppBar] to display at the top of the screen.
  final PreferredSizeWidget buildAppbar;

  /// Callback triggered when a subscription item is tapped.
  /// Receives the [id] of the tapped subscription.
  final void Function(String id)? onTapSubscription;

  @override
  State<SubscriptionCatalog> createState() => _SubscriptionCatalogState();
}

class _SubscriptionCatalogState extends State<SubscriptionCatalog>
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
    final SubscriptionCatalogNotifier controller = notifier;
    return Scaffold(
      backgroundColor: StoycoColors.midnightInk,
      appBar: widget.buildAppbar,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: StoycoScreenSize.height(context, 58),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: StoycoScreenSize.symmetric(context, horizontal: 24),
                  child: Text(
                    'Suscríbete a tu artista favorito',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: StoycoColors.grayText,
                      fontSize: StoycoScreenSize.fontSize(context, 24),
                      fontFamily: FontFamilyToken.akkuratPro,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: StoycoScreenSize.height(context, 16)),
            ),
            SliverAppBar(
              expandedHeight: StoycoScreenSize.height(context, 124),
              toolbarHeight: StoycoScreenSize.height(context, 124),
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: StoycoScreenSize.symmetric(context, horizontal: 24),
                  child: Column(
                    children: <Widget>[
                      SubscriptionSearchBar(
                        onChanged: controller.onSearchChanged,
                      ),
                      SizedBox(height: StoycoScreenSize.height(context, 16)),
                      StoycoTabBarV2(
                        tabController: controller.tabController,
                        tabs: controller.tabs,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: StoycoScreenSize.height(context, 16)),
            ),
            SliverPadding(
              padding: StoycoScreenSize.symmetric(context, horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  final SubscriptionCatalogItem item = controller.filteredSubscriptions[index];
                  return SubscriptionCircularImageWithInfo(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    subscribed: item.subscribed,
                    onTap: () => onTapSubscription?.call(item.id),
                  );
                }, childCount: controller.filteredSubscriptions.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

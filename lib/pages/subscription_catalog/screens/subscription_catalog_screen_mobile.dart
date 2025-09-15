import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/atomic_design/atoms/subscription_search_bar.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/molecules/subscription_circular_image_with_info.dart';
import 'package:stoyco_subscription/atomic_design/molecules/tab_bar_v2.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/notifier/subscription_catalog_notifier.dart';

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
class SubscriptionsCatalogScreenMobile extends StatefulWidget {
  /// {@macro subscription_catalog}
  const SubscriptionsCatalogScreenMobile({super.key, this.onTapSubscription});

  /// The [AppBar] to display at the top of the screen.

  /// Callback triggered when a subscription item is tapped.
  /// Receives the [id] of the tapped subscription.
  final void Function(String id)? onTapSubscription;

  @override
  State<SubscriptionsCatalogScreenMobile> createState() =>
      _SubscriptionsCatalogScreenMobileState();
}

class _SubscriptionsCatalogScreenMobileState
    extends State<SubscriptionsCatalogScreenMobile>
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
      backgroundColor: StoycoColors.deepCharcoal,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: StoycoColors.deepCharcoal,
              surfaceTintColor: StoycoColors.deepCharcoal,
              expandedHeight: StoycoScreenSize.height(context, 24),
              automaticallyImplyLeading: true,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Suscripciones',
                style: TextStyle(
                  color: StoycoColors.snowWhite,
                  fontSize: StoycoScreenSize.fontSize(context, 16),
                  fontFamily: FontFamilyToken.akkuratPro,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: StoycoScreenSize.height(context, 16)),
            ),
            SliverAppBar(
              backgroundColor: StoycoColors.deepCharcoal,
              surfaceTintColor: StoycoColors.deepCharcoal,
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              elevation: 0,
              expandedHeight: StoycoScreenSize.height(context, 60),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: ColoredBox(
                  color: StoycoColors.deepCharcoal,
                  child: Padding(
                    padding: StoycoScreenSize.symmetric(
                      context,
                      horizontal: 24,
                    ),
                    child: Text(
                      'Suscríbete a tu artista favorito',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: StoycoColors.snowWhite,
                          fontSize: StoycoScreenSize.fontSize(context, 24),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: StoycoScreenSize.height(context, 16)),
            ),
            SliverAppBar(
              backgroundColor: StoycoColors.deepCharcoal,
              expandedHeight: StoycoScreenSize.height(context, 124),
              toolbarHeight: StoycoScreenSize.height(context, 124),
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: ColoredBox(
                  color: StoycoColors.deepCharcoal,
                  child: Padding(
                    padding: StoycoScreenSize.symmetric(
                      context,
                      horizontal: 24,
                    ),
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
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final SubscriptionCatalogItem item =
                      controller.filteredSubscriptions[index];
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

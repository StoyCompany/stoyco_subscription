import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/inputs/subscription_search_bar.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/messages/element_not_found.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/circular_avatar/subscription_circular_image_with_info.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tab_bar/tab_bar_v2.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/models/subscription_catalog_item_map.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/notifier/subscription_catalog_notifier.dart';

/// {@template subscription_catalog_screen_mobile}
/// Displays the subscription catalog for mobile devices.
///
/// This widget presents a scrollable catalog of subscriptions in a grid format,
/// including a customizable [AppBar], a search bar, a tab bar for filtering,
/// and a grid of subscription items. The layout is optimized for mobile screens.
///
/// Optionally, you can provide callbacks for when a subscription or the subscribe button is tapped.
///
/// Example usage:
/// ```dart
/// SubscriptionsCatalogScreenMobile(
///   onTapSubscription: (id) {
///     print('Tapped subscription with id: $id');
///   },
///   onTapSubscribe: (id) {
///     print('Tapped subscribe for id: $id');
///   },
/// )
/// ```
/// {@endtemplate}
class SubscriptionsCatalogScreenMobile extends StatefulWidget {
  /// {@macro subscription_catalog_screen_mobile}
  const SubscriptionsCatalogScreenMobile({
    super.key,
    this.onTapSubscription,
    this.onTapSubscribe,
    this.userId,
    this.pageSize,
    this.onTapLeadingIcon,
    this.onTapWhenExpired,
  });

  /// Callback triggered when a subscription item is tapped.
  /// Receives the [id] of the tapped subscription.
  final void Function(String id)? onTapSubscription;

  /// Callback triggered when subscribe button is tapped.
  /// Receives the [id] of the subscription.
  final void Function(String id)? onTapSubscribe;

  final void Function(String id)? onTapWhenExpired;

  final VoidCallback? onTapLeadingIcon;

  final String? userId;

  final int? pageSize;

  @override
  State<SubscriptionsCatalogScreenMobile> createState() =>
      _SubscriptionsCatalogScreenMobileState();
}

/// State for [SubscriptionsCatalogScreenMobile].
///
/// Handles the notifier, tab controller, and grid layout logic.
class _SubscriptionsCatalogScreenMobileState
    extends State<SubscriptionsCatalogScreenMobile>
    with SingleTickerProviderStateMixin {
  late SubscriptionCatalogNotifier notifier;
  late void Function(String id)? onTapSubscription;

  @override
  void initState() {
    super.initState();
    onTapSubscription = widget.onTapSubscription;
    notifier = SubscriptionCatalogNotifier(
      this,
      userId: widget.userId,
      pageSize: widget.pageSize,
    );
    notifier.addListener(_onNotifierChanged);
    // Llamar fetchCatalog después de que el listener esté configurado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.fetchCatalog();
    });
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
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            _buildAppBar(context),
            _buildSpacing(context, 16),
            _buildSubtitle(context),
            _buildSpacing(context, 16),
            _buildSearchAndTabBar(context, controller),
            _buildSpacing(context, 16),
            _buildSubscriptionGrid(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: StoycoColors.midnightInk,
      surfaceTintColor: StoycoColors.midnightInk,
      expandedHeight: StoycoScreenSize.height(context, 24),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: widget.onTapLeadingIcon,
        icon: StoycoAssets.lib.assets.icons.common.leftArrow.svg(
          height: StoycoScreenSize.height(context, 24),
          width: StoycoScreenSize.width(context, 24),
          package: 'stoyco_subscription',
        ),
      ),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Suscripciones',
        style: TextStyle(
          color: StoycoColors.text,
          fontSize: StoycoScreenSize.fontSize(context, 16),
          fontFamily: FontFamilyToken.akkuratPro,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSpacing(BuildContext context, double height) {
    return SliverToBoxAdapter(
      child: SizedBox(height: StoycoScreenSize.height(context, height)),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return SliverAppBar(
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
            padding: StoycoScreenSize.symmetric(context, horizontal: 24),
            child: Text(
              'Suscríbete a tu artista favorito',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: FontFamilyToken.akkuratPro,
                  color: StoycoColors.text,
                  fontSize: StoycoScreenSize.fontSize(context, 24),
                  fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndTabBar(
    BuildContext context,
    SubscriptionCatalogNotifier controller,
  ) {
    return SliverAppBar(
      backgroundColor: StoycoColors.deepCharcoal,
      expandedHeight: StoycoScreenSize.height(context, 124),
      toolbarHeight: StoycoScreenSize.height(context, 124),
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: ColoredBox(
          color: StoycoColors.deepCharcoal,
          child: Padding(
            padding: StoycoScreenSize.symmetric(context, horizontal: 24),
            child: Column(
              spacing: StoycoScreenSize.height(context, 16),
              children: <Widget>[
                SubscriptionSearchBar(onChanged: controller.onSearchChanged),
                StoycoTabBarV2(
                  tabController: controller.tabController,
                  tabs: controller.tabs,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionGrid(
    BuildContext context,
    SubscriptionCatalogNotifier controller,
  ) {
    return SliverPadding(
      padding: StoycoScreenSize.symmetric(context, horizontal: 24),
      sliver: controller.isLoading
          ? _buildLoadingGrid(context)
          : controller.filteredSubscriptions.isEmpty
              ? _buildEmptyState(controller)
              : _buildSubscriptionList(context, controller),
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: StoycoScreenSize.height(context, 56),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: StoycoScreenSize.fromLTRB(context, right: 16),
                      child: _buildSkeletonColumn(context),
                    ),
                  ),
                  Expanded(child: _buildSkeletonColumn(context)),
                ],
              ),
            ),
          );
        },
        childCount: 4,
      ),
    );
  }

  Widget _buildSkeletonColumn(BuildContext context) {
    return Column(
      spacing: StoycoScreenSize.height(context, 7.66),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SkeletonCard(
          height: StoycoScreenSize.height(context, 148),
          width: StoycoScreenSize.width(context, 148),
          borderRadius: BorderRadius.circular(360),
        ),
        SkeletonCard(
          height: StoycoScreenSize.height(context, 25),
          width: double.infinity,
          borderRadius: BorderRadius.circular(8),
        ),
        SkeletonCard(
          height: StoycoScreenSize.height(context, 25),
          width: double.infinity,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  Widget _buildEmptyState(SubscriptionCatalogNotifier controller) {
    return SliverToBoxAdapter(
      child: ElementNotFound(filter: controller.searchText),
    );
  }

  Widget _buildSubscriptionList(
    BuildContext context,
    SubscriptionCatalogNotifier controller,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          const int itemsPerRow = 2;
          final int startIndex = index * itemsPerRow;
          final int endIndex = (startIndex + itemsPerRow).clamp(
            0,
            controller.filteredSubscriptions.length,
          );

          final List<SubscriptionCatalogItemMap> rowItems =
              controller.filteredSubscriptions.sublist(startIndex, endIndex);

          return Padding(
            padding: EdgeInsets.only(
              bottom: StoycoScreenSize.height(context, 56),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ...List<Widget>.generate(
                    rowItems.length,
                    (int itemIndex) => _buildSubscriptionItem(
                      context,
                      rowItems[itemIndex],
                      itemIndex < rowItems.length - 1,
                    ),
                  ),
                  if (rowItems.length == 1) const Spacer(),
                ],
              ),
            ),
          );
        },
        childCount: (controller.filteredSubscriptions.length / 2).ceil(),
      ),
    );
  }

  Widget _buildSubscriptionItem(
    BuildContext context,
    SubscriptionCatalogItemMap item,
    bool hasRightPadding,
  ) {
    return Expanded(
      child: Padding(
        padding: StoycoScreenSize.fromLTRB(
          context,
          right: hasRightPadding ? 16 : 0,
        ),
        child: SubscriptionCircularImageWithInfo(
          imageUrl: item.imageUrl,
          title: item.title,
          subscribed: item.subscribed,
          hasSubscription: item.hasSubscription,
          isExpired: item.isExpired,
          onTap: () => onTapSubscription?.call(item.partnerId),
          onTapSubscribe: () => widget.onTapSubscribe?.call(item.partnerId),
          onTapWhenExpired: () => widget.onTapWhenExpired?.call(item.partnerId),
        ),
      ),
    );
  }
}

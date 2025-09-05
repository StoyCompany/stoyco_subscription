import 'package:flutter/material.dart';
import 'package:stoyco_subscription/atomic_design/atoms/subscription_search_bar.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/molecules/subscription_circular_image_with_info.dart';
import 'package:stoyco_subscription/atomic_design/molecules/tab_bar_v2.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/subscription_catalog_notifier.dart';

class SubscriptionCatalog extends StatefulWidget {
  final PreferredSizeWidget buildAppbar;
  final void Function(String id)? onTapSubscription;
  const SubscriptionCatalog({
    super.key,
    required this.buildAppbar,
    this.onTapSubscription,
  });

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
    final controller = notifier;
    return Scaffold(
      backgroundColor: StoycoColors.midnightInk,
      appBar: widget.buildAppbar,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
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
                    children: [
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = controller.filteredSubscriptions[index];
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

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/screens/subscription_catalog_screen_mobile.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/screens/subscriptions_catalog_screen_web.dart';

class ResponsiveSubscriptionCatalogScreen extends StatelessWidget {
  final void Function(String id)? onTapSubscription;

  const ResponsiveSubscriptionCatalogScreen({
    super.key,
    this.onTapSubscription,
  });

  @override
  Widget build(BuildContext context) {
    if (StoycoScreenSize.isDesktop(context) ||
        StoycoScreenSize.isDesktopLarge(context) ||
        StoycoScreenSize.isTablet(context)) {
      return SubscriptionsCatalogScreenWeb(
        onTapSubscription: onTapSubscription,
      );
    } else {
      return SubscriptionsCatalogScreenMobile(
        onTapSubscription: onTapSubscription,
      );
    }
  }
}

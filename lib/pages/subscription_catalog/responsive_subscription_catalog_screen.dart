import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/screens/subscription_catalog_screen_mobile.dart';
import 'package:stoyco_subscription/pages/subscription_catalog/screens/subscriptions_catalog_screen_web.dart';

/// {@template responsive_subscription_catalog_screen}
/// A responsive widget that displays the subscription catalog screen
/// according to the device's screen size.
///
/// - On desktop, large desktop, and tablet devices, it shows
///   [SubscriptionsCatalogScreenWeb].
/// - On mobile devices, it shows [SubscriptionsCatalogScreenMobile].
///
/// Optionally, you can provide callbacks for when a subscription or
/// subscribe button is tapped.
/// {@endtemplate}
class ResponsiveSubscriptionCatalogScreen extends StatelessWidget {
  /// {@macro responsive_subscription_catalog_screen}
  const ResponsiveSubscriptionCatalogScreen({
    super.key,
    this.onTapSubscription,
    this.onTapSubscribe,
    this.userId,
    this.pageSize,
    this.onTapLeadingIcon,
    this.onTapWhenExpired,
  });

  /// Callback when a subscription is tapped.
  final void Function(String id)? onTapSubscription;

  /// Callback when the subscribe button is tapped.
  final void Function(String id)? onTapSubscribe;

  final void Function(String id)? onTapWhenExpired;

  final VoidCallback? onTapLeadingIcon;

  final String? userId;

  final int? pageSize;

  @override
  Widget build(BuildContext context) {
    if (StoycoScreenSize.isDesktop(context) ||
        StoycoScreenSize.isDesktopLarge(context) ||
        StoycoScreenSize.isTablet(context)) {
      return SubscriptionsCatalogScreenWeb(
        onTapSubscription: onTapSubscription,
        onTapSubscribe: onTapSubscribe,
        onTapWhenExpired: onTapWhenExpired,
        userId: userId,
        pageSize: pageSize,
      );
    } else {
      return SubscriptionsCatalogScreenMobile(
        onTapSubscription: onTapSubscription,
        onTapSubscribe: onTapSubscribe,
        onTapWhenExpired: onTapWhenExpired,
        onTapLeadingIcon: onTapLeadingIcon,
        userId: userId,
        pageSize: pageSize,
      );
    }
  }
}

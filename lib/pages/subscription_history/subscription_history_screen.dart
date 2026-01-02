import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_history/screens/subscription_history_mobile_screen.dart';
import 'package:stoyco_subscription/pages/subscription_history/screens/subscription_history_web_screen.dart';

/// {@template responsive_subscription_history_screen}
/// A responsive screen that displays the subscription history view.
///
/// Shows the [SubscriptionHistoryMobileScreen] on phones. For larger screens,
/// displays a placeholder message ("En Desarrollo") indicating that the desktop/tablet
/// version is under development.
///
/// Example usage:
/// ```dart
/// ResponsiveSubscriptionHistoryScreen();
/// ```
/// {@endtemplate}
class ResponsiveSubscriptionHistoryScreen extends StatelessWidget {
  /// Creates a [ResponsiveSubscriptionHistoryScreen].
  const ResponsiveSubscriptionHistoryScreen({
    super.key,
    this.userId,
    this.onTapSubscriptionHistoryCard,
  });

  final String? userId;

  final void Function(String partnerId)? onTapSubscriptionHistoryCard;

  @override
  Widget build(BuildContext context) {
    if (!StoycoScreenSize.isPhone(context)) {
      return SubscriptionHistoryWebScreen(
        userId: userId ?? '',
        onTapSubscriptionHistoryCard: onTapSubscriptionHistoryCard,
      );
    } else {
      return SubscriptionHistoryMobileScreen(
        userId: userId ?? '',
        onTapSubscriptionHistoryCard: onTapSubscriptionHistoryCard,
      );
    }
  }
}

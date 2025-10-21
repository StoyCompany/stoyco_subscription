import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template stoyco_tab_bar_v2}
/// A [StoycoTabBarV2] molecule for the Book Stack Atomic Design System.
/// Renders a styled tab bar with custom indicator, onboarding key support, and alert indicators for tab navigation.
///
/// ### Atomic Level
/// **Molecule** – Composed of multiple atoms (tabs, indicator) for navigation.
///
/// ### Parameters
/// - `tabController`: The [TabController] managing tab selection and animation.
/// - `tabs`: List of [SubscriptionStoycoTab] widgets to display as tabs.
/// - `showAlertIndicator`: If true, displays an alert indicator on tabs.
/// - `getOnboardingKey`: Optional callback to provide a [GlobalKey] for onboarding.
/// - `dividerColor`: Color of the divider below the tab bar. Defaults to transparent.
///
/// ### Returns
/// Renders a custom tab bar with styled indicator, onboarding key, and alert support.
///
/// ### Example
/// ```dart
/// StoycoTabBarV2(
///   tabController: controller,
///   tabs: [SubscriptionStoycoTab(title: 'Tab 1'), SubscriptionStoycoTab(title: 'Tab 2')],
///   initialNavIndex: 0,
///   showAlertIndicator: true,
/// )
/// ```
/// {@endtemplate}
class StoycoTabBarV2 extends StatelessWidget {
  const StoycoTabBarV2({
    super.key,
    required this.tabController,
    required this.tabs,
    this.showAlertIndicator = false,
    this.getOnboardingKey,
    this.dividerColor,
  });

  /// The [TabController] managing tab selection and animation.
  final TabController tabController;

  /// List of [SubscriptionStoycoTab] widgets to display as tabs.
  final List<SubscriptionStoycoTab> tabs;

  /// If true, displays an alert indicator on tabs.
  final bool showAlertIndicator;

  /// Optional callback to provide a [GlobalKey] for onboarding.
  final GlobalKey Function(int)? getOnboardingKey;

  /// Color of the divider below the tab bar. Defaults to transparent.
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final GlobalKey? onboardingKey;
    if (getOnboardingKey != null) {
      onboardingKey = getOnboardingKey!(2);
    } else {
      onboardingKey = null;
    }

    final List<SubscriptionStoycoTab> tabsWithKeys =
        List<SubscriptionStoycoTab>.from(tabs);

    if (onboardingKey != null && tabsWithKeys.isNotEmpty) {
      tabsWithKeys[0] = SubscriptionStoycoTab(
        key: onboardingKey,
        title: tabsWithKeys[0].title,
        showAlertIndicator: tabsWithKeys[0].showAlertIndicator,
      );
    }

    return Stack(
      children: <Widget>[
        SizedBox(
          height: StoycoScreenSize.height(context, 52),
          child: TabBar(
            isScrollable: false,
            padding: EdgeInsets.zero,
            controller: tabController,
            tabs: tabsWithKeys,
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: CustomTabIndicatorV2(controller: tabController),
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: StoycoScreenSize.fontSize(context, 16),
              fontFamily: FontFamilyToken.akkuratPro,
              fontWeight: FontWeight.w700,
              height: StoycoScreenSize.height(context, 1.50),
            ),
            unselectedLabelColor: StoycoColors.hint,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            dividerColor: dividerColor ?? Colors.transparent,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: Container(height: 1, color: StoycoColors.deepTeal),
        ),
      ],
    );
  }
}

class CustomTabIndicatorV2 extends Decoration {
  const CustomTabIndicatorV2({required this.controller});
  final TabController controller;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _CustomPainter(controller);
}

class _CustomPainter extends BoxPainter {
  _CustomPainter(this.controller);
  final TabController controller;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = StoycoColors.blue
      ..style = PaintingStyle.fill;

    final double tabWidth = configuration.size!.width;

    final Rect rect =
        Offset(offset.dx, configuration.size!.height - 12) &
        Size(tabWidth, 3.6);

    final RRect rrect = RRect.fromLTRBAndCorners(
      rect.left,
      rect.top,
      rect.right,
      rect.bottom,
      topLeft: const Radius.circular(5),
      topRight: const Radius.circular(5),
    );

    canvas.drawRRect(rrect, paint);
  }
}

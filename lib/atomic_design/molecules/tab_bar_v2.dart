import 'package:flutter/material.dart';

import 'package:stoyco_subscription/atomic_design/molecules/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';

class StoycoTabBarV2 extends StatelessWidget {
  const StoycoTabBarV2({
    super.key,
    required this.tabController,
    required this.tabs,
    this.showAlertIndicator = false,
    this.getOnboardingKey,
    this.dividerColor,
  });

  final TabController tabController;
  final List<SubscriptionStoycoTab> tabs;
  final bool showAlertIndicator;
  final Function(int)? getOnboardingKey;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final GlobalKey? onboardingKey = getOnboardingKey != null
        ? getOnboardingKey!(2) as GlobalKey
        : null;

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
      children: [
        SizedBox(
          height: 56,
          child: TabBar(
            padding: const EdgeInsets.all(0),
            controller: tabController,
            tabs: tabsWithKeys,
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: CustomTabIndicatorV2(controller: tabController),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: FontFamilyToken.akkuratPro,
              fontWeight: FontWeight.w700,
              height: 1.50,
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

    final double horizontalStart = offset.dx + (tabWidth - 121.31) / 2;
    final Rect rect =
        Offset(horizontalStart, configuration.size!.height - 12) &
        const Size(121.31, 3.6);

    final RRect rrect = RRect.fromLTRBAndCorners(
      rect.left,
      rect.top,
      rect.right,
      rect.bottom,
      topLeft: const Radius.circular(5),
      topRight: const Radius.circular(5),
    );

    final Shadow shadow = Shadow(color: StoycoColors.blue, blurRadius: 15.0);

    canvas.drawShadow(
      Path()..addRRect(rrect),
      shadow.color,
      shadow.blurRadius,
      true,
    );

    canvas.drawRRect(rrect, paint);
  }
}

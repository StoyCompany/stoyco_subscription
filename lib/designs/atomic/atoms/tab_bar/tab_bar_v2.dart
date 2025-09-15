import 'package:flutter/material.dart';

<<<<<<< HEAD:lib/atomic_design/molecules/tab_bar_v2.dart
import 'package:stoyco_subscription/atomic_design/molecules/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
=======
import 'package:stoyco_subscription/designs/atomic/molecules/taps/stoyco_subscription_tab.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
>>>>>>> e22c7a53cfa028149799be3a1471f11550b9860c:lib/designs/atomic/atoms/tab_bar/tab_bar_v2.dart

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
  final GlobalKey Function(int)? getOnboardingKey;
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
          height: 56,
          child: TabBar(
<<<<<<< HEAD:lib/atomic_design/molecules/tab_bar_v2.dart
            isScrollable: false,
            padding: const EdgeInsets.all(0),
=======
            padding: EdgeInsets.zero,
>>>>>>> e22c7a53cfa028149799be3a1471f11550b9860c:lib/designs/atomic/atoms/tab_bar/tab_bar_v2.dart
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

<<<<<<< HEAD:lib/atomic_design/molecules/tab_bar_v2.dart
=======
    const Shadow shadow = Shadow(color: StoycoColors.blue, blurRadius: 15.0);

    canvas.drawShadow(
      Path()..addRRect(rrect),
      shadow.color,
      shadow.blurRadius,
      true,
    );

>>>>>>> e22c7a53cfa028149799be3a1471f11550b9860c:lib/designs/atomic/atoms/tab_bar/tab_bar_v2.dart
    canvas.drawRRect(rrect, paint);
  }
}

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/subscription_indicator_position.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

/// Configuration class for the subscription indicator position

class SubscriptionLockedContent extends StatelessWidget {
  const SubscriptionLockedContent({
    super.key,
    required this.child,
    required this.isLocked,
    this.scale = 1.0,
    this.indicatorPosition = SubscriptionIndicatorPosition.defaultPosition,
    this.onLockedTap,
  });

  final Widget child;
  final bool isLocked;
  final double scale;
  final SubscriptionIndicatorPosition indicatorPosition;
  final VoidCallback? onLockedTap;

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return child;
    }

    return Stack(
      children: [
        Opacity(opacity: 1, child: IgnorePointer(child: child)),
        Positioned.fill(
          child: GestureDetector(
            onTap: onLockedTap,
            child: GlassmorphicContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: StoycoScreenSize.radius(context, 6),
              blur: 3,
              alignment: Alignment.center,
              border: 0,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.02),
                  Colors.white.withOpacity(0.01),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: indicatorPosition.left != null
                        ? StoycoScreenSize.width(
                            context,
                            indicatorPosition.left!,
                          )
                        : null,
                    right: indicatorPosition.right != null
                        ? StoycoScreenSize.width(
                            context,
                            indicatorPosition.right!,
                          )
                        : null,
                    top: indicatorPosition.top != null
                        ? StoycoScreenSize.height(
                            context,
                            indicatorPosition.top!,
                          )
                        : null,
                    bottom: indicatorPosition.bottom != null
                        ? StoycoScreenSize.height(
                            context,
                            indicatorPosition.bottom!,
                          )
                        : null,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: StoycoScreenSize.symmetric(
                          context,
                          horizontal: 15,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: StoycoColors.midnightInk,
                          borderRadius: BorderRadius.circular(
                            StoycoScreenSize.radius(context, 100),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: StoycoScreenSize.width(context, 8),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StoycoAssets
                                .lib
                                .assets
                                .icons
                                .exclusiveContent
                                .subsciptionButtonIcon
                                .svg(
                                  package: 'stoyco_subscription',
                                  width: StoycoScreenSize.width(context, 13),
                                  height: StoycoScreenSize.height(context, 13),
                                ),
                            Text(
                              'Contenido exclusivo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  12,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/lock_subscription/subscription_indicator_position.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

/// {@template subscription_locked_content}
/// A widget that overlays locked content with a glassmorphic blur effect and a subscription indicator.
///
/// This widget wraps any child widget and applies a customizable blur effect with an overlay
/// when content is locked behind a subscription. It displays an "Exclusive Content" indicator
/// that can be positioned anywhere on the overlay.
///
/// The glassmorphic effect and blur intensity can be customized to work optimally across
/// different platforms (mobile vs web), as blur rendering varies between platforms.
///
/// **Platform-Specific Recommendations:**
///
/// **Mobile (Default):**
/// ```dart
/// SubscriptionLockedContent(
///   isLocked: true,
///   child: MyContent(),
/// )
/// ```
///
/// **Web (Enhanced Blur):**
/// ```dart
/// SubscriptionLockedContent(
///   isLocked: true,
///   blurIntensity: 5,
///   overlayOpacityStart: 0.8,
///   overlayOpacityEnd: 0.7,
///   overlayColor: Colors.black,
///   childOpacity: 0.3,
///   child: MyVideoPlayer(),
/// )
/// ```
///
/// **Conditional Platform Setup:**
/// ```dart
/// SubscriptionLockedContent(
///   isLocked: true,
///   blurIntensity: kIsWeb ? 5 : 3,
///   overlayOpacityStart: kIsWeb ? 0.8 : 0.02,
///   overlayOpacityEnd: kIsWeb ? 0.7 : 0.01,
///   overlayColor: kIsWeb ? Colors.black : Colors.white,
///   childOpacity: kIsWeb ? 0.3 : 1.0,
///   child: MyContent(),
/// )
/// ```
/// {@endtemplate}
class SubscriptionLockedContent extends StatelessWidget {
  /// Creates a [SubscriptionLockedContent] widget.
  ///
  /// The [child] and [isLocked] parameters are required.
  /// All blur and overlay parameters are optional with sensible defaults for mobile.
  ///
  /// {@macro subscription_locked_content}
  const SubscriptionLockedContent({
    super.key,
    required this.child,
    required this.isLocked,
    this.scale = 1.0,
    this.indicatorPosition = SubscriptionIndicatorPosition.defaultPosition,
    this.onLockedTap,
    this.blurIntensity = 3,
    this.overlayOpacityStart = 0.02,
    this.overlayOpacityEnd = 0.01,
    this.borderOpacityStart = 0.05,
    this.borderOpacityEnd = 0.02,
    this.overlayColor = Colors.white,
    this.childOpacity = 1.0,
  });

  /// The widget to be locked/unlocked behind the subscription overlay.
  final Widget child;

  /// Whether the content should be locked with the glassmorphic overlay.
  ///
  /// When `false`, returns the [child] widget without any overlay.
  /// When `true`, applies the blur effect and shows the subscription indicator.
  final bool isLocked;

  /// Scale factor for the subscription indicator badge.
  ///
  /// Defaults to `1.0`. Use values like `0.8` or `1.2` to make the badge smaller or larger.
  final double scale;

  /// Position configuration for the subscription indicator badge.
  ///
  /// Determines where the "Exclusive Content" badge appears on the overlay.
  /// Defaults to [SubscriptionIndicatorPosition.defaultPosition].
  ///
  /// Example:
  /// ```dart
  /// indicatorPosition: SubscriptionIndicatorPosition(
  ///   top: 20,
  ///   left: 10,
  /// )
  /// ```
  final SubscriptionIndicatorPosition indicatorPosition;

  /// Callback invoked when the locked overlay is tapped.
  ///
  /// Typically used to navigate to a subscription purchase screen or show
  /// a subscription modal dialog.
  ///
  /// Example:
  /// ```dart
  /// onLockedTap: () {
  ///   Navigator.push(context, MaterialPageRoute(
  ///     builder: (_) => SubscriptionPurchaseScreen(),
  ///   ));
  /// }
  /// ```
  final VoidCallback? onLockedTap;

  /// Intensity of the blur effect applied to the content.
  ///
  /// Defaults to `3` for mobile, which provides a subtle blur.
  ///
  /// **Platform-Specific Recommendations:**
  /// - **Mobile**: `2-5` (lower values work better on mobile)
  /// - **Web**: `3-8` (web can handle slightly higher blur, but don't go too high)
  ///
  /// Note: Very high blur values (>10) may cause performance issues and
  /// inconsistent rendering across platforms.
  final double blurIntensity;

  /// Starting opacity for the glassmorphic overlay gradient (top-left corner).
  ///
  /// Defaults to `0.02` for a very subtle overlay on mobile.
  ///
  /// **Platform-Specific Recommendations:**
  /// - **Mobile**: `0.02-0.1` (subtle, transparent overlay)
  /// - **Web**: `0.6-0.9` (stronger overlay for better content occlusion)
  ///
  /// Use higher values when you need to hide content more effectively,
  /// especially for video or animated content on web.
  final double overlayOpacityStart;

  /// Ending opacity for the glassmorphic overlay gradient (bottom-right corner).
  ///
  /// Defaults to `0.01` for a very subtle gradient on mobile.
  ///
  /// **Platform-Specific Recommendations:**
  /// - **Mobile**: `0.01-0.05`
  /// - **Web**: `0.5-0.8`
  ///
  /// Should typically be slightly lower than [overlayOpacityStart] to create
  /// a subtle gradient effect.
  final double overlayOpacityEnd;

  /// Starting opacity for the glassmorphic border gradient.
  ///
  /// Defaults to `0.05`. This creates a subtle border effect around the overlay.
  final double borderOpacityStart;

  /// Ending opacity for the glassmorphic border gradient.
  ///
  /// Defaults to `0.02`. Should be lower than [borderOpacityStart].
  final double borderOpacityEnd;

  /// Color of the overlay gradient.
  ///
  /// Defaults to [Colors.white] for a bright, light overlay effect on mobile.
  ///
  /// **Platform-Specific Recommendations:**
  /// - **Mobile**: [Colors.white] (light, subtle overlay)
  /// - **Web**: [Colors.black] (dark overlay for better content hiding)
  ///
  /// Black overlays are more effective at obscuring underlying content,
  /// especially for video or animated content on web platforms.
  final Color overlayColor;

  /// Opacity of the child widget when locked.
  ///
  /// Defaults to `1.0` (fully visible) for mobile, where the blur effect alone
  /// is usually sufficient.
  ///
  /// **Platform-Specific Recommendations:**
  /// - **Mobile**: `1.0` (child remains fully visible)
  /// - **Web (video/animation)**: `0.2-0.4` (reduces child opacity for better hiding)
  /// - **Web (static images)**: `0.5-0.7` (moderate opacity reduction)
  ///
  /// Reducing child opacity is particularly useful on web for video content
  /// where blur alone may not be sufficient to hide the content.
  final double childOpacity;

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return child;
    }

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: childOpacity,
          child: IgnorePointer(child: child),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: onLockedTap,
            child: GlassmorphicContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: StoycoScreenSize.radius(context, 16),
              blur: blurIntensity,
              alignment: Alignment.center,
              border: 0,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  overlayColor.withOpacity(overlayOpacityStart),
                  overlayColor.withOpacity(overlayOpacityEnd),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.white.withOpacity(borderOpacityStart),
                  Colors.white.withOpacity(borderOpacityEnd),
                ],
              ),
              child: Stack(
                children: <Widget>[
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
                          children: <Widget>[
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

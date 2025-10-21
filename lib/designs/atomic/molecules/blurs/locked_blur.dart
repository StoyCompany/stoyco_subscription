import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_locked.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template locked_blur}
/// A [LockedBlur] molecule for the Stoyco Subscription Atomic Design System.
/// Renders a blur overlay with a lock icon and message, used to indicate restricted or exclusive content.
///
/// ### Overview
/// Displays a child widget with an optional blur and overlay, and a lock tag positioned by alignment. Useful for paywalls, premium content, or restricted UI sections.
///
/// ### Atomic Level
/// **Molecule** – Composed of atoms (blur, tag, overlay).
///
/// ### Parameters
/// - `isLocked`: Whether the blur and lock overlay are shown. Defaults to true.
/// - `onTapElementExclusive`: Callback when the locked element is tapped.
/// - `child`: The widget displayed beneath the blur and lock overlay.
/// - `blurSigmaX`: Horizontal blur intensity. Defaults to 2.5.
/// - `blurSigmaY`: Vertical blur intensity. Defaults to 2.5.
/// - `overlayColor`: Color overlay above the blur. Defaults to black.
/// - `overlayOpacity`: Opacity of the overlay color. Defaults to 0.3.
/// - `radius`: Border radius for the blur overlay. Defaults to 0.
/// - `borderRadius`: Custom border radius for the blur overlay. Optional.
/// - `alignment`: Alignment of the lock icon. Defaults to [Alignment.topRight].
/// - `width`: Width of the widget. Optional.
/// - `height`: Height of the widget. Defaults to 144.0.
///
/// ### Returns
/// A widget that overlays a blur and lock tag above its child, suitable for restricted or exclusive content.
///
/// ### Example
/// ```dart
/// LockedBlur(
///   isLocked: true,
///   child: Image.network('https://example.com/image.jpg'),
///   onTapElementExclusive: () {},
/// )
/// ```
/// {@endtemplate}
class LockedBlur extends StatelessWidget {
  /// {@macro locked_blur}
  const LockedBlur({
    super.key,
    this.isLocked = true,
    this.onTapElementExclusive,
    required this.child,
    this.blurSigmaX = 2.5,
    this.blurSigmaY = 2.5,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.3,
    this.radius = 0,
    this.borderRadius,
    this.alignment = Alignment.topRight,
    this.width,
    this.height = 144.0,
  });
  
  /// Whether the blur and lock overlay are shown. Defaults to true.
  final bool isLocked;

  /// Callback when the locked element is tapped.
  final VoidCallback? onTapElementExclusive;

  /// The widget displayed beneath the blur and lock overlay.
  final Widget child;

  /// Width of the widget. Optional.
  final double? width;

  /// Height of the widget. Defaults to 144.0.
  final double? height;

  /// Horizontal blur intensity. Defaults to 2.5.
  final double blurSigmaX;

  /// Vertical blur intensity. Defaults to 2.5.
  final double blurSigmaY;

  /// Color overlay above the blur. Defaults to black.
  final Color overlayColor;

  /// Opacity of the overlay color. Range 0.0–1.0. Defaults to 0.3.
  final double overlayOpacity;

  /// Border radius for the blur overlay. Defaults to 0.
  final double radius;

  /// Custom border radius for the blur overlay. Optional.
  final BorderRadiusGeometry? borderRadius;

  /// Alignment of the lock icon. Defaults to [Alignment.topRight].
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? onTapElementExclusive : null,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            child,
            if (isLocked) ...<Widget>[
              ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(StoycoScreenSize.radius(context, radius)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigmaX,
                    sigmaY: blurSigmaY,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Align(alignment: alignment, child: const TagLocked(isLocked: true)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

  /// {@template skeleton_card}
  /// A [SkeletonCard] atom for the Stoyco Subscription Atomic Design System.
  /// Displays a shimmering skeleton placeholder for loading states, using animated gradients.
  ///
  /// ### Atomic Level
  /// **Atom** – Smallest UI unit.
  ///
  /// ### Parameters
  /// - `width`: The width of the skeleton card. If null, expands to parent constraints.
  /// - `height`: The height of the skeleton card. If null, expands to parent constraints.
  /// - `borderRadius`: The border radius of the skeleton card. Defaults to 25 if not provided.
  /// - `margin`: The margin around the skeleton card. If null, no margin is applied.
  ///
  /// ### Returns
  /// Renders a shimmering skeleton card using [Shimmer] and design token colors.
  ///
  /// ### Example
  /// ```dart
  /// SkeletonCard(
  ///   width: 200,
  ///   height: 100,
  ///   borderRadius: BorderRadius.circular(16),
  ///   margin: EdgeInsets.all(8),
  /// )
  /// ```
  /// {@endtemplate}
class SkeletonCard extends StatelessWidget {
  /// {@macro skeleton_card}
  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.borderRadius,
  });

  /// The width of the skeleton card. If null, expands to parent constraints.
  final double? width;

  /// The height of the skeleton card. If null, expands to parent constraints.
  final double? height;

  /// The border radius of the skeleton card. Defaults to 25 if not provided.
  final BorderRadius? borderRadius;

  /// The margin around the skeleton card. If null, no margin is applied.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: width,
    margin: margin,
    child: ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(StoycoScreenSize.radius(context, 25)),
      child: Shimmer.fromColors(
        baseColor: StoycoColors.skeletonBase,
        highlightColor: StoycoColors.skeletonHighlight,
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

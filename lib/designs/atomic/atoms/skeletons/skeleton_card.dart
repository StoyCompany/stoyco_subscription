import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class SkeletonCard extends StatelessWidget {
  /// {@template skeleton_card}
  /// SkeletonCard
  ///
  /// An atomic design widget that displays a shimmering skeleton placeholder for loading states.
  ///
  /// This widget uses the [shimmer](https://pub.dev/packages/shimmer) package to animate a gradient effect, simulating content loading.
  ///
  /// It supports design tokens for colors, border radius, and spacing, ensuring consistency in atomic design systems.
  ///
  /// Example usage:
  /// ```dart
  /// SkeletonCard(
  ///   width: 200,
  ///   height: 100,
  ///   borderRadius: BorderRadius.circular(16),
  ///   margin: EdgeInsets.all(8),
  /// )
  /// ```
  /// {@endtemplate}
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
      child: Stack(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: StoycoColors.skeletonBase,
            highlightColor: StoycoColors.skeletonHighlight,
            child: Container(
              height: height,
            ),
          ),
        ],
      ),
    ),
  );
}

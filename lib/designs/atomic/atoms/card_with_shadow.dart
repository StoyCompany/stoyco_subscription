import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/gradient_border_painter.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template card_with_shadow}
/// CardWithShadow
///
/// An atomic design widget that provides a customizable card container with optional padding, margin, shadow, border, and gradient.
///
/// This widget is designed for use in atomic design systems, serving as a foundational "atom" for building more complex UI molecules and organisms.
///
/// It supports design tokens for colors, gradients, and spacing, ensuring consistency and maintainability across your design system.
///
/// Example usage:
/// ```dart
/// CardWithShadow(
///   child: Text('Content'),
///   backgroundColor: StoycoColors.cardBackgroundBlack50,
///   shadowColor: StoycoColors.cardShadowPurple19,
///   gradientColorsBorder: [
///     StoycoColors.cardBorderGradientEnd,
///     StoycoColors.cardBorderGradientWhite05,
///     StoycoColors.cardBorderGradientWhite15,
///     StoycoColors.cardBorderGradientPurple57,
///     StoycoColors.cardBorderGradientPurple72,
///     StoycoColors.cardBorderGradientMid,
///   ],
/// )
/// ```
/// {@endtemplate}
class CardWithShadow extends StatelessWidget {
  const CardWithShadow({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.borderWidth = 2,
    this.padding,
    this.paddingChildren,
    this.margin,
    this.shadowColor,
    this.shadowOffset = const Offset(5, 6),
    this.shadowBlurRadius = 15,
    this.shadowSpreadRadius = 12,
    this.backgroundColor,
    this.gradientChildren, 
    this.gradientColorsBorder,
  });

  /// The widget below the card, typically the main content.
  final Widget child;

  /// The width of the card. If null, the card will size to its child.
  final double? width;

  /// The height of the card. If null, the card will size to its child.
  final double? height;

  /// The border radius of the card. Defaults to 24.
  final double borderRadius;

  /// The width of the border. Defaults to 2.
  final double borderWidth;

  /// The margin around the card. If null, uses the default design token spacing.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the card. If null, uses the default design token spacing.
  final EdgeInsetsGeometry? padding;

  /// The padding for the child widget inside the card. If null, uses the default design token spacing.
  final EdgeInsetsGeometry? paddingChildren;

  /// The color of the card's shadow. If null, uses the default design token color.
  final Color? shadowColor;

  /// The offset of the card's shadow. Defaults to Offset(5, 6).
  final Offset shadowOffset;

  /// The blur radius of the card's shadow. Defaults to 15.
  final double shadowBlurRadius;

  /// The spread radius of the card's shadow. Defaults to 12.
  final double shadowSpreadRadius;

  /// The background color of the card. If null, uses the default design token color.
  final Color? backgroundColor;

  /// The gradient applied to the card's child container. If null, uses a default vertical gradient.
  final Gradient? gradientChildren;

  /// The list of colors used for the card's border gradient. If null, uses the default design token gradient.
  final List<Color>? gradientColorsBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? StoycoScreenSize.fromLTRB(context, top: 8, bottom: 8, left: 26, right: 18),
      child: Container(
        margin: margin ?? StoycoScreenSize.fromLTRB(context, left: 7, top: 4, right: 7, bottom: 4),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          color: backgroundColor ?? StoycoColors.cardBackgroundBlack50,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowColor ?? StoycoColors.cardShadowPurple19,
              offset: shadowOffset,
              blurRadius: shadowBlurRadius,
              spreadRadius: shadowSpreadRadius,
            ),
          ],
        ),
        child: CustomPaint(
          painter: GradientBorderPainter(
            borderRadius: borderRadius - borderWidth,
            borderWidth: borderWidth,
            gradientColors: gradientColorsBorder,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              gradient: gradientChildren ?? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  StoycoColors.cardBackgroundBlack50,
                  StoycoColors.cardBackgroundBlack50,
                ],
              ),
            ),
            padding: paddingChildren ?? StoycoScreenSize.fromLTRB(context, left: 8, top: 8, right: 8, bottom: 32),
            child: child,
          ),
        ),
      ),
    );
  }
}

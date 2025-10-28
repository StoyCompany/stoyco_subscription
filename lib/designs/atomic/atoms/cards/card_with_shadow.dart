import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/borders/gradient_border_painter.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template card_with_shadow}
/// A [CardWithShadow] atom for the Stoyco Subscription Atomic Design System.
/// Renders a card with customizable shadow, border, gradient, and padding, suitable for displaying content with visual emphasis.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `child`: The widget below the card, typically the main content.
/// - `width`: The width of the card. If null, the card will size to its child.
/// - `height`: The height of the card. If null, the card will size to its child.
/// - `borderRadius`: The border radius of the card. Defaults to 24.
/// - `borderWidth`: The width of the border. Defaults to 2.
/// - `margin`: The margin around the card. If null, uses the default design token spacing.
/// - `padding`: The padding inside the card. If null, uses the default design token spacing.
/// - `paddingChildren`: The padding for the child widget inside the card. If null, uses the default design token spacing.
/// - `shadowColor`: The color of the card's shadow. If null, uses the default design token color.
/// - `shadowOffset`: The offset of the card's shadow. Defaults to Offset(5, 6).
/// - `shadowBlurRadius`: The blur radius of the card's shadow. Defaults to 15.
/// - `shadowSpreadRadius`: The spread radius of the card's shadow. Defaults to 12.
/// - `backgroundColor`: The background color of the card. If null, uses the default design token color.
/// - `gradientChildren`: The gradient applied to the card's child container. If null, uses a default vertical gradient.
/// - `gradientColorsBorder`: The list of colors used for the card's border gradient. If null, uses the default design token gradient.
///
/// ### Returns
/// Renders a card with shadow, gradient border, and customizable child container.
///
/// ### Example
/// ```dart
/// CardWithShadow(
///   child: Text('Premium Plan'),
///   backgroundColor: Colors.white,
///   gradientColorsBorder: [Colors.purple, Colors.blue],
/// )
/// ```
/// {@endtemplate}
class CardWithShadow extends StatelessWidget {

  /// {@macro card_with_shadow}
  const CardWithShadow({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.borderWidth = 2,
    this.padding,
    this.paddingChildren = EdgeInsets.zero,
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
            padding: paddingChildren,
            child: child,
          ),
        ),
      ),
    );
  }
}

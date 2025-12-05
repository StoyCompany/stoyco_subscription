import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';


/// {@template button_gradient}
/// A [ButtonGradient] atom for the Stoyco Subscription Atomic Design System.
/// Renders a customizable button with gradient borders, background, and interactive states for modern UI experiences.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `child`: Button content widget.
/// - `onPressed`: Callback when the button is pressed.
/// - `width`: Width of the button.
/// - `height`: Height of the button.
/// - `backgroundColor`: Background color.
/// - `hoverColor`: Color when hovered.
/// - `splashColor`: Splash color on tap.
/// - `focusColor`: Color when focused.
/// - `highlightColor`: Color when highlighted.
/// - `backgroundGradientColor`: Gradient for the background.
/// - `gradientBorder`: Gradient for the border.
/// - `borderRadius`: Border radius for rounded corners.
/// - `boxShadow`: Box shadow(s) for elevation.
/// - `padding`: Padding inside the button.
///
/// ### Returns
/// Renders an [InkWell] button with gradient border, background, and interactive effects, wrapping the provided child widget.
///
/// ### Example
/// ```dart
/// ButtonGradient(
///   child: Text('Subscribe'),
///   onPressed: () {},
///   backgroundColor: Colors.white,
///   gradientBorder: GradientBoxBorder(
///     gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
///   ),
/// )
/// ```
/// {@endtemplate}
class ButtonGradient extends StatelessWidget {
  /// {@macro button_gradient}
  const ButtonGradient({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    this.focusColor,
    this.highlightColor,
    this.backgroundGradientColor,
    this.gradientBorder,
    this.borderRadius = 0,
    this.boxShadow,
    this.padding,
    this.alignmentContent,
  });

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Button content widget.
  final Widget child;

  /// Width of the button.
  final double? width;

  /// Height of the button.
  final double? height;

  /// Background color.
  final Color? backgroundColor;

  /// Color when hovered.
  final Color? hoverColor;

  /// Splash color on tap.
  final Color? splashColor;

  /// Color when focused.
  final Color? focusColor;

  /// Color when highlighted.
  final Color? highlightColor;

  /// Gradient for the background.
  final Gradient? backgroundGradientColor;

  /// Gradient for the border.
  final GradientBoxBorder? gradientBorder;

  /// Border radius for rounded corners.
  final double borderRadius;

  /// Box shadow(s) for elevation.
  final List<BoxShadow>? boxShadow;

  /// Padding inside the button.
  final EdgeInsetsGeometry? padding;

  /// Alignment for the content inside the button.
  final Alignment? alignmentContent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor ?? StoycoColors.transparent,
      highlightColor: highlightColor ?? StoycoColors.transparent,
      focusColor: focusColor ?? StoycoColors.transparent,
      hoverColor: hoverColor ?? StoycoColors.transparent,
      onTap: onPressed,
      child: Padding(
        padding: padding ?? EdgeInsetsGeometry.zero,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height ?? StoycoScreenSize.height(context, 29)),
          child: Container(
            width: width ?? double.infinity,
            alignment: alignmentContent,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadius)),
              gradient: backgroundGradientColor,
              boxShadow: boxShadow,
              border: gradientBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template button_gradient}
/// Native Flutter button with gradient borders, part of the atomic design system.
/// Highly customizable, with sensible defaults matching design tokens.
///
/// Default styles:
/// - Border: 1.06px solid gradient (vertical, darkBlue to blue)
/// - Box shadow: 4.24px 4.24px 59.36px 0px shadowBlue
/// - Background color: text
///
/// Example usage:
/// ```dart
/// ButtonGradient(
///   onPressed: () {},
///   child: Text('Button'),
/// )
/// ```
/// {@endtemplate}
class ButtonGradient extends StatelessWidget {
  /// Creates a button with gradient borders and custom styles.
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
    this.borderRadius,
    this.boxShadow,
    this.padding,
  });

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Button content.
  final Widget child;

  /// Width of the button.
  final double? width;

  /// Height of the button.
  final double? height;

  /// Background color.
  final Color? backgroundColor;

  /// Hover color.
  final Color? hoverColor;

  /// Splash color.
  final Color? splashColor;

  /// Focus color.
  final Color? focusColor;

  /// Highlight color.
  final Color? highlightColor;

  /// Gradient for the background.
  final Gradient? backgroundGradientColor;

  /// Gradient for the border.
  final GradientBoxBorder? gradientBorder;

  /// Border radius.
  final double? borderRadius;

  /// Box shadow(s).
  final List<BoxShadow>? boxShadow;

  /// Padding inside the button.
  final EdgeInsetsGeometry? padding;

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
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
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

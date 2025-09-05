import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';


/// {@template gradient_border_painter}
/// GradientBorderPainter
///
/// An atomic design custom painter that draws a gradient border around a widget.
///
/// This painter is intended for use in atomic design systems, providing a reusable visual effect for card borders and other UI atoms.
///
/// It supports design tokens for border radius, width, and gradient colors, ensuring consistency and maintainability across your design system.
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   painter: GradientBorderPainter(
///     borderRadius: 24,
///     borderWidth: 2,
///     gradientColors: [
///       StoycoColors.cardBorderGradientEnd,
///       StoycoColors.cardBorderGradientWhite05,
///       StoycoColors.cardBorderGradientWhite15,
///       StoycoColors.cardBorderGradientPurple57,
///       StoycoColors.cardBorderGradientPurple72,
///       StoycoColors.cardBorderGradientMid,
///     ],
///   ),
///   child: ...,
/// )
/// ```
/// {@endtemplate}
class GradientBorderPainter extends CustomPainter {

  GradientBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    this.gradientColors,
  });

  /// The border radius for the border. Controls the roundness of the corners.
  final double borderRadius;

  /// The width of the border stroke.
  final double borderWidth;

  /// The list of colors used for the border gradient. If null, uses the default design token gradient.
  final List<Color>? gradientColors;

  /// Paints the gradient border on the given canvas and size.
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors ?? const <Color>[
          StoycoColors.cardBorderGradientEnd,
          StoycoColors.cardBorderGradientWhite05,
          StoycoColors.cardBorderGradientWhite15,
          StoycoColors.cardBorderGradientWhite15,
          StoycoColors.cardBorderGradientPurple57,
          StoycoColors.cardBorderGradientPurple72,
          StoycoColors.cardBorderGradientMid,
          StoycoColors.cardBorderGradientMid,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(rrect, paint);
  }

  /// Determines whether the painter should repaint when its properties change.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

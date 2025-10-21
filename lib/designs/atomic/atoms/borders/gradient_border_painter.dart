import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';


/// {@template gradient_border_painter}
/// A [GradientBorderPainter] atom for the Book Stack Atomic Design System.
/// Paints a rounded rectangle border with a customizable vertical gradient, suitable for cards and containers.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `borderRadius`: The border radius for the border. Controls the roundness of the corners.
/// - `borderWidth`: The width of the border stroke.
/// - `gradientColors`: The list of colors used for the border gradient. If null, uses the default design token gradient.
///
/// ### Returns
/// Renders a gradient border around a rounded rectangle using [CustomPainter].
///
/// ### Example
/// ```dart
/// CustomPaint(
///   painter: GradientBorderPainter(
///     borderRadius: 16,
///     borderWidth: 2,
///   ),
///   child: Container(width: 100, height: 50),
/// )
/// ```
/// {@endtemplate}
class GradientBorderPainter extends CustomPainter {

  /// {@macro gradient_border_painter}
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

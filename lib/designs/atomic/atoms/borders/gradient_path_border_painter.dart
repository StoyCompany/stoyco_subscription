
import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

/// {@template gradient_path_border_painter}
/// A [GradientPathBorderPainter] atom for the Book Stack Atomic Design System.
/// Paints a custom path border with a configurable gradient, ideal for advanced card and container shapes.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `path`: Path on which the border is drawn.
/// - `borderWidth`: Border width.
/// - `gradientColors`: Gradient colors for the border. Defaults to a design token gradient.
/// - `gradientBegin`: Gradient start alignment. Defaults to [Alignment.topCenter].
/// - `gradientEnd`: Gradient end alignment. Defaults to [Alignment.bottomCenter].
///
/// ### Returns
/// Renders a gradient border along a custom path using [CustomPainter].
///
/// ### Example
/// ```dart
/// CustomPaint(
///   painter: GradientPathBorderPainter(
///     path: Path()..addOval(Rect.fromLTWH(0, 0, 100, 50)),
///     borderWidth: 2,
///   ),
///   child: Container(width: 100, height: 50),
/// )
/// ```
/// {@endtemplate}
class GradientPathBorderPainter extends CustomPainter {

  /// {@macro gradient_path_border_painter}
  const GradientPathBorderPainter({
    required this.path,
    required this.borderWidth,
    this.gradientBegin = Alignment.topCenter,
    this.gradientEnd = Alignment.bottomCenter,
    this.gradientColors = const <Color>[
      StoycoColors.transparent,
      StoycoColors.transparent,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite15,
      StoycoColors.cardBorderGradientWhite15,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite15,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.cardBorderGradientWhite05,
      StoycoColors.transparent,
      StoycoColors.transparent,
    ],
  });

  /// Path on which the border is drawn.
  final Path path;

  /// Border width.
  final double borderWidth;

  /// Gradient colors for the border. Defaults to a design token gradient.
  final List<Color> gradientColors;

  /// Gradient start alignment. Defaults to [Alignment.topCenter].
  final Alignment gradientBegin;

  /// Gradient end alignment. Defaults to [Alignment.bottomCenter].
  final Alignment gradientEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: gradientBegin,
        end: gradientEnd,
        colors: gradientColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

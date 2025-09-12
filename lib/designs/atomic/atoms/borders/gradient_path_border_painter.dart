
import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

class GradientPathBorderPainter extends CustomPainter {
  /// {@template gradient_path_border_painter}
  /// Native Flutter component for painting gradient borders on a [Path].
  ///
  /// This component is part of Stoyco's atomic design system.
  /// It allows you to customize the border of any shape using linear gradients,
  /// ideal for visual tokens and reusable atoms.
  ///
  /// Example usage:
  /// ```dart
  /// CustomPaint(
  ///   painter: GradientPathBorderPainter(
  ///     path: myPath,
  ///     borderWidth: 2,
  ///     gradientColors: [Colors.red, Colors.blue],
  ///   ),
  ///   child: ...
  /// )
  /// ```
  /// {@endtemplate}
  ///
  /// Parameters:
  /// - [path]: Path on which the border is drawn.
  /// - [borderWidth]: Border width.
  /// - [gradientColors]: Gradient colors (optional).
  /// - [gradientBegin]: Gradient start alignment.
  /// - [gradientEnd]: Gradient end alignment.
  ///
  /// This component will not break the app if the path is invalid; nothing will be drawn.
  /// Creates a gradient border painter for a [Path].
  ///
  /// Part of Stoyco's atomic design system.
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
  /// Gradient colors.
  final List<Color> gradientColors;
  /// Gradient start alignment.
  final Alignment gradientBegin;
  /// Gradient end alignment.
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

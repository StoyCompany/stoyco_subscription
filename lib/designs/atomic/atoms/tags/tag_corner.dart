import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/borders/gradient_path_border_painter.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/round_polygons.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/designs/types/tag_corner_position.dart';

class TagCorner extends StatelessWidget {
  /// {@template tag_corner}
  /// Native Flutter component for rendering a corner tag with a diagonal cut.
  ///
  /// This widget is part of Stoyco's atomic design system.
  /// It allows you to display a tag with a customizable cut in any corner (topRight, topLeft, bottomRight, bottomLeft),
  /// with gradient borders, shadows, and text rotation handled automatically.
  ///
  /// Example usage:
  /// ```dart
  /// TagCorner(
  ///   title: 'Recommended',
  ///   position: TagCornerPosition.bottomLeft,
  ///   color: Colors.blue,
  ///   cornerRadius: 16,
  ///   borderWidth: 2,
  ///   gradientColorsBorder: [Colors.red, Colors.blue],
  /// )
  /// ```
  ///
  /// Parameters:
  /// - [title]: Text to display inside the tag.
  /// - [position]: Which corner to cut (default: topRight).
  /// - [color]: Background color of the tag.
  /// - [cornerRadius]: Radius of the diagonal cut.
  /// - [borderWidth]: Width of the gradient border.
  /// - [gradientColorsBorder]: Colors for the gradient border.
  /// - [shadows]: Optional list of shadows.
  /// - [width], [height]: Size of the tag.
  /// - [textStyle]: Custom text style.
  ///
  /// This widget is designed for atomic design systems and can be reused across your app for consistent UI tokens.
  /// {@endtemplate}
  const TagCorner({
    super.key,
    required this.title,
    this.textStyle,
    this.paddingText,
    this.width = 100,
    this.height = 100,
    this.color = StoycoColors.blue,
    this.cutSize = 48,
    this.cornerRadius = 20,
    this.borderWidth = 4,
    this.gradientColorsBorder = const <Color>[
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
    this.position = TagCornerPosition.topRight,
    this.shadows = const <BoxShadow>[
      BoxShadow(
        color: StoycoColors.shadowPurple98,
        offset: Offset(-15, 10),
        blurRadius: 50,
        spreadRadius: 20,
      ),
    ],
  });

  /// Text to display inside the tag.
  final String title;

  /// Background color of the tag.
  final Color color;

  /// Custom text style for the tag text.
  final TextStyle? textStyle;

  /// Padding around the text inside the tag.
  final EdgeInsets? paddingText;

  /// Width of the tag.
  final double width;

  /// Height of the tag.
  final double height;

  /// Depth of the diagonal cut in the selected corner.
  final double cutSize;

  /// Radius of the diagonal cut corner.
  final double cornerRadius;

  /// Width of the gradient border.
  final double borderWidth;

  /// Colors for the gradient border.
  final List<Color> gradientColorsBorder;

  /// Which corner to cut (default: topRight).
  final TagCornerPosition position;

  /// Optional list of shadows for the tag.
  final List<BoxShadow> shadows;

  @override
  Widget build(BuildContext context) {
    try {
      final Rect rect = Offset.zero & Size(
        StoycoScreenSize.width(context, width),
        StoycoScreenSize.height(context, height),
      );
      final List<Offset> points = getTagCornerPolygonPoints(rect, position);
      final List<double> radii = getTagCornerPolygonRadii(cornerRadius);
      final Path shapePath = roundPolygon(
        points: points,
        radii: radii,
      );

      return Container(
        height: StoycoScreenSize.height(context, height),
        width: StoycoScreenSize.width(context, width),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: color,
          shadows: shadows,
          shape: PathBuilderBorder(
            pathBuilder: (Rect r, double _) {
              return roundPolygon(
                points: getTagCornerPolygonPoints(r, position),
                radii: getTagCornerPolygonRadii(cornerRadius),
              );
            },
          ),
        ),
        child: CustomPaint(
          painter: GradientPathBorderPainter(
            path: shapePath,
            borderWidth: borderWidth,
            gradientColors: gradientColorsBorder,
            gradientEnd: Alignment.bottomRight,
          ),
          child: Center(
            child: Transform.rotate(
              angle: getTagCornerTextRotation(position),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: paddingText ?? StoycoScreenSize.fromLTRB(context, top: 14),
                  child: Text(
                    title,
                    style: textStyle ?? GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: StoycoColors.softWhite,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: StoycoScreenSize.fontSize(context, 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}

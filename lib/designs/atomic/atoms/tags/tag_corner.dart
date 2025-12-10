
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/borders/gradient_path_border_painter.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/round_polygons.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/designs/types/tag_corner_position.dart';

/// {@template tag_corner}
/// A [TagCorner] atom for the Stoyco Subscription Atomic Design System.
/// Renders a corner tag with a diagonal cut, gradient border, and customizable text, color, and position.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `title`: Text to display inside the tag.
/// - `textStyle`: Custom text style for the tag text.
/// - `paddingText`: Padding around the text inside the tag.
/// - `showExclamationIcon`: Whether to show an exclamation icon above the text.
/// - `width`: Width of the tag. Defaults to 100.
/// - `height`: Height of the tag. Defaults to 100.
/// - `color`: Background color of the tag. Defaults to [StoycoColors.blue].
/// - `cutSize`: Depth of the diagonal cut in the selected corner. Defaults to 48.
/// - `cornerRadius`: Radius of the diagonal cut corner. Defaults to 20.
/// - `borderWidth`: Width of the gradient border. Defaults to 4.
/// - `gradientColorsBorder`: Colors for the gradient border. Defaults to design token gradient.
/// - `position`: Which corner to cut (default: [TagCornerPosition.topRight]).
/// - `shadows`: Optional list of shadows for the tag. Defaults to [StoycoColors.shadowPurple98].
///
/// ### Returns
/// Renders a corner tag with diagonal cut, gradient border, and styled text, suitable for atomic design systems.
///
/// ### Example
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
/// {@endtemplate}
class TagCorner extends StatelessWidget {
/// {@macro tag_corner}
  /// Creates a [TagCorner] atom for the Stoyco Subscription Design System.
  ///
  /// - [title]: Text to display inside the tag.
  /// - [textStyle]: Custom text style for the tag text.
  /// - [paddingText]: Padding around the text inside the tag.
  /// - [showExclamationIcon]: Whether to show an exclamation icon above the text.
  /// - [width]: Width of the tag. Defaults to 100.
  /// - [height]: Height of the tag. Defaults to 100.
  /// - [color]: Background color of the tag. Defaults to [StoycoColors.blue].
  /// - [cutSize]: Depth of the diagonal cut in the selected corner. Defaults to 48.
  /// - [cornerRadius]: Radius of the diagonal cut corner. Defaults to 20.
  /// - [borderWidth]: Width of the gradient border. Defaults to 4.
  /// - [gradientColorsBorder]: Colors for the gradient border. Defaults to design token gradient.
  /// - [position]: Which corner to cut (default: [TagCornerPosition.topRight]).
  /// - [shadows]: Optional list of shadows for the tag. Defaults to [StoycoColors.shadowPurple98].
  const TagCorner({
    super.key,
    required this.title,
    this.textStyle,
    this.paddingText,
    this.showExclamationIcon = false,
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

  /// Background color of the tag. Defaults to [StoycoColors.blue].
  final Color color;

  /// Whether to show an exclamation icon above the text.
  final bool showExclamationIcon;

  /// Custom text style for the tag text.
  final TextStyle? textStyle;

  /// Padding around the text inside the tag.
  final EdgeInsets? paddingText;

  /// Width of the tag. Defaults to 100.
  final double width;

  /// Height of the tag. Defaults to 100.
  final double height;

  /// Depth of the diagonal cut in the selected corner. Defaults to 48.
  final double cutSize;

  /// Radius of the diagonal cut corner. Defaults to 20.
  final double cornerRadius;

  /// Width of the gradient border. Defaults to 4.
  final double borderWidth;

  /// Colors for the gradient border. Defaults to design token gradient.
  final List<Color> gradientColorsBorder;

  /// Which corner to cut. Defaults to [TagCornerPosition.topRight].
  final TagCornerPosition position;

  /// Optional list of shadows for the tag. Defaults to [StoycoColors.shadowPurple98].
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
                  padding: paddingText ?? StoycoScreenSize.fromLTRB(context, top: showExclamationIcon ? 0 : 14 ),
                  child: Column(
                    children: <Widget>[
                      if (showExclamationIcon)
                      Padding(
                        padding: StoycoScreenSize.fromLTRB(context, top: 4, bottom: 4),
                        child: StoycoAssets.lib.assets.icons.common.exclamacion.svg(
                          width: StoycoScreenSize.width(context, 12),
                          height: StoycoScreenSize.width(context, 12),
                          package: 'stoyco_subscription',
                        ),
                      ),
                      Text(
                        title,
                        style: textStyle ?? TextStyle(
                            color: StoycoColors.softWhite,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamilyToken.akkuratPro,
                            fontSize: StoycoScreenSize.fontSize(context, 14),
                        ),
                      ),
                    ],
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

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class TagGradientIcon extends StatelessWidget {
  /// {@template tag_gradient_icon}
  /// TagGradientIcon
  ///
  /// An atomic design widget that displays a tag with a gradient background, customizable icon, and text.
  ///
  /// The gradient starts lighter on the left and becomes darker on the right, ideal for highlighting information or status.
  ///
  /// Parameters:
  /// - [title]: Main text of the tag.
  /// - [titleStyle]: Text style (optional).
  /// - [icon]: Widget for the icon (optional, defaults to SVG star).
  /// - [width]: Tag width (optional, adapts to content if null).
  /// - [height]: Tag height (default 29).
  /// - [borderRadius]: Border radius (default 100).
  /// - [padding]: Inner padding (optional).
  /// - [margin]: Outer margin (optional).
  /// - [gradient]: Custom gradient (optional, defaults to dark gradient).
  ///
  /// Example usage:
  /// ```dart
  /// TagGradientIcon(
  ///   title: 'Premium',
  ///   icon: SvgPicture.asset('assets/icons/crown.svg'),
  ///   width: 140,
  ///   height: 32,
  ///   borderRadius: 80,
  /// )
  /// ```
  /// {@endtemplate} 
  const TagGradientIcon({
    super.key,
    required this.title,
    this.titleStyle,
    this.icon,
    this.width,
    this.height = 29,
    this.borderRadius = 100,
    this.padding,
    this.margin,
    this.gradient,
  });

  /// Main text of the tag.
  final String title;

  /// Text style (optional).
  final TextStyle? titleStyle;

  /// Widget for the icon (optional, defaults to SVG star).
  final Widget? icon;

  /// Tag width (optional, adapts to content if null).
  final double? width;

  /// Tag height (default 29).
  final double height;

  /// Border radius (default 100).
  final double borderRadius;

  /// Inner padding (optional).
  final EdgeInsetsGeometry? padding;

  /// Outer margin (optional).
  final EdgeInsetsGeometry? margin;

  /// Custom gradient (optional, defaults to dark gradient).
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: StoycoScreenSize.height(context, height),
      padding: padding ?? StoycoScreenSize.fromLTRB( context, top: 5, right: 10, left: 10, bottom: 5),
      margin: margin ?? StoycoScreenSize.fromLTRB( context, top: 16, right: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color.fromRGBO(255, 255, 255, 0.18),
            Color.fromRGBO(80, 80, 80, 0.25),   
            Color.fromRGBO(0, 0, 0, 0.45),      
            Color.fromRGBO(20, 20, 20, 0.65),   
            Color.fromRGBO(0, 0, 0, 0.85),      
          ],
          stops: <double>[0.0, 0.25, 0.5, 0.75, 1.0],
        ),
        borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadius)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            icon!,
          ] else ...<Widget>[
            SvgPicture.asset(
              'packages/stoyco_subscription/lib/assets/icons/star.svg',
            ),
          ],
          Gap(StoycoScreenSize.width(context, 7)),
          Text(
            title,
            style: titleStyle ?? TextStyle(
              color: StoycoColors.iconDefault,
              fontWeight: FontWeight.w500,
              fontSize: StoycoScreenSize.fontSize(context, 12),
            ),
          ),
        ],
      ),
    );
  }
}

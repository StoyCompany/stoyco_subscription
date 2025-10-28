import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template tag_locked}
/// A [TagLocked] atom for the Stoyco Subscription Atomic Design System.
/// Renders a lock tag with icon and message, used for exclusive or restricted content overlays.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `message`: The message text to display in the tag. Defaults to 'Contenido bloqueado'.
/// - `messageStyle`: Custom text style for the message (optional).
/// - `padding`: Padding inside the tag (optional).
/// - `backgroundColor`: Background color for the tag. Defaults to [StoycoColors.lightGray].
/// - `borderRadius`: Border radius for the tag. Defaults to 10.0.
/// - `tagLockIcon`: Custom icon widget for the lock (optional).
/// - `tagLockIconWidth`: Width for the lock icon (optional).
/// - `tagLockIconHeight`: Height for the lock icon (optional).
///
/// ### Returns
/// Renders a lock tag with icon and message, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// TagLocked(
///   message: 'Locked',
///   tagLockIcon: Icon(Icons.lock),
/// )
/// ```
/// {@endtemplate}
class TagLocked extends StatelessWidget {
  /// {@macro tag_locked}
  const TagLocked({
    super.key,
    this.message = 'Contenido bloqueado',
    this.messageStyle,
    this.isLocked = true,
    this.padding,
    this.margin,
    this.widthTag,
    this.heightTag,
    this.backgroundColor = StoycoColors.lightGray,
    this.borderRadius = 10.0,
    this.tagLockIcon,
    this.tagLockIconWidth,
    this.tagLockIconHeight,
  });

  /// The message text to display in the tag. Defaults to 'Contenido bloqueado'.
  final String message;

  /// Custom text style for the message. If null, uses default Montserrat style.
  final TextStyle? messageStyle;

  /// Whether the tag is locked and should be displayed. If false, renders nothing. Defaults to true.
  final bool isLocked;

  /// Padding inside the tag. If null, uses responsive default.
  final EdgeInsetsGeometry? padding;

  /// Margin outside the tag. If null, uses responsive default.
  final EdgeInsetsGeometry? margin;

  /// The width of the tag in logical pixels. Optional.
  final double? widthTag;

  /// The height of the tag in logical pixels. Optional.
  final double? heightTag;

  /// Border radius for the tag. Defaults to 10.0.
  final double borderRadius;

  /// Background color for the tag. Defaults to [StoycoColors.lightGray].
  final Color? backgroundColor;

  /// Custom icon widget for the lock. If null, uses default SVG asset.
  final Widget? tagLockIcon;

  /// Width for the lock icon in logical pixels. Optional.
  final double? tagLockIconWidth;

  /// Height for the lock icon in logical pixels. Optional.
  final double? tagLockIconHeight;

  @override
  Widget build(BuildContext context) {

    if (!isLocked) {
      return const SizedBox.shrink();
    }

    return Container(
      width: widthTag,
      height: heightTag ?? StoycoScreenSize.height(context, 20),
      padding: padding ?? StoycoScreenSize.symmetric(context, horizontal: 8, vertical: 3),
      margin: margin ?? StoycoScreenSize.fromLTRB(
        context, 
        left: 11, 
        right: 7,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadius)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StoycoAssets.lib.assets.icons.exclusiveContent.tagLock.svg(
            fit: BoxFit.cover,
            package: 'stoyco_subscription',
          ),
          Gap(StoycoScreenSize.width(context, 4)),
          Text(
            message,
            style: messageStyle ?? GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: StoycoScreenSize.fontSize(context, 10),
                fontWeight: FontWeight.w400,
                color: StoycoColors.deepCharcoal,
              ),
            ),
          ), 
        ],
      ),
    );
  }
}

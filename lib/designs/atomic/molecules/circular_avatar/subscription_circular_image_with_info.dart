import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template subscription_circular_image_with_info}
/// A widget that displays a circular image, a title, and a subscription action button.
///
/// This widget is typically used to represent a subscription item in a grid or list.
/// It shows a circular image loaded from [imageUrl], the [title] below the image,
/// and a button at the bottom. The button's text and background gradient change
/// depending on the [subscribed] state:
/// - If [subscribed] is `true`, the button displays "Ver suscripción" and a gray gradient.
/// - If [subscribed] is `false` or `null`, the button displays "Suscribirme" and a blue gradient.
///
/// The [onTap] callback is triggered when the widget is tapped.
///
/// Example usage:
/// ```dart
/// SubscriptionCircularImageWithInfo(
///   imageUrl: 'https://example.com/image.jpg',
///   title: 'Artist Name',
///   subscribed: true,
///   onTap: () {
///     // Handle tap
///   },
/// )
/// ```
/// {@endtemplate}
class SubscriptionCircularImageWithInfo extends StatelessWidget {
  /// {@macro subscription_circular_image_with_info}
  const SubscriptionCircularImageWithInfo({
    super.key,
    this.onTap,
    required this.imageUrl,
    required this.title,
    this.titleFontSize,
    this.subscribed,
    this.margin,
    this.imageWidth,
    this.imageHeight,
    this.onTapSubscribe,
  });

  /// The title displayed below the image.
  final String title;

  /// The URL of the image to display in the circular avatar.
  final String imageUrl;

  /// Whether the user is subscribed. Affects the button's appearance and text.
  final bool? subscribed;

  //Image width and height
  final double? imageWidth;
  final double? imageHeight;

  /// Optional font size for the title text.
  final double? titleFontSize;

  /// Called when the widget is tapped.
  final VoidCallback? onTap;

  final VoidCallback? onTapSubscribe;

  /// Optional margin for the widget.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    double dynamicImageSize;
    if (StoycoScreenSize.isDesktopLarge(context)) {
      dynamicImageSize = 180;
    } else if (StoycoScreenSize.isDesktop(context)) {
      dynamicImageSize = 154.8;
    } else if (StoycoScreenSize.isTablet(context)) {
      dynamicImageSize = 120;
    } else {
      dynamicImageSize = 100;
    }

    final double imageW = imageWidth ?? dynamicImageSize;
    final double imageH = imageHeight ?? dynamicImageSize;

    return SizedBox(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: StoycoScreenSize.width(context, imageW),
              height: StoycoScreenSize.height(context, imageH),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: StoycoScreenSize.height(context, 7.66)),
            SizedBox(
              child: Text(
                maxLines: 1,
                title,
                textScaler: TextScaler.noScaling,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: StoycoColors.softWhite,
                    fontSize: StoycoScreenSize.fontSize(
                      context,
                      titleFontSize ?? 18.53,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: StoycoScreenSize.height(context, 7.66)),
            InkWell(
              onTap: onTapSubscribe,
              child: Container(
                padding: StoycoScreenSize.symmetric(
                  context,
                  horizontal: 16,
                  vertical: 3,
                ),
                height: StoycoScreenSize.height(context, 30.66),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF373680)),
                  borderRadius: BorderRadius.circular(15.31),
                  gradient: subscribed ?? false
                      ? const LinearGradient(
                          colors: <Color>[
                            Color(0x232336B2),
                            Color(0x232336B2),
                            Color(0x2323361A),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : const LinearGradient(
                          colors: <Color>[Color(0xFF1C197F), Color(0xFF4639E7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                ),
                child: Text(
                  subscribed ?? false ? 'Ver suscripción' : 'Suscribirme',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: StoycoScreenSize.fontSize(context, 15.31),
                    fontFamily: FontFamilyToken.akkuratPro,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

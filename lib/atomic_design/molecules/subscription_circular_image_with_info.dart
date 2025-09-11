import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/atomic_design/design/screen_size.dart';
import 'package:stoyco_subscription/atomic_design/tokens/colors.dart';
import 'package:stoyco_subscription/core/gen/fonts.gen.dart';

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
    this.subscribed,
    this.margin,
  });

  /// The title displayed below the image.
  final String title;

  /// The URL of the image to display in the circular avatar.
  final String imageUrl;

  /// Whether the user is subscribed. Affects the button's appearance and text.
  final bool? subscribed;

  /// Called when the widget is tapped.
  final Function()? onTap;

  /// Optional margin for the widget.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => SizedBox(
    child: GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: StoycoScreenSize.width(context, 148.15),
            height: StoycoScreenSize.height(context, 148.15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
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
                  fontSize: StoycoScreenSize.fontSize(context, 18.53),
                  fontWeight: FontWeight.w400,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: StoycoScreenSize.height(context, 7.66)),
          Container(
            padding: StoycoScreenSize.symmetric(
              context,
              horizontal: 22.97,
              vertical: 3.83,
            ),
            height: StoycoScreenSize.height(context, 30.66),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF373680)),
              borderRadius: BorderRadius.circular(15.31),
              gradient: subscribed == true
                  ? const LinearGradient(
                      colors: [
                        Color(0x232336B2),
                        Color(0x232336B2),
                        Color(0x2323361A),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF1C197F), Color(0xFF4639E7)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
            ),
            child: Text(
              subscribed == true ? 'Ver suscripción' : 'Suscribirme',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: StoycoScreenSize.fontSize(context, 15.31),
                fontFamily: FontFamilyToken.akkuratPro,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

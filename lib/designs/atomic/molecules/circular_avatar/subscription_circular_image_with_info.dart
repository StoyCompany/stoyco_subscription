import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
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
    this.onTapWhenExpired,
    this.hasSubscription,
    this.isExpired,
  });

  /// The title displayed below the image.
  final String title;

  /// The URL of the image to display in the circular avatar.
  final String imageUrl;

  /// Whether the user is subscribed. Affects the button's appearance and text.
  final bool? subscribed;
  final bool? hasSubscription;

  // Whether the user subscription is expired
  final bool? isExpired;

  //Image width and height
  final double? imageWidth;
  final double? imageHeight;

  /// Optional font size for the title text.
  final double? titleFontSize;

  /// Called when the widget is tapped.
  final VoidCallback? onTap;

  final VoidCallback? onTapSubscribe;

  final VoidCallback? onTapWhenExpired;

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
      dynamicImageSize = 148;
    }

    final double imageW = imageWidth ?? dynamicImageSize;
    final double imageH = imageHeight ?? dynamicImageSize;

    return SizedBox(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          spacing: StoycoScreenSize.height(context, 7.66),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageNetworkBlur(
              imageUrl: imageUrl,
              radius: StoycoScreenSize.radius(context, imageW / 2),
              width: StoycoScreenSize.width(context, imageW),
              height: StoycoScreenSize.height(context, imageH),
              fit: BoxFit.cover,
              imageError: Container(
                width: StoycoScreenSize.width(context, imageW),
                height: StoycoScreenSize.height(context, imageH),
                color: StoycoColors.backgroundGrey,
                child: const Icon(Icons.error),
              ),
            ),
            Text(
              maxLines: 1,
              title,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontFamily: FontFamilyToken.akkuratPro,
                  color: StoycoColors.softWhite,
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    titleFontSize ?? 18.53,
                  ),
                  fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            // Botón con lógica completa de estados
            if (hasSubscription ?? false)
              ButtonGradientText(
                text: (isExpired ?? false) && (subscribed ?? false)
                    ? 'Renovar'
                    : subscribed ?? false
                    ? 'Ver suscripción'
                    : 'Suscribirme',
                type: (isExpired ?? false) && (subscribed ?? false)
                    ? ButtonGradientTextType.primary 
                    : subscribed ?? false
                    ?  ButtonGradientTextType.primary 
                    :  ButtonGradientTextType.custom,
                backgroundColor: StoycoColors.menuItemBackground,
                width: StoycoScreenSize.width(context, 148),
                height: StoycoScreenSize.height(context, 31),
                alignmentContent: Alignment.center,
                paddingContent: StoycoScreenSize.symmetric(
                  context,
                  horizontal: 16,
                  vertical: 4,
                ),
                borderRadius: 15,
                borderWidth: 1.5,
                textStyle: TextStyle(
                  fontSize: StoycoScreenSize.fontSize(context, 15),
                  fontFamily: FontFamilyToken.akkuratPro,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                iconWidget: (isExpired ?? false) && (subscribed ?? false)
                    ? StoycoAssets.lib.assets.icons.common.alertIcon.svg(
                        package: 'stoyco_subscription',
                        height: StoycoScreenSize.height(context, 16),
                        width: StoycoScreenSize.width(context, 16),
                      )
                    : null,
                iconPosition: (isExpired ?? false) && (subscribed ?? false)
                    ? ButtonGradientTextIconPosition.left
                    : ButtonGradientTextIconPosition.none,
                onPressed: ((isExpired ?? false) && (subscribed ?? false))
                    ? onTapWhenExpired
                    : onTapSubscribe,
              ),
          ],
        ),
      ),
    );
  }
}

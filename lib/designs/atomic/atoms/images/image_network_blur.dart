import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template image_network_blur}
/// An atom widget from the Book Stack Atomic Design System that displays a network image with a customizable blur effect overlay, border radius, and overlay color.
///
/// ### Overview
/// Renders a network image with a blur overlay, supporting custom border radius, blur intensity, overlay color, opacity, and alignment. Useful for backgrounds, cards, or any UI element requiring a blurred image effect.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `imageUrl`: The URL of the image to display.
/// - `width`: The width of the image.
/// - `height`: The height of the image.
/// - `imagePlaceholder`: Widget to show while the image is loading.
/// - `imageError`: Widget to show if the image fails to load.
/// - `isBlur`: Whether to apply the blur effect. Defaults to false.
/// - `fit`: How the image should be inscribed into the space allocated. Defaults to [BoxFit.cover].
/// - `borderRadius`: The border radius to apply to the image and blur overlay. Defaults to 0.
/// - `blurSigmaX`: The sigmaX value for the blur effect. Defaults to 10.
/// - `blurSigmaY`: The sigmaY value for the blur effect. Defaults to 10.
/// - `overlayColor`: The color overlay to apply above the blur. Defaults to transparent.
/// - `overlayOpacity`: The opacity of the color overlay. Defaults to 0.0.
/// - `blurPosition`: The alignment of the blur overlay. If null, fills the image; otherwise, aligns the blur overlay.
///
/// ### Returns
/// A widget that renders a network image with a customizable blur overlay and rounded corners.
///
/// ### Example
/// ```dart
/// const ImageNetworkBlur(
///   imageUrl: 'https://example.com/image.jpg',
///   isBlur: true,
///   width: 200,
///   height: 200,
///   borderRadius: 16,
///   blurSigmaX: 8,
///   blurSigmaY: 8,
///   overlayColor: Colors.black,
///   overlayOpacity: 0.2,
/// )
/// ```
/// {@endtemplate}
class ImageNetworkBlur extends StatelessWidget {
  /// {@macro image_network_blur}

  const ImageNetworkBlur({
    super.key,
    required this.imageUrl,
    this.imagePlaceholder,
    this.imageError,
    this.isBlur = false,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.blurSigmaX = 2.5,
    this.blurSigmaY = 2.5,
    this.overlayColor = Colors.transparent,
    this.overlayOpacity = 0.3,
    this.radius = 0,
    this.borderRadius,
  });
  /// The URL of the image to display.
  final String imageUrl;

  /// The width of the image in logical pixels.
  final double? width;

  /// The height of the image in logical pixels.
  final double? height;

  /// Widget to display while the image is loading.
  final Widget? imagePlaceholder;

  /// Widget to display if the image fails to load.
  final Widget? imageError;

  /// Whether to apply the blur effect overlay. Defaults to false.
  final bool isBlur;

  /// How the image should be inscribed into the space allocated. Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// The alignment for the image and blur overlay. Defaults to [Alignment.center].
  final Alignment alignment;

  /// The border radius to apply to the image and blur overlay, in logical pixels. Defaults to 0.
  final double radius;

  /// The border radius to apply to the image and blur overlay. If provided, overrides [radius].
  final BorderRadiusGeometry? borderRadius;

  /// The sigmaX value for the blur effect. Controls horizontal blur intensity. Defaults to 2.5.
  final double blurSigmaX;

  /// The sigmaY value for the blur effect. Controls vertical blur intensity. Defaults to 2.5.
  final double blurSigmaY;

  /// The color overlay to apply above the blur. Useful for tinting. Defaults to transparent.
  final Color overlayColor;

  /// The opacity of the color overlay. Range 0.0–1.0. Defaults to 0.3.
  final double overlayOpacity;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(StoycoScreenSize.radius(context, radius)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CachedNetworkImage(
              height: height,
              width: width,
              fit: fit,
              imageUrl: imageUrl,
              alignment: alignment,
              placeholder: (BuildContext context, String url) => imagePlaceholder ??
                  const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black12),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                      ),
                    ),
                  ),
              errorWidget: (BuildContext context, String url, Object error) => imageError ?? const Icon(Icons.error),
            ),
            if (isBlur)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
                  child: Container(
                    color: overlayColor.withOpacity(overlayOpacity),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

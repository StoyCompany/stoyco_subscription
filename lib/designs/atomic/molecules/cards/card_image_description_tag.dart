import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/cards/card_with_shadow.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template card_image_description_tag}
/// CardImageDescriptionTag
///
/// An atomic design widget that displays a card with an image, description, and an optional floating tag widget.
///
/// This widget is designed for use in atomic design systems, serving as a foundational "molecule" for building more complex UI organisms.
///
/// It supports design tokens for sizing, border radius, and overlays, ensuring consistency and maintainability across your design system.
///
/// Example usage:
/// ```dart
/// CardImageDescriptionTag(
///   cardWidth: 320,
///   cardHeight: 220,
///   cardBorderRadius: 24,
///   imageUrl: 'https://example.com/image.jpg',
///   imageHeight: 160,
///   imageBorderRadius: BorderRadius.only(
///     topLeft: Radius.circular(22),
///     topRight: Radius.circular(22),
///   ),
///   description: HtmlWidget('<p>Some description</p>'),
///   tag: Container(
///     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
///     decoration: BoxDecoration(
///       color: Colors.red,
///       borderRadius: BorderRadius.circular(12),
///     ),
///     child: Text('NEW', style: TextStyle(color: Colors.white)),
///   ),
///   tagAlignment: Alignment.topRight,
///   paddingContent: EdgeInsets.all(8),
/// )
/// ```
/// {@endtemplate}
class CardImageDescriptionTag extends StatelessWidget {
  /// Creates a [CardImageDescriptionTag] widget.
  ///
  /// [cardWidth] - The width of the card. If null, expands to parent constraints.
  /// [cardHeight] - The height of the card. If null, expands to parent constraints.
  /// [cardBorderRadius] - The border radius of the card. Defaults to 24.
  /// [imageUrl] - The main image URL for the card.
  /// [imageHeight] - The height of the image. Defaults to 160.
  /// [imageWidth] - The width of the image. Defaults to full width.
  /// [imageBorderRadius] - The border radius for the image. Defaults to top corners rounded.
  /// [imagePlaceholder] - Widget to show while the image is loading. Defaults to [SkeletonCard].
  /// [imageErrorPlaceholder] - Widget to show if the image fails to load. Defaults to [SkeletonCard].
  /// [description] - The main description widget below the image.
  /// [tag] - Optional floating widget (tag/badge) to overlay on the card.
  /// [tagAlignment] - Alignment for the floating tag. Defaults to [Alignment.topRight].
  /// [paddingContent] - Padding for the content inside the card.
  const CardImageDescriptionTag({
    super.key,
    this.cardWidth,
    this.cardHeight,
    this.cardBorderRadius = 24,
    required this.imageUrl,
    this.imageHeight,
    this.imageWidth,
    this.imageBorderRadius,
    this.imagePlaceholder,
    this.imageErrorPlaceholder,
    required this.description,
    this.tagAlignment = Alignment.topRight,
    this.tag,
    this.paddingContent,
  });

  /// The width of the card. If null, expands to parent constraints.
  final double? cardWidth;

  /// The height of the card. If null, expands to parent constraints.
  final double? cardHeight;

  /// The border radius of the card. Defaults to 24.
  final double cardBorderRadius;

  /// The main image URL for the card.
  final String imageUrl;

  /// The height of the image. Defaults to 160.
  final double? imageHeight;

  /// The width of the image. Defaults to full width.
  final double? imageWidth;

  /// Widget to show while the image is loading. Defaults to [SkeletonCard].
  final Widget? imagePlaceholder;

  /// Widget to show if the image fails to load. Defaults to [SkeletonCard].
  final Widget? imageErrorPlaceholder;

  /// The border radius for the image. Defaults to top corners rounded.
  final BorderRadiusGeometry? imageBorderRadius;

  /// The main description widget below the image.
  final Widget description;

  /// Optional floating widget (tag/badge) to overlay on the card.
  final Widget? tag;

  /// Alignment for the floating tag. Defaults to [Alignment.topRight].
  final Alignment tagAlignment;

  /// Padding for the content inside the card.
  final EdgeInsetsGeometry? paddingContent;

  @override
  Widget build(BuildContext context) {
    return CardWithShadow(
      width: cardWidth,
      height: cardHeight,
      borderRadius: StoycoScreenSize.radius(context, cardBorderRadius),
      paddingChildren: EdgeInsets.zero,
      child: ClipRRect(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: paddingContent ?? StoycoScreenSize.fromLTRB(context, left: 8, top: 8, right: 8, bottom: 32),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: imageBorderRadius ?? BorderRadius.only(
                      topLeft: Radius.circular(StoycoScreenSize.radius(context, 22)),
                      topRight: Radius.circular(StoycoScreenSize.radius(context, 22)),
                    ),
                    child: SizedBox(
                      height: imageHeight ?? StoycoScreenSize.height(context, 160),
                      width: imageWidth ?? double.infinity,
                      child:  CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (BuildContext context, String url) => imagePlaceholder ?? const SkeletonCard(),
                            errorWidget: (BuildContext context, String url, Object error) => imageErrorPlaceholder ?? Container(
                              alignment: Alignment.center,
                              color: StoycoColors.deepTeal,
                              child: const Icon(Icons.error),
                            ),
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                  Gap(StoycoScreenSize.height(context, 24)),
                  description,
                ],
              ),
            ),
            if (tag != null)
              Align(
                alignment: tagAlignment,
                child: tag,
              ),
          ],
        ),
      ),
    );
  }
}

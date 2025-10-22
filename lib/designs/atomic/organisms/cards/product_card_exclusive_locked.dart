import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_locked.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template card_product_exclusive_locked}
/// A [CardProductExclusiveLocked] organism for the Stoyco Subscription Atomic Design System.
/// Renders a product card with image, name, category, and locked overlay for exclusive content.
///
/// ### Atomic Level
/// **Organism** – Composed of molecules and atoms (image, tag, overlay) for product display and interaction.
///
/// ### Parameters
/// - `imageUrl`: The main image URL for the product card.
/// - `imagePlaceholder`: Widget to show while the image is loading (optional).
/// - `imageError`: Widget to show if the image fails to load (optional).
/// - `name`: The product name to display.
/// - `category`: The product category to display.
/// - `isLocked`: If true, displays locked overlay and disables normal tap.
/// - `onTapProduct`: Callback when the unlocked product card is tapped.
/// - `onTapProductExclusive`: Callback when the locked product card is tapped.
/// - `heightCard`: Height of the card. Defaults to 160.
/// - `widthCard`: Width of the card. Defaults to 160.
/// - `borderRadiusCard`: Border radius for the card. Defaults to 8.
/// - `backgroundColorCard`: Background color for the card. Defaults to [StoycoColors.deepTeal].
/// - `paddingContentCard`: Padding for the content inside the card (optional).
/// - `nameFontStyle`: Custom text style for the product name (optional).
/// - `categoryFontStyle`: Custom text style for the category (optional).
///
/// ### Returns
/// Renders a product card with image, name, category, and locked overlay, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// CardProductExclusiveLocked(
///   imageUrl: 'https://example.com/image.jpg',
///   name: 'Exclusive Item',
///   category: 'Premium',
///   isLocked: true,
///   onTapProductExclusive: () {},
/// )
/// ```
/// {@endtemplate}
/// {@template product_card_exclusive_locked}
/// A [ProductCardExclusiveLocked] organism for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a product card with image, name, category, and lock status. Shows a locked overlay for exclusive products, and provides tap callbacks for both locked and unlocked states. Highly customizable for use in product listings or exclusive content sections.
///
/// ### Atomic Level
/// **Organism** – Composed of atoms and molecules (image, tag, overlay) for product display and interaction.
///
/// ### Parameters
/// - `imageUrl`: The main image URL for the product card.
/// - `name`: The product name to display.
/// - `category`: The product category to display.
/// - `imagePlaceholder`: Widget to show while the image is loading (optional).
/// - `imageError`: Widget to show if the image fails to load (optional).
/// - `isLocked`: If true, displays locked overlay and disables normal tap. Defaults to false.
/// - `onTapProduct`: Callback when the unlocked product card is tapped.
/// - `onTapProductExclusive`: Callback when the locked product card is tapped.
/// - `heightCard`: Height of the card. Defaults to 226.
/// - `widthCard`: Width of the card. Defaults to 156.
/// - `borderRadiusCard`: Border radius for the card. Defaults to 8.
/// - `backgroundColorCard`: Background color for the card. Defaults to [StoycoColors.white2].
/// - `paddingContentCard`: Padding for the content inside the card (optional).
/// - `nameFontStyle`: Custom text style for the product name (optional).
/// - `categoryFontStyle`: Custom text style for the category (optional).
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a visually rich product card with image, lock overlay, and product details, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// ProductCardExclusiveLocked(
///   imageUrl: 'https://example.com/product.jpg',
///   name: 'Exclusive Product',
///   category: 'Premium',
///   isLocked: true,
///   onTapProductExclusive: () {},
/// )
/// ```
/// {@endtemplate}
class ProductCardExclusiveLocked extends StatelessWidget {
  /// {@macro product_card_exclusive_locked}
  const ProductCardExclusiveLocked({
    super.key, 
    required this.imageUrl,
    required this.name,
    required this.category,
    this.imagePlaceholder,
    this.imageError,
    this.isLocked = false,
    this.onTapProduct,
    this.onTapProductExclusive,
    this.heightCard = 226,
    this.widthCard = 156,
    this.borderRadiusCard = 8,
    this.backgroundColorCard = StoycoColors.white2,
    this.paddingContentCard,
    this.nameFontStyle,
    this.categoryFontStyle,
  });

  /// The main image URL for the product card.
  final String imageUrl;
  /// The product name to display.
  final String name;
  /// The product category to display.
  final String category;
  /// Widget to show while the image is loading (optional).
  final Widget? imagePlaceholder;
  /// Widget to show if the image fails to load (optional).
  final Widget? imageError;
  /// If true, displays locked overlay and disables normal tap. Defaults to false.
  final bool isLocked;
  /// Callback when the unlocked product card is tapped.
  final VoidCallback? onTapProduct;
  /// Callback when the locked product card is tapped.
  final VoidCallback? onTapProductExclusive;

  /// Height of the card. Defaults to 226.
  final double heightCard;
  /// Width of the card. Defaults to 156.
  final double widthCard;
  /// Border radius for the card. Defaults to 8.
  final double borderRadiusCard;
  /// Background color for the card. Defaults to [StoycoColors.white2].
  final Color backgroundColorCard;
  /// Padding for the content inside the card (optional).
  final EdgeInsetsGeometry? paddingContentCard;

  /// Custom text style for the product name (optional).
  final TextStyle? nameFontStyle;
  /// Custom text style for the category (optional).
  final TextStyle? categoryFontStyle;

  @override
  Widget build(BuildContext context) => InkWell(
      borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
      onTap: isLocked ? onTapProductExclusive : onTapProduct,
      child: SizedBox(
        width: StoycoScreenSize.width(context, widthCard),
        height: StoycoScreenSize.height(context, heightCard),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
              color: backgroundColorCard,
              border: Border.all(
                color: StoycoColors.cardBorderDark,
                width: 0.9,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: StoycoScreenSize.fromLTRB(
                    context,
                    left: 0.9,
                    top: 0.9,
                    right: 0.9,
                  ),
                  child: ImageNetworkBlur(
                    imageUrl: imageUrl,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.7,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
                      topRight: Radius.circular(StoycoScreenSize.radius(context, borderRadiusCard)),
                    ),
                    isBlur: isLocked,
                    imagePlaceholder: imagePlaceholder,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.25,
                    child: Padding(
                      padding: paddingContentCard ?? StoycoScreenSize.symmetric(
                        context,
                        horizontal: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name,
                            style: nameFontStyle ?? TextStyle(
                              fontSize: StoycoScreenSize.fontSize(context, 16),
                              fontWeight: FontWeight.bold,
                              color: StoycoColors.white,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(StoycoScreenSize.height(context, 4)),
                          Text(
                            category,
                            style: categoryFontStyle ?? TextStyle(
                                fontSize: StoycoScreenSize.fontSize(context, 10),
                                fontWeight: FontWeight.w400,
                                color: StoycoColors.hint,
                              ),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(StoycoScreenSize.height(context, 4)),
                        ],
                      ),
                    ),
                  ),
                ), 
                Align(
                  alignment: Alignment.topCenter,
                  child: TagLocked(
                    isLocked: isLocked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

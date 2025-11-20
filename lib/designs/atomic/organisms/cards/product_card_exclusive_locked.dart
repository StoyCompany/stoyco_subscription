import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/images/image_network_blur.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_locked.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template product_card_exclusive_locked}
/// A [ProductCardExclusiveLocked] organism for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a product card with image, name, category, and lock status. Shows a locked overlay for exclusive products, and provides tap callbacks for both locked and unlocked states. Highly customizable for use in product listings or exclusive content sections.
///
/// **Features:**
/// - Interactive hover effect with subtle highlight
/// - Lock overlay for exclusive content
/// - Blur effect on locked images
/// - Customizable styling and dimensions
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
/// Renders a visually rich product card with image, lock overlay, hover effect, and product details, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// ProductCardExclusiveLocked(
///   imageUrl: 'https://example.com/product.jpg',
///   name: 'Exclusive Product',
///   category: 'Premium',
///   isLocked: true,
///   onTapProductExclusive: () => showUpgradeDialog(),
/// )
/// ```
/// {@endtemplate}
class ProductCardExclusiveLocked extends StatefulWidget {
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
  State<ProductCardExclusiveLocked> createState() =>
      _ProductCardExclusiveLockedState();
}

class _ProductCardExclusiveLockedState
    extends State<ProductCardExclusiveLocked> {
  /// Tracks whether the mouse is hovering over the card.
  bool isHovering = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.isLocked ? widget.onTapProductExclusive : widget.onTapProduct,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        isHovering = true;
      }),
      onExit: (_) => setState(() {
        isHovering = false;
      }),
      child: SizedBox(
        width: StoycoScreenSize.width(context, widget.widthCard),
        height: StoycoScreenSize.height(context, widget.heightCard),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    StoycoScreenSize.radius(context, widget.borderRadiusCard),
                  ),
                  color: isHovering
                      ? Colors.grey.withOpacity(0.05)
                      : Colors.transparent,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      StoycoScreenSize.radius(context, widget.borderRadiusCard),
                    ),
                    color: widget.backgroundColorCard,
                    border: Border.all(
                      color: StoycoColors.cardBorderDark,
                      width: 0.9,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      // Image section
                      Padding(
                        padding: StoycoScreenSize.fromLTRB(
                          context,
                          left: 0.9,
                          top: 0.9,
                          right: 0.9,
                        ),
                        child: ImageNetworkBlur(
                          imageUrl: widget.imageUrl,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.7,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              StoycoScreenSize.radius(
                                context,
                                widget.borderRadiusCard,
                              ),
                            ),
                            topRight: Radius.circular(
                              StoycoScreenSize.radius(
                                context,
                                widget.borderRadiusCard,
                              ),
                            ),
                          ),
                          isBlur: widget.isLocked,
                          imagePlaceholder: widget.imagePlaceholder,
                        ),
                      ),

                      // Product info section
                      Positioned(
                        bottom: 5,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.25,
                          child: Padding(
                            padding:
                                widget.paddingContentCard ??
                                StoycoScreenSize.symmetric(
                                  context,
                                  horizontal: 10,
                                ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.name,
                                  style:
                                      widget.nameFontStyle ??
                                      TextStyle(
                                        fontSize: StoycoScreenSize.fontSize(
                                          context,
                                          16,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        color: StoycoColors.white,
                                      ),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Gap(StoycoScreenSize.height(context, 4)),
                                Text(
                                  widget.category,
                                  style:
                                      widget.categoryFontStyle ??
                                      TextStyle(
                                        fontSize: StoycoScreenSize.fontSize(
                                          context,
                                          10,
                                        ),
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

                      // Lock tag
                      Align(
                        alignment: Alignment.topCenter,
                        child: TagLocked(isLocked: widget.isLocked),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    ),
  );
}

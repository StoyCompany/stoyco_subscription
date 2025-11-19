import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/product_card_exclusive_locked.dart';
import 'package:stoyco_subscription/designs/atomic/templates/sliders/products/products_slider_style.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template products_slider}
/// A [ProductsSlider] template for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a horizontal slider of product cards, with a section title and loading skeletons. Shows a scrollable list of [ProductCardExclusiveLocked] widgets, or skeleton placeholders when loading. Highly customizable via generic data and style parameters.
///
/// ### Atomic Level
/// **Template** – High-level layout structure composed of organisms, molecules, and atoms for product display and interaction.
///
/// ### Parameters
/// - `title`: Title of the slider. Defaults to 'Merch'.
/// - `getIsLocked`: Returns whether the product is locked.
/// - `getName`: Returns the name value for a product.
/// - `getCategory`: Returns the category value for a product.
/// - `getImageUrl`: Returns the imageUrl value for a product.
/// - `onTapProduct`: Called when a product is tapped.
/// - `onTapProductExclusive`: Called when an exclusive product is tapped.
/// - `products`: List of products to display in the slider.
/// - `isLoading`: Whether the slider is in a loading state. Defaults to false.
/// - `style`: Style model for all design parameters. Defaults to [ProductsSliderStyle].
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a column with a section title and a horizontally scrollable list of product cards or skeletons, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// ProductsSlider<ProductModel>(
///   products: myProducts,
///   getName: (p) => p.name,
///   getCategory: (p) => p.category,
///   getImageUrl: (p) => p.imageUrl,
///   getIsLocked: (p) => p.isLocked,
///   onTapProduct: (p) => print('Tap: \\${p.name}'),
///   onTapProductExclusive: (p) => print('Exclusive: \\${p.name}'),
/// )
/// ```
/// {@endtemplate}
class ProductsSlider<T> extends StatelessWidget {
  /// {@macro products_slider}
  const ProductsSlider({
    super.key,
    this.title = 'Merch',
    required this.getName,
    required this.getCategory,
    required this.getImageUrl,
    required this.getIsLocked,
    required this.products,
    required this.onTapProduct,
    required this.onTapProductExclusive,
    this.isLoading = false,
    this.style = const ProductsSliderStyle(),
  });

  /// Title of the slider. Defaults to 'Merch'.
  final String title;

  /// Returns whether the product is locked.
  final bool Function(T product) getIsLocked;

  /// Returns the name value for a product.
  final String Function(T product) getName;

  /// Returns the category value for a product.
  final String Function(T product) getCategory;

  /// Returns the imageUrl value for a product.
  final String Function(T product) getImageUrl;

  /// Called when a product is tapped.
  final ValueChanged<T> onTapProduct;

  /// Called when an exclusive product is tapped.
  final ValueChanged<T> onTapProductExclusive;

  /// List of products to display in the slider.
  final List<T> products;

  /// Whether the slider is in a loading state. Defaults to false.
  final bool isLoading;

  /// Style model for all design parameters. Defaults to [ProductsSliderStyle].
  final ProductsSliderStyle style;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: StoycoScreenSize.height(context, style.heightCard),
      width: double.infinity,
      child: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        padding: StoycoScreenSize.symmetric(context, horizontal: 20),
        separatorBuilder: (BuildContext context, int index) {
          return Gap(StoycoScreenSize.width(context, 20));
        },
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: isLoading ? 5 : products.length,
        itemBuilder: (BuildContext context, int index) {
          if (isLoading) {
            return SkeletonCard(
              width: StoycoScreenSize.width(context, style.widthCard),
              height: StoycoScreenSize.height(context, style.heightCard),
              borderRadius: BorderRadius.circular(style.borderRadiusCard),
            );
          }
          final T product = products[index];
          return ProductCardExclusiveLocked(
            key: ValueKey<String>('product_exclusive_locked_$index'),
            imageUrl: getImageUrl(product),
            name: getName(product),
            category: getCategory(product),
            isLocked: getIsLocked(product),
            onTapProduct: () => onTapProduct(product),
            onTapProductExclusive: () => onTapProductExclusive(product),
            backgroundColorCard: style.backgroundColorCard,
            borderRadiusCard: style.borderRadiusCard,
            categoryFontStyle: style.categoryFontStyle,
            nameFontStyle: style.nameFontStyle,
            heightCard: style.heightCard,
            widthCard: style.widthCard,
            imageError: style.imageError,
            imagePlaceholder: style.imagePlaceholder,
            paddingContentCard: style.paddingContentCard,
          );
        },
      ),
    );
  }
}

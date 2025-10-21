import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

/// {@template products_slider_style}
/// Model to centralize all design parameters for [ProductsSlider] and [ProductCardExclusiveLocked].
///
/// This allows for consistent styling and easy reuse of colors, paddings, font styles, and more.
///
/// Example usage:
/// ```dart
/// final style = ProductsSliderStyle();
/// ProductsSlider(
///   ...
///   style: style,
/// )
/// ```
/// {@endtemplate}
class ProductsSliderStyle {
  /// {@macro products_slider_style}

  const ProductsSliderStyle({
    this.backgroundColorCard = StoycoColors.cardDarkBackground,
    this.borderRadiusCard = 16,
    this.widthCard = 156,
    this.heightCard = 226,
    this.paddingContentCard,
    this.nameFontStyle,
    this.categoryFontStyle,
    this.imagePlaceholder,
    this.imageError,
  });

  /// Card background color.
  final Color backgroundColorCard;
  /// Card border radius.
  final double borderRadiusCard;
  /// Card width.
  final double widthCard;
  /// Card height.
  final double heightCard;
  /// Card content padding.
  final EdgeInsetsGeometry? paddingContentCard;
  /// Font style for the product name.
  final TextStyle? nameFontStyle;
  /// Font style for the product category.
  final TextStyle? categoryFontStyle;
  /// Placeholder widget for the image.
  final Widget? imagePlaceholder;
  /// Error widget for the image.
  final Widget? imageError;
}

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';

/// {@template events_slider_style}
/// A design model for [EventsSlider] and related Organism-level sliders in the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Centralizes all design parameters for event slider and card widgets, enabling consistent styling and easy reuse of colors, paddings, font styles, and more.
///
/// ### Parameters
/// - `backgroundColorCard`: Card background color. Defaults to [StoycoColors.cardDarkBackground].
/// - `borderRadiusCard`: Card border radius. Defaults to 16.
/// - `widthCard`: Card width. Defaults to 200.
/// - `heightCard`: Card height. Defaults to 200.
/// - `paddingContentCard`: Card content padding (optional).
/// - `nameFontStyle`: Font style for the event name (optional).
/// - `dateFontStyle`: Font style for the event date (optional).
/// - `imagePlaceholder`: Placeholder widget for the image (optional).
/// - `imageError`: Error widget for the image (optional).
///
/// ### Returns
/// Provides a style configuration object for event slider and card widgets.
///
/// ### Example
/// ```dart
/// final style = EventsSliderStyle(
///   backgroundColorCard: Colors.black,
///   borderRadiusCard: 20,
/// );
/// EventsSlider(
///   style: style,
/// )
/// ```
/// {@endtemplate}
class EventsSliderStyle {

  /// {@macro events_slider_style}
  const EventsSliderStyle({
    this.backgroundColorCard = StoycoColors.cardDarkBackground,
    this.borderRadiusCard = 16,
    this.widthCard = 200,
    this.heightCard = 200,
    this.paddingContentCard,
    this.nameFontStyle,
    this.dateFontStyle,
    this.imagePlaceholder,
    this.imageError,
  });

  /// Card background color. Defaults to [StoycoColors.cardDarkBackground].
  final Color backgroundColorCard;
  /// Card border radius. Defaults to 16.
  final double borderRadiusCard;
  /// Card width. Defaults to 200.
  final double widthCard;
  /// Card height. Defaults to 200.
  final double heightCard;
  /// Card content padding (optional).
  final EdgeInsetsGeometry? paddingContentCard;
  /// Font style for the event name (optional).
  final TextStyle? nameFontStyle;
  /// Font style for the event date (optional).
  final TextStyle? dateFontStyle;
  /// Placeholder widget for the image (optional).
  final Widget? imagePlaceholder;
  /// Error widget for the image (optional).
  final Widget? imageError;
}

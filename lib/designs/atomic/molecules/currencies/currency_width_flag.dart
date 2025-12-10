
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/flags/currency_flag.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/designs/utils/formatter_currency.dart';

/// {@template currency_width_flag}
/// A [CurrencyWidthFlag] molecule for the Stoyco Subscription Atomic Design System.
/// Displays a formatted price, currency code, and flag in a horizontal row, with customizable styles and alignment.
///
/// ### Atomic Level
/// **Molecule** – Composed of atoms for currency display and flag.
///
/// ### Parameters
/// - `priceFontSize`: Font size for the price value. Defaults to 40.
/// - `currencyFontSize`: Font size for the currency code. Defaults to 14.
/// - `currencyFlagWidth`: Width of the currency flag. Defaults to 24.
/// - `currencyFlagHeight`: Height of the currency flag. Defaults to 16.
/// - `currencyCode`: The currency code (e.g., 'USD').
/// - `price`: The price value to display.
/// - `currencySymbol`: The currency symbol (e.g., '$').
/// - `priceTextStyle`: Custom text style for the price value.
/// - `currencyTextStyle`: Custom text style for the currency code.
/// - `alignment`: Main axis alignment for the row. Defaults to [MainAxisAlignment.center].
///
/// ### Returns
/// Renders a row with formatted price, currency code, and flag, styled for atomic design systems.
///
/// ### Example
/// ```dart
/// CurrencyWidthFlag(
///   currencyCode: 'USD',
///   price: 9.99,
///   currencySymbol: '\$',
/// )
/// ```
/// {@endtemplate}

/// {@macro currency_width_flag}
class CurrencyWidthFlag extends StatelessWidget {
  /// Creates a [CurrencyWidthFlag] molecule for the Stoyco Subscription Design System.
  ///
  /// - [currencyCode]: The currency code (e.g., 'USD').
  /// - [price]: The price value to display.
  /// - [priceFontSize]: Font size for the price value. Defaults to 40.
  /// - [currencySymbol]: The currency symbol (e.g., '$').
  /// - [currencyFontSize]: Font size for the currency code. Defaults to 14.
  /// - [currencyFlagHeight]: Height of the currency flag. Defaults to 16.
  /// - [currencyFlagWidth]: Width of the currency flag. Defaults to 24.
  /// - [priceTextStyle]: Custom text style for the price value.
  /// - [currencyTextStyle]: Custom text style for the currency code.
  /// - [alignment]: Main axis alignment for the row. Defaults to [MainAxisAlignment.center].
  const CurrencyWidthFlag({
    super.key,
    required this.currencyCode,
    required this.price,
    this.priceFontSize = 40,
    required this.currencySymbol,
    this.currencyFontSize = 14,
    this.currencyFlagHeight = 16,
    this.currencyFlagWidth = 24,
    this.priceTextStyle,
    this.currencyTextStyle,
    this.alignment = MainAxisAlignment.center,
  });

  /// Font size for the price value. Defaults to 40.
  final double priceFontSize;
  /// Font size for the currency code. Defaults to 14.
  final double currencyFontSize;
  /// Width of the currency flag. Defaults to 24.
  final double currencyFlagWidth;
  /// Height of the currency flag. Defaults to 16.
  final double currencyFlagHeight;
  /// The currency code (e.g., 'USD').
  final String currencyCode;
  /// The price value to display.
  final double price;
  /// The currency symbol (e.g., '$').
  final String currencySymbol;
  /// Custom text style for the price value.
  final TextStyle? priceTextStyle;
  /// Custom text style for the currency code.
  final TextStyle? currencyTextStyle;
  /// Main axis alignment for the row. Defaults to [MainAxisAlignment.center].
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: <Widget>[
        Text(
          '$currencySymbol${formatPrice(price)}',
          style: priceTextStyle ?? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: StoycoScreenSize.fontSize(context, priceFontSize),
                color: StoycoColors.softWhite,
              ),
        ),
        Gap(StoycoScreenSize.width(context, 5)),
        Text(
          currencyCode,
          style: currencyTextStyle ?? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: StoycoScreenSize.fontSize(
                  context,
                  currencyFontSize,
                ),
                color: StoycoColors.iconDefault,
              ),
        ),
        Gap(StoycoScreenSize.width(context, 1)),
        Padding(
          padding: StoycoScreenSize.fromLTRB(context, left: 8),
          child: CurrencyFlag(
            height: currencyFlagHeight,
            width: currencyFlagWidth,
            currencyCode: currencyCode,
          ),
        ),
      ],
    );
  }
}

import 'package:country_flags/country_flags.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

  /// {@template currency_flag}
  /// A [CurrencyFlag] atom for the Stoyco Subscription Atomic Design System.
  /// Displays the flag of a currency as an emoji or image, using country and currency metadata.
  ///
  /// ### Atomic Level
  /// **Atom** – Smallest UI unit.
  ///
  /// ### Parameters
  /// - `currencyCode`: The currency code (e.g., 'USD', 'EUR') for which to display the flag.
  /// - `width`: The width of the flag image or emoji. Defaults to 24.
  /// - `height`: The height of the flag image or emoji. Defaults to 16.
  /// - `borderRadius`: The border radius for the flag image. Defaults to 1.
  ///
  /// ### Returns
  /// Renders a flag widget for the given currency code, using an image, emoji, or country flag, with design token sizing and border radius.
  ///
  /// ### Example
  /// ```dart
  /// CurrencyFlag(
  ///   currencyCode: 'USD',
  ///   width: 32,
  ///   height: 20,
  ///   borderRadius: 2,
  /// )
  /// ```
  /// {@endtemplate}
class CurrencyFlag extends StatelessWidget {
  /// {@macro currency_flag}
  const CurrencyFlag({
    super.key,
    required this.currencyCode,
    this.width = 24,
    this.height = 16,
    this.borderRadius = 1,
  });

  /// The currency code (e.g., 'USD', 'EUR') for which to display the flag.
  final String currencyCode;

  /// The width of the flag image or emoji. Defaults to 24.
  final double width;

  /// The height of the flag image or emoji. Defaults to 16.
  final double height;

  /// The border radius for the flag image. Defaults to 1.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget? flagWidget;
    try {
      flagWidget = CountryFlag.fromCurrencyCode(
        currencyCode,
        width: width,
        height: height,
        shape: RoundedRectangle(StoycoScreenSize.radius(context, borderRadius)),
      );
    } catch (e) {
      flagWidget = null;
    }

    if (flagWidget == null) {
      final Currency? currency = CurrencyService().findByCode(currencyCode);
      if (currency == null) {
        return const SizedBox.shrink();
      }
      if (currency.isFlagImage && currency.flag != null) {
        return Image.network(
          currency.flag!,
          width: width,
          height: height,
          fit: BoxFit.contain,
        );
      } else {
        final String flagEmoji = CurrencyUtils.currencyToEmoji(currency);
        return Text(flagEmoji, style: TextStyle(fontSize: height));
      }
    }
    return flagWidget;
  }
}

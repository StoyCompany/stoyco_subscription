import 'package:collection/collection.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';

/// Enum representing supported payment card types.
///
/// Provides utilities for detecting card type from a card number or code,
/// and for retrieving the associated icon asset path.
enum PaymentCardType {
  /// Visa card type.
  visa('visa', r'^4'),

  /// Mastercard card type.
  mastercard('mastercard', r'^5'),

  /// American Express card type.
  americanExpress('amex', r'^3[47]'),

  /// Discover card type.
  discover('discover', r'^6[0-9]'),

  /// Diners Club (14 digits) card type.
  dinersClub14('dinersClub14', r'^36'),

  /// Diners Club card type.
  dinersClub('dinersClub', r'^3(?:0[0-5]|[68][0-9])'),

  /// JCB card type.
  jcb('jcb', r'^35(?:2[89]|[3-8][0-9])'),

  /// Unknown card type.
  unknown('unknown', '');

  /// Creates a [PaymentCardType] with the given [code] and [regex] pattern.
  const PaymentCardType(this.code, this.regex);

  /// Returns the [PaymentCardType] matching the given [code], or [unknown] if not found.
  factory PaymentCardType.fromCode(String code) => values.firstWhere(
        (PaymentCardType value) => value.code == code,
        orElse: () => unknown,
      );

  /// Returns the [PaymentCardType] matching the given card [number] using regex patterns.
  ///
  /// If no match is found or the number is empty, returns [unknown].
  factory PaymentCardType.number(String number) {
    if (number.isEmpty) {
      return PaymentCardType.unknown;
    }

    final List<PaymentCardType> allCards = all();

    final PaymentCardType? search = allCards.firstWhereOrNull(
      (PaymentCardType element) => RegExp(element.regex).hasMatch(number),
    );

    if (search == null) {
      return PaymentCardType.unknown;
    }

    return search;
  }

  /// The code string associated with the card type (e.g., 'visa').
  final String code;

  /// The regex pattern used to identify the card type from a card number.
  final String regex;

  /// Returns the asset path for the icon representing this card type.
  String get icon {
    switch (this) {
      case PaymentCardType.visa:
        return StoycoAssets.lib.assets.icons.visaWhite.path;
      case PaymentCardType.mastercard:
        return StoycoAssets.lib.assets.icons.mastercard.path;
      case PaymentCardType.americanExpress:
        return StoycoAssets.lib.assets.icons.americanExpress.path;
      case PaymentCardType.discover:
        return StoycoAssets.lib.assets.icons.discover.path;
      case PaymentCardType.dinersClub:
      case PaymentCardType.dinersClub14:
        return StoycoAssets.lib.assets.icons.dinersClub.path;
      case PaymentCardType.jcb:
        return StoycoAssets.lib.assets.icons.jcb.path;
      case PaymentCardType.unknown:
        return StoycoAssets.lib.assets.icons.visaWhite.path;
    }
  }

  /// Returns a list of all supported [PaymentCardType] values except [unknown].
  static List<PaymentCardType> all() => <PaymentCardType>[
        PaymentCardType.visa,
        PaymentCardType.mastercard,
        PaymentCardType.americanExpress,
        PaymentCardType.discover,
        PaymentCardType.dinersClub,
        PaymentCardType.dinersClub14,
        PaymentCardType.jcb,
      ];
}

import 'package:collection/collection.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';

/// Enum representing supported payment card types.
///
/// Provides utilities for detecting card type from a card number or code,
/// and for retrieving the associated icon asset path.
enum PaymentCardType {

  /// Visa card type (Visa, Visa Debit, Visa Electron, etc.).
  /// Official range: starts with 4.
  visa('visa', r'^4'),

  /// Mastercard card type (includes credit, debit, prepaid, and series 2).
  /// Official range: 51-55, 2221-2720.
  mastercard('mastercard', r'^(5[1-5]|2(2[2-9][0-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[01][0-9]|720))'),

  /// American Express card type.
  /// Official range: 34, 37.
  americanExpress('amex', r'^3[47]'),

  /// Discover card type (includes Discover, Discover Debit, etc.).
  /// Official range: 6011, 622126-622925, 644-649, 65.
  discover('discover', r'^(6011|65|64[4-9]|622(12[6-9]|1[3-9][0-9]|[2-8][0-9]{2}|9([01][0-9]|2[0-5])))'),

  /// Diners Club (14 digits) card type.
  /// Official range: 36 (Diners Club International, 14 digits).
  dinersClub14('dinersClub14', r'^36'),

  /// Diners Club card type (Diners Club Carte Blanche, Diners Club North America).
  /// Official range: 300-305, 309, 38, 39.
  dinersClub('dinersClub', r'^3(0[0-5]|09|8|9)'),

  /// BCcard card type (South Korea, local franchise).
  /// Official range: 6556.
  bccard('bccard', r'^6556'),

  /// DinaCard card type (Serbia, local franchise).
  /// Official range: 6555.
  dinacard('dinacard', r'^6555'),

  /// JCB card type.
  /// Official range: 3528-3589.
  jcb('jcb', r'^35(2[89]|[3-8][0-9])'),

  /// UnionPay card type (credit, debit, 19 digits, etc.).
  /// Official range: starts with 62.
  unionPay('unionPay', r'^62'),

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
        return StoycoAssets.lib.assets.icons.payment.visaWhite.path;
      case PaymentCardType.mastercard:
      case PaymentCardType.bccard:
      case PaymentCardType.dinacard:
        return StoycoAssets.lib.assets.images.payment.mastercard.path;
      case PaymentCardType.americanExpress:
        return StoycoAssets.lib.assets.images.payment.americanExpress.path;
      case PaymentCardType.discover:
        return StoycoAssets.lib.assets.images.payment.discover.path;
      case PaymentCardType.dinersClub:
      case PaymentCardType.dinersClub14:
        return StoycoAssets.lib.assets.images.payment.dinersClub.path;
      case PaymentCardType.jcb:
        return StoycoAssets.lib.assets.images.payment.jcb.path;
      case PaymentCardType.unionPay:
        return StoycoAssets.lib.assets.images.payment.unionPay.path;
      case PaymentCardType.unknown:
        return StoycoAssets.lib.assets.icons.payment.visaWhite.path;
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
        PaymentCardType.bccard,
        PaymentCardType.dinacard,
        PaymentCardType.jcb,
        PaymentCardType.unionPay,
      ];
}

import 'package:collection/collection.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';

enum PaymentCardType {
  visa('visa', r'^4'),
  mastercard('mastercard', r'^5'),
  americanExpress('amex', r'^3[47]'),
  discover('discover', r'^6[0-9]'),
  dinersClub14('dinersClub14', r'^36'),
  dinersClub('dinersClub', r'^3(?:0[0-5]|[68][0-9])'),
  jcb('jcb', r'^35(?:2[89]|[3-8][0-9])'),
  unknown('unknown', '');

  const PaymentCardType(this.code, this.regex);

  factory PaymentCardType.fromCode(String code) => values.firstWhere(
    (PaymentCardType value) => value.code == code,
    orElse: () => unknown,
  );

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

  final String code;
  final String regex;

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

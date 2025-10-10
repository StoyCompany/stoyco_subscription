import 'package:collection/collection.dart';

enum PaymentCardType {
  visa('visa', r'^4', 'assets/payment/methods/visa.png'),
  mastercard('mastercard', r'^5', 'lib/assets/payment/methods/mastercard.png'),
  americanExpress(
    'amex',
    r'^3[47]',
    'lib/assets/payment/methods/american-express.png',
  ),
  discover('discover', r'^6[0-9]', 'lib/assets/payment/methods/discover.png'),
  dinersClub14(
    'dinersClub14',
    r'^36',
    'lib/assets/payment/methods/diners-club.png',
  ),
  dinersClub(
    'dinersClub',
    r'^3(?:0[0-5]|[68][0-9])',
    'lib/assets/payment/methods/diners-club.png',
  ),
  jcb('jcb', r'^35(?:2[89]|[3-8][0-9])', 'assets/payment/methods/jcb.png'),
  unknown('unknown', '', 'lib/assets/icons/payment/Visa_white.svg');

  const PaymentCardType(this.code, this.regex, this.icon);

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
  final String icon;

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

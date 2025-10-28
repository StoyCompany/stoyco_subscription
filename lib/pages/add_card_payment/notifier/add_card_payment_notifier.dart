import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/pages/add_card_payment/enums/payment_card_type.dart';
import 'package:stoyco_subscription/pages/add_card_payment/models/payment_card.dart';


class AddCardPaymentNotifier extends ChangeNotifier {
  AddCardPaymentNotifier();

  bool isDisabled = true;

  PaymentCardType cardType = PaymentCardType.unknown;

  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();

  String? errorCardHolderName;
  String? errorCardNumber;
  String? errorCardExpiry;
  String? errorCardCvv;

  FocusNode cardHolderNameFocusNode = FocusNode();
  FocusNode cardNumberFocusNode = FocusNode();
  FocusNode cardExpiryFocusNode = FocusNode();
  FocusNode cardCvvFocusNode = FocusNode();

  bool isLoading = false;

  bool valueTerms = false;
  bool valuePrivacy = false;
  bool valueAutoRenew = false;

  void onChangedTerms(bool? v) {
    valueTerms = v ?? false;
    validateIsDisabled();
    notifyListeners();
  }

  void onChangedPrivacy(bool? v) {
    valuePrivacy = v ?? false;
    validateIsDisabled();
    notifyListeners();
  }

  void onChangedAutoRenew(bool? v) {
    valueAutoRenew = v ?? false;
    notifyListeners();
  }

  bool isAllValid() => errorCardNumber == null && errorCardExpiry == null && errorCardCvv == null && errorCardHolderName == null;

  void validateCardExpiry() {
    errorCardExpiry = PaymentCard.checkExpiration(cardExpiryController.text);
    validateIsDisabled();
    notifyListeners();
  }

  void validateCardCvc() {
    errorCardCvv = PaymentCard.checkSecurityCode(
      cardCvvController.text,
      cardNumberController.text,
    );
    validateIsDisabled();
    notifyListeners();
  }

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void validateIsDisabled() {
    if (errorCardNumber == null &&
        errorCardExpiry == null &&
        errorCardCvv == null &&
        errorCardHolderName == null &&
        cardHolderNameController.text.isNotEmpty &&
        cardNumberController.text.isNotEmpty &&
        cardExpiryController.text.isNotEmpty &&
        cardCvvController.text.isNotEmpty &&
        valueTerms &&
        valuePrivacy) {
      isDisabled = false;
    } else {
      isDisabled = true;
    }
  }

  String maskedCardNumber(String input) {
    // Elimina espacios y deja solo dígitos
    final String digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }
    final String visible = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
    final int maskedLength = digits.length > 4 ? digits.length - 4 : 0;
    final String masked = List<String>.filled(maskedLength, '*').join();
    // Agrupa en bloques de 4
    final String full = (masked + visible).padLeft(16, '*');
    return full.replaceAllMapped(RegExp(r'.{1,4}'), (Match m) => '${m.group(0)} ').trim();
  }

  void setErrorsCardNumber(int cardNumberLenght) {
    errorCardNumber = PaymentCard.checkCardNumberLength(
      cardNumberController.text,
      cardNumberLenght,
    );
  }

  void onCardHolderNameChange(BuildContext context) {
    final String value = cardHolderNameController.text;
    // Permitir solo letras, espacios y acentos comunes
    final RegExp validChars = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+');
    if (value.isEmpty) {
      errorCardHolderName = 'El nombre no puede estar vacío';
    } else if (!validChars.hasMatch(value)) {
      errorCardHolderName = 'El nombre no debe contener caracteres especiales ni números';
      // Eliminar caracteres inválidos automáticamente
      cardHolderNameController.text = value.replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]'), '');
      cardHolderNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardHolderNameController.text.length),
      );
    } else {
      errorCardHolderName = null;
    }
    validateIsDisabled();
    notifyListeners();
  }

  void onCardNumberChange(BuildContext context) {
    cardType = PaymentCardType.number(cardNumberController.text.replaceAll(' ', ''));
    switch (cardType) {
      case PaymentCardType.visa:
      case PaymentCardType.mastercard:
      case PaymentCardType.discover:
      case PaymentCardType.dinersClub:
      case PaymentCardType.jcb:
        rulesForCardNumber16Digits(context);
      case PaymentCardType.americanExpress:
        rulesForCardNumber15Digits(context);
      case PaymentCardType.dinersClub14:
        rulesForCardNumber14Digits(context);
      case PaymentCardType.unknown:
        break;
    }
    validateIsDisabled();
    notifyListeners();
  }

  void onCardExpiryChange(BuildContext context) {
    validateCardExpiry();

    if (cardExpiryController.text.contains(' ')) {
      cardExpiryController.text = cardExpiryController.text.replaceAll(' ', '');
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    }

    if (cardExpiryController.text.contains(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'))) {
      cardExpiryController.text = cardExpiryController.text.replaceAll(
        RegExp(r'[/!@#$%^&*(),.?":{}|<>]'),
        '',
      );
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    }

    if (cardExpiryController.text.contains(RegExp(r'[a-zA-Z]'))) {
      cardExpiryController.text =
          cardExpiryController.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    }

    if (cardExpiryController.text.length >= 4 && errorCardExpiry == null) {
      cardExpiryController.text = cardExpiryController.text.substring(0, 4);
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).requestFocus(cardCvvFocusNode);
    } else if (cardExpiryController.text.length >= 4 && errorCardExpiry != null) {
      cardExpiryController.text = cardExpiryController.text.substring(0, 4);
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).requestFocus(cardExpiryFocusNode);
    }

    if (cardExpiryController.text.length == 1 && cardExpiryController.text[0] != '0' && cardExpiryController.text[0] != '1') {
      cardExpiryController.text = '0${cardExpiryController.text}${cardExpiryController.text.substring(1)}';
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    }
    if (cardExpiryController.text.length == 2 &&
        cardExpiryController.text[0] == '1' &&
        cardExpiryController.text[1] != '0' &&
        cardExpiryController.text[1] != '1' &&
        cardExpiryController.text[1] != '2') {
      cardExpiryController.text = '0${cardExpiryController.text[0]}${cardExpiryController.text[1]}';
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    }

    if (cardExpiryController.text.length >= 3 && cardExpiryController.text[2] != '/') {
      cardExpiryController.text = '${cardExpiryController.text.substring(0, 2)}/${cardExpiryController.text.substring(2)}';
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    } else if (cardExpiryController.text.length == 3 && cardExpiryController.text[2] == '/') {
      cardExpiryController.text = cardExpiryController.text.substring(0, 2) + cardExpiryController.text.substring(3);
      cardExpiryController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardExpiryController.text.length,
        ),
      );
    }
    notifyListeners();
  }

  void onCardCvvChange(BuildContext context) {
    validateCardCvc();
    if (cardCvvController.text.length > 4) {
      cardCvvController.text = cardCvvController.text.substring(0, 4);
      cardCvvController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardCvvController.text.length,
        ),
      );
    }
    if (cardCvvController.text.contains(' ') || cardCvvController.text.contains(RegExp(r'[a-zA-Z]'))) {
      cardCvvController.text = cardCvvController.text.replaceAll(' ', '');
      cardCvvController.text = cardCvvController.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      cardCvvController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardCvvController.text.length,
        ),
      );
    }

    cardCvvController.text = cardCvvController.text.replaceAll(RegExp(r'[^\w\s]+'), '');

    cardCvvController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: cardCvvController.text.length,
      ),
    );

    if (
      cardCvvController.text.length == 3 && 
      PaymentCardType.number( cardNumberController.text.replaceAll(' ', '')) !=
      PaymentCardType.americanExpress ||
      (PaymentCardType.number( cardNumberController.text.replaceAll(' ', '')) == PaymentCardType.americanExpress && cardCvvController.text.length == 4)
    ) {
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  String getSeedDate() {
    final DateTime startDate = DateTime.now().toUtc();
    final List<String> info = <String>[
      'FJV1FEN',
      'Vk1YMU',
      'VdET1FDQk',
      'Y3U0ZZRF',
      'FROVVU=',
      'k5VVczO',
    ];
    final String decoded = utf8.decode(base64Url.decode(info[1] + info[0] + info[2] + info[3] + info[5] + info[4]));
    return '${startDate.day}${startDate.month}${startDate.hour}${startDate.minute}$decoded';
  }

  void rulesForCardNumber16Digits(BuildContext context) {
    setErrorsCardNumber(16);
    final String cleanedText = cardNumberController.text.replaceAll(' ', '');

    if (cleanedText.length >= 16 && errorCardNumber == null) {
      if (cardNumberController.text.length > 19) {
        cardNumberController.text = cardNumberController.text.substring(0, 19);
      }
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).requestFocus(cardExpiryFocusNode);
    } else if (cleanedText.length > 16) {
      if (cardNumberController.text.length > 19) {
        cardNumberController.text = cardNumberController.text.substring(0, 19);
      }
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    if (cardNumberController.text.length == 5 && cardNumberController.text[4] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 4)} ${cardNumberController.text.substring(4)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    } else if (cardNumberController.text.length == 5 && cardNumberController.text[4] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 4) + cardNumberController.text.substring(5);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    if (cardNumberController.text.length == 10 && cardNumberController.text[9] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 9)} ${cardNumberController.text.substring(9)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    } else if (cardNumberController.text.length == 10 && cardNumberController.text[9] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 9) + cardNumberController.text.substring(10);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    if (cardNumberController.text.length == 15 && cardNumberController.text[14] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 14)} ${cardNumberController.text.substring(14)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    } else if (cardNumberController.text.length == 15 && cardNumberController.text[14] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 14) + cardNumberController.text.substring(15);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    if (cardNumberController.text.contains(RegExp(r'[a-zA-Z]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    if (cardNumberController.text.length != 5 && cardNumberController.text.length != 10 &&
        cardNumberController.text.length != 15 && cardNumberController.text.contains(' ')
      ) {
      cardNumberController.text = cardNumberController.text.replaceAll(' ', '');
      if (cardNumberController.text.length > 4) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 4)} ${cardNumberController.text.substring(4)}';
      }
      if (cardNumberController.text.length > 9) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 9)} ${cardNumberController.text.substring(9)}';
      }
      if (cardNumberController.text.length > 14) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 14)} ${cardNumberController.text.substring(14)}';
      }
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    if (cardNumberController.text.contains(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'), '');
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }
  }

  void rulesForCardNumber15Digits(BuildContext context) {
    setErrorsCardNumber(15);
    if (cardNumberController.text.replaceAll(' ', '').length >= 15 && errorCardNumber == null) {
      cardNumberController.text = cardNumberController.text.substring(0, 17);
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).requestFocus(cardExpiryFocusNode);
    } else if (cardNumberController.text.replaceAll(' ', '').length > 15) {
      cardNumberController.text = cardNumberController.text.substring(0, 18);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.length == 5 && cardNumberController.text[4] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 4)} ${cardNumberController.text.substring(4)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    } else if (cardNumberController.text.length == 5 && cardNumberController.text[4] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 4) + cardNumberController.text.substring(5);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.length == 11 && cardNumberController.text[10] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 10)} ${cardNumberController.text.substring(10)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    } else if (cardNumberController.text.length == 11 && cardNumberController.text[10] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 10) + cardNumberController.text.substring(11);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }
    if (cardNumberController.text.contains(RegExp(r'[a-zA-Z]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.length != 5 && cardNumberController.text.length != 11 && cardNumberController.text.contains(' ')) {
      cardNumberController.text = cardNumberController.text.replaceAll(' ', '');
      if (cardNumberController.text.length > 4) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 4)} ${cardNumberController.text.substring(4)}';
      }
      if (cardNumberController.text.length > 11) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 11)} ${cardNumberController.text.substring(11)}';
      }
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.contains(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(
        RegExp(r'[/!@#$%^&*(),.?":{}|<>]'),
        '',
      );
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }
  }

  void rulesForCardNumber14Digits(BuildContext context) {
    setErrorsCardNumber(14);
    if (cardNumberController.text.replaceAll(' ', '').length >= 14 && errorCardNumber == null) {
      cardNumberController.text = cardNumberController.text.substring(0, 16);
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).requestFocus(cardExpiryFocusNode);
    } else if (cardNumberController.text.replaceAll(' ', '').length > 14) {
      cardNumberController.text = cardNumberController.text.substring(0, 16);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.length == 5 && cardNumberController.text[4] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 4)} ${cardNumberController.text.substring(4)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    } else if (cardNumberController.text.length == 5 && cardNumberController.text[4] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 4) + cardNumberController.text.substring(5);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.length == 12 && cardNumberController.text[11] != ' ') {
      cardNumberController.text = '${cardNumberController.text.substring(0, 11)} ${cardNumberController.text.substring(11)}';
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    } else if (cardNumberController.text.length == 12 && cardNumberController.text[12] == ' ') {
      cardNumberController.text = cardNumberController.text.substring(0, 11) + cardNumberController.text.substring(12);
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.contains(RegExp(r'[a-zA-Z]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.length != 5 && cardNumberController.text.length != 12 && cardNumberController.text.contains(' ')) {
      cardNumberController.text = cardNumberController.text.replaceAll(' ', '');
      if (cardNumberController.text.length > 4) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 4)} ${cardNumberController.text.substring(4)}';
      }
      if (cardNumberController.text.length > 11) {
        cardNumberController.text = '${cardNumberController.text.substring(0, 11)} ${cardNumberController.text.substring(11)}';
      }
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }

    if (cardNumberController.text.contains(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(
        RegExp(r'[/!@#$%^&*(),.?":{}|<>]'),
        '',
      );
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: cardNumberController.text.length,
        ),
      );
    }
  }

}

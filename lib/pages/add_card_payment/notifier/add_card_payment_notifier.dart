import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoyco_subscription/pages/add_card_payment/enums/payment_card_type.dart';
import 'package:stoyco_subscription/pages/add_card_payment/models/payment_card.dart';



class AddCardPaymentNotifier extends ChangeNotifier {
  AddCardPaymentNotifier({
    FocusNode? cardHolderNameFocusNode,
    FocusNode? cardNumberFocusNode,
    FocusNode? cardExpiryFocusNode,
    FocusNode? cardCvvFocusNode,
  }) {
    if (cardHolderNameFocusNode != null) {
      this.cardHolderNameFocusNode = cardHolderNameFocusNode;
    }
    if (cardNumberFocusNode != null) {
      this.cardNumberFocusNode = cardNumberFocusNode;
    }
    if (cardExpiryFocusNode != null) {
      this.cardExpiryFocusNode = cardExpiryFocusNode;
    }
    if (cardCvvFocusNode != null) {
      this.cardCvvFocusNode = cardCvvFocusNode;
    }
  }

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

  bool isAllValid() => errorCardNumber == null && errorCardExpiry == null && errorCardCvv == null && errorCardHolderName == null;

  void validateCardHolderName() {
    errorCardHolderName = PaymentCard.checkCardHolderName(cardHolderNameController.text);
    validateIsDisabled();
    notifyListeners();
  }

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
    final String digits = input.replaceAll(' ', '');
    if (digits.isEmpty) {
      return '';
    }
    final PaymentCardType type = PaymentCardType.number(digits);
    final List<String> blocks = <String>[];
    int visibleCount = 4;
    List<int> blockSizes = <int>[4, 4, 4, 4];
    if (type == PaymentCardType.americanExpress) {
      blockSizes = <int>[4, 6, 5];
      visibleCount = 5;
    } else if (type == PaymentCardType.dinersClub14) {
      blockSizes = <int>[4, 6, 4];
      visibleCount = 4;
    } else if (type == PaymentCardType.unionPay && digits.length > 16) {
      // UnionPay 19 digits: 4-4-4-4-3
      blockSizes = <int>[4, 4, 4, 4, 3];
      visibleCount = 3;
    }

    int idx = 0;
    final int len = digits.length;
    int remaining = len;
    for (final int size in blockSizes) {
      if (remaining <= 0) {
        break;
      }
      final int take = remaining >= size ? size : remaining;
      blocks.add(digits.substring(idx, idx + take));
      idx += take;
      remaining -= take;
    }
    // Mask all blocks except the last visible
    if (len <= visibleCount) {
      return digits;
    }
    String result = '';
    for (int i = 0; i < blocks.length; i++) {
      if (type == PaymentCardType.americanExpress) {
        // Amex: 4-6-5
        if (i == 0) {
          result += List<String>.filled(blocks[i].length, '*').join();
        } else if (i == 1) {
          result += ' ';
          result += List<String>.filled(blocks[i].length, '*').join();
        } else if (i == 2) {
          result += ' ';
          result += blocks[i];
        }
      } else if (type == PaymentCardType.dinersClub14) {
        // Diners Club 14: 4-6-4
        if (i == 0) {
          result += List<String>.filled(blocks[i].length, '*').join();
        } else if (i == 1) {
          result += ' ';
          result += List<String>.filled(blocks[i].length, '*').join();
        } else if (i == 2) {
          result += ' ';
          result += blocks[i];
        }
      } else if (type == PaymentCardType.unionPay && blockSizes.length == 5) {
        // UnionPay 19: 4-4-4-4-3, mask all except last block
        if (i < blocks.length - 1) {
          result += List<String>.filled(blocks[i].length, '*').join();
        } else {
          result += ' ';
          result += blocks[i];
        }
      } else {
        // Other cards: 4-4-4-4, mask all except last 4
        if (i < blocks.length - 1) {
          result += List<String>.filled(blocks[i].length, '*').join();
        } else {
          final int blockLen = blocks[i].length;
          if (blockLen <= visibleCount) {
            result += blocks[i];
          } else {
            result += List<String>.filled(blockLen - visibleCount, '*').join();
            result += blocks[i].substring(blockLen - visibleCount);
          }
        }
      }
      if (i < blocks.length - 1) {
        result += ' ';
      }
    }
    return result.trim();
  }

  void setErrorsCardNumber(int cardNumberLenght) {
    errorCardNumber = PaymentCard.checkCardNumberLength(
      cardNumberController.text,
      cardNumberLenght,
    );
  }

  void onCardHolderNameChange(BuildContext context) {
    notSpecialCharacters(cardHolderNameController);
    validateCardHolderName();
  }

  void onCardNumberChange(BuildContext context) {
    cardType = PaymentCardType.number(cardNumberController.text.replaceAll(' ', ''));
    if (cardType == PaymentCardType.americanExpress) {
      rulesForCardNumber15Digits(context);
    } else if (cardType == PaymentCardType.dinersClub14) {
      rulesForCardNumber14Digits(context);
    } else if (cardType == PaymentCardType.unionPay) {
      if (cardNumberController.text.replaceAll(' ', '').length > 16) {
        rulesForCardNumber19Digits(context);
      } else {
        // UnionPay 16, 17, 18 digits: treat as 16 for formatting/validation
        rulesForCardNumber16Digits(context);
      }
    } else {
      // Default: 16 digits (Visa, Mastercard, Discover, DinersClub, JCB, unknown, etc.)
      rulesForCardNumber16Digits(context);
    }
    notSpecialCharacters(cardNumberController);
    validateIsDisabled();
    notifyListeners();
  }

  void onCardExpiryChange(BuildContext context) {
    validateCardExpiry();

    notSpaces(cardExpiryController);
    notSpecialCharacters(cardExpiryController);
    notLetters(cardExpiryController);

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
    
    notSpaces(cardCvvController);
    notSpecialCharacters(cardCvvController);
    notLetters(cardCvvController);

    cardCvvController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: cardCvvController.text.length,
      ),
    );

    if (
      cardCvvController.text.length == 3 && 
      PaymentCardType.number( cardNumberController.text.replaceAll(' ', '')) != PaymentCardType.americanExpress ||
      (PaymentCardType.number( cardNumberController.text.replaceAll(' ', '')) == PaymentCardType.americanExpress && cardCvvController.text.length == 4)
    ) {
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  void notSpecialCharacters(TextEditingController controller) {
    if (controller.text.contains(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'))) {
      controller.text = controller.text.replaceAll(RegExp(r'[/!@#$%^&*(),.?":{}|<>]'), '');
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  void notLetters(TextEditingController controller) {
    if (controller.text.contains(RegExp(r'[a-zA-Z]'))) {
      controller.text = controller.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  void notSpaces(TextEditingController controller) {
    if (controller.text.contains(' ')) {
      controller.text = controller.text.replaceAll(' ', '');
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
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

  void rulesForCardNumber19Digits(BuildContext context) {
    setErrorsCardNumber(19);
    final String cleanedText = cardNumberController.text.replaceAll(' ', '');

    if (cleanedText.length >= 19 && errorCardNumber == null) {
      if (cardNumberController.text.length > 23) {
        cardNumberController.text = cardNumberController.text.substring(0, 23);
      }
      final FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).requestFocus(cardExpiryFocusNode);
    } else if (cleanedText.length > 19) {
      if (cardNumberController.text.length > 23) {
        cardNumberController.text = cardNumberController.text.substring(0, 23);
      }
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    // Insert spaces after every 4 digits
    for (int i = 4; i < cardNumberController.text.length; i += 5) {
      if (cardNumberController.text.length > i && cardNumberController.text[i] != ' ') {
        cardNumberController.text = '${cardNumberController.text.substring(0, i)} ${cardNumberController.text.substring(i)}';
        cardNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: cardNumberController.text.length),
        );
      }
    }

    if (cardNumberController.text.contains(RegExp(r'[a-zA-Z]'))) {
      cardNumberController.text = cardNumberController.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
      cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: cardNumberController.text.length),
      );
    }

    // Remove spaces if not at correct positions
    final List<int> validSpacePositions = <int>[4, 9, 14, 19];
    for (int i = 0; i < cardNumberController.text.length; i++) {
      if (cardNumberController.text[i] == ' ' && !validSpacePositions.contains(i)) {
        cardNumberController.text = cardNumberController.text.replaceFirst(' ', '');
        cardNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: cardNumberController.text.length),
        );
      }
    }
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
  }

}

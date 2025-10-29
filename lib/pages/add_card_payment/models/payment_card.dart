import 'package:stoyco_subscription/pages/add_card_payment/enums/payment_card_type.dart';

class PaymentCard {
  PaymentCard({
    this.cardNumber = '',
    this.expiration = '',
    this.securityCode = '',
  });

  final String cardNumber;
  final String expiration;
  final String securityCode;

  bool isValidCheckExpiration() => checkExpiration(expiration) == null;
  bool isValidSecurityCode() =>
      checkSecurityCode(securityCode, cardNumber) == null;

  static String? checkExpiration(String cardExpiration) {
    String? errorResponse;
    if (cardExpiration.isEmpty) {
      errorResponse = 'La fecha de expiración es requerida';
    } else if (cardExpiration.length < 5) {
      errorResponse = 'La fecha de expiración es inválida';
    } else if (!RegExp(r'^[0-9]{2}\/[0-9]{2}$').hasMatch(cardExpiration)) {
      errorResponse = 'La fecha de expiración es inválida';
    } else if (int.parse(cardExpiration.substring(0, 2)) < 1 ||
        int.parse(cardExpiration.substring(0, 2)) > 12) {
      errorResponse = 'La fecha de expiración es inválida';
    } else {
      final DateTime now = DateTime.now();
      final DateTime limit = DateTime(now.year + 20, now.month, now.day);
      final DateTime expiry = DateTime(
        2000 + int.parse(cardExpiration.substring(3, 5)),
        int.parse(cardExpiration.substring(0, 2)),
      );
      if (expiry.isBefore(DateTime(now.year, now.month))) {
        errorResponse = 'La fecha de expiración no puede ser menor a la actual';
      } else if (expiry.isAfter(limit)) {
        errorResponse = 'La fecha de expiración no puede ser mayor a 20 años desde hoy';
      } else {
        errorResponse = null;
      }
    }

    return errorResponse;
  }

  static String? checkSecurityCode(String securityCode, String cardNumber) {
    String? errorResponse;
    if (securityCode.isEmpty) {
      errorResponse = 'El CVV es requerido';
    } else if (!(securityCode.length == 3 && PaymentCardType.number(cardNumber.replaceAll(' ', '')) != 
            PaymentCardType.americanExpress || (PaymentCardType.number(cardNumber.replaceAll(' ', '')) == 
            PaymentCardType.americanExpress && securityCode.length == 4))) {
      errorResponse = 'El CVV es inválido';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(securityCode)) {
      errorResponse = 'El CVV es inválido';
    } else {
      errorResponse = null;
    }

    return errorResponse;
  }

  static String? checkCardNumberLength(String cardNumber, int length) {
    String? errorResponse;
    if (cardNumber.replaceAll(' ', '').isEmpty) {
      errorResponse = 'El número de tarjeta es requerido';
    } else if (cardNumber.replaceAll(' ', '').length < length) {
      errorResponse = 'El número de tarjeta es inválido';
    } else {
      final RegExp regex = RegExp(r'^[0-9]+$');
      if (!regex.hasMatch(cardNumber.replaceAll(' ', ''))) {
        errorResponse = 'El número de tarjeta es inválido';
      }
    }
    return errorResponse;
  }

  static String? checkCardHolderName(String text) {
    String? errorResponse;
    if (text.isEmpty) {
      errorResponse = 'El nombre del titular es requerido';
    } else {
      final RegExp validChars = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$');
      if (!validChars.hasMatch(text)) {
        errorResponse = 'El nombre del titular es inválido';
      }
    }
    return errorResponse;
  }
}

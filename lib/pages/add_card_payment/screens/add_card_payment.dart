import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/add_card_payment/notifier/add_card_payment_notifier.dart';
import 'package:stoyco_subscription/pages/add_card_payment/screens/add_card_payment_mobile_view.dart';
import 'package:stoyco_subscription/pages/add_card_payment/screens/add_card_payment_web_screen.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';

/// {@template add_card_payment}
/// An [AddCardPayment] Page for the Stoyco Subscription Atomic Design System.
/// Displays a complete payment form for adding a card, including payment summary,
/// card details, terms acceptance, and submit button.
///
/// This widget automatically adapts its layout based on screen size:
/// - **Mobile**: Single column vertical layout
/// - **Desktop/Tablet**: Two-column layout with card preview on left, form on right
///
/// ### Atomic Level
/// **Page** – Composed of molecules and atoms for complex payment flow integration.
///
/// ### Parameters
/// - `paymentSummaryInfo`: Optional payment summary data model for displaying plan/payment info.
/// - `onTapTerms`: Callback to navigate to terms and conditions.
/// - `onTapPrivacy`: Callback to navigate to privacy policy.
/// - `onTapAddCardPayment`: Callback executed when the user submits the payment form.
///
/// ### Returns
/// Renders a responsive payment form with card details, summary, terms acceptance, and a submit button.
///
/// ### Example
/// ```dart
/// AddCardPayment(
///   paymentSummaryInfo: paymentSummaryInfo,
///   onTapTerms: () {},
///   onTapPrivacy: () {},
///   onTapAddCardPayment: ({
///     required cardHolderName,
///     required cardNumber,
///     required cardExpiry,
///     required cardCvv,
///     required seedDate,
///     required isError,
///     required errorMessage,
///   }) async {},
/// )
/// ```
/// {@endtemplate}

/// {@macro add_card_payment}
class AddCardPayment extends StatefulWidget {
  /// Creates an [AddCardPayment] Page for the Stoyco Subscription Design System.
  ///
  /// - [paymentSummaryInfo]: Optional payment summary data model for displaying plan/payment info.
  /// - [onTapTerms]: Callback to navigate to terms and conditions.
  /// - [onTapPrivacy]: Callback to navigate to privacy policy.
  /// - [onTapAddCardPayment]: Callback executed when the user submits the payment form.
  const AddCardPayment({
    super.key,
    this.paymentSummaryInfo,
    required this.onTapTerms,
    required this.onTapPrivacy,
    required this.onTapAddCardPayment,
  });

  /// Optional payment summary data model for displaying plan/payment info.
  final PaymentSummaryInfoResponse? paymentSummaryInfo;

  /// Callback to navigate to terms and conditions.
  final VoidCallback onTapTerms;

  /// Callback to navigate to privacy policy.
  final VoidCallback onTapPrivacy;

  /// Callback executed when the user submits the payment form.
  final Future<void> Function({
    required String cardHolderName,
    required String cardNumber,
    required String cardExpiry,
    required String cardCvv,
    required String seedDate,
    required bool isError,
    required String errorMessage,
  })
  onTapAddCardPayment;

  @override
  State<AddCardPayment> createState() => _AddCardPaymentState();
}

class _AddCardPaymentState extends State<AddCardPayment> {
  late final AddCardPaymentNotifier notifier;
  late final FocusNode cardHolderNameFocusNode;
  late final FocusNode cardNumberFocusNode;
  late final FocusNode cardExpiryFocusNode;
  late final FocusNode cardCvvFocusNode;

  @override
  void initState() {
    super.initState();
    cardHolderNameFocusNode = FocusNode();
    cardNumberFocusNode = FocusNode();
    cardExpiryFocusNode = FocusNode();
    cardCvvFocusNode = FocusNode();
    notifier = AddCardPaymentNotifier(
      cardHolderNameFocusNode: cardHolderNameFocusNode,
      cardNumberFocusNode: cardNumberFocusNode,
      cardExpiryFocusNode: cardExpiryFocusNode,
      cardCvvFocusNode: cardCvvFocusNode,
    );
    notifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    notifier.removeListener(_onNotifierChanged);
    notifier.cardNumberController.dispose();
    notifier.cardExpiryController.dispose();
    notifier.cardCvvController.dispose();
    cardHolderNameFocusNode.dispose();
    cardNumberFocusNode.dispose();
    cardExpiryFocusNode.dispose();
    cardCvvFocusNode.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Responsive layout selection
    if (StoycoScreenSize.isPhone(context)) {
      return AddCardPaymentMobileScreen(
        notifier: notifier,
        paymentSummaryInfo: widget.paymentSummaryInfo,
        onTapTerms: widget.onTapTerms,
        onTapPrivacy: widget.onTapPrivacy,
        onTapAddCardPayment: widget.onTapAddCardPayment,
      );
    } else {
      return AddCardPaymentWebScreen(
        notifier: notifier,
        paymentSummaryInfo: widget.paymentSummaryInfo,
        onTapTerms: widget.onTapTerms,
        onTapPrivacy: widget.onTapPrivacy,
        onTapAddCardPayment: widget.onTapAddCardPayment,
      );
    }
  }
}

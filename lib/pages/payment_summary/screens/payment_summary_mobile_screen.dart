import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_payment_preview_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/payment_information_section.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/select_payment_method_section.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/notifier/payment_summary_notifier.dart';

/// {@template payment_summary_mobile_screen}
/// Displays the content of the payment summary for mobile devices.
///
/// This widget does not include a [Scaffold], [AppBar], or floating action button.
/// It expects the [PaymentSummaryNotifier] and loading state to be managed by the parent.
///
/// The content includes:
///  - A preview card with the payment summary information.
///  - A section with payment breakdown details (plan and IVA).
///  - A section to select the payment method.
///
/// Example usage:
/// ```dart
/// PaymentSummaryMobileScreen(
///   notifier: myNotifier,
///   isLoading: false,
/// )
/// ```
///
/// {@endtemplate}
class PaymentSummaryMobileScreen extends StatelessWidget {
  /// Creates a [PaymentSummaryMobileScreen].
  ///
  /// [notifier] provides the payment summary data.
  /// [isLoading] controls whether to show a loading indicator.
  const PaymentSummaryMobileScreen({
    super.key,
    required this.notifier,
    required this.isLoading,
  });

  /// The notifier that holds the payment summary information.
  final PaymentSummaryNotifier notifier;

  /// Whether the content is loading.
  final bool isLoading;

  /// Returns a list of key-value pairs with payment information items.
  ///
  /// Each item contains a 'key' (label) and a 'value' (amount with currency).
  List<Map<String, String>> getPaymentInfoItems() {
    final PaymentSummaryInfoResponse? info = notifier.paymentSummaryInfo;
    final String code = info?.breakdown.currencyCode ?? 'MXN';
    final String symbol = info?.breakdown.currencySymbol ?? r'$';
    return <Map<String, String>>[
      <String, String>{
        'key': 'Plan',
        'value':
            '$code $symbol${info?.breakdown.planAmount.toStringAsFixed(2) ?? '0.00'}',
      },
      <String, String>{
        'key': 'IVA',
        'value':
            '$code $symbol${info?.breakdown.ivaAmount.toStringAsFixed(2) ?? ''}',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Padding(
      padding: StoycoScreenSize.symmetric(context, horizontal: 23),
      child: Column(
        spacing: StoycoScreenSize.height(context, 24),
        children: <Widget>[
          SizedBox(height: StoycoScreenSize.height(context, 59)),
          /// Displays the payment summary preview card.
          SubscriptionPaymentPreviewCard(
            paymentSummaryInfo: notifier.paymentSummaryInfo,
          ),
          /// Displays the payment breakdown section.
          PaymentInformationSection(items: getPaymentInfoItems()),
          /// Displays the payment method selection section.
          const SelectPaymentMethodSection(),
        ],
      ),
    );
  }
}

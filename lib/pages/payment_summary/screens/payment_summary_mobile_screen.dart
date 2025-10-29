import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_payment_preview_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/payment_information_section.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/helpers/format_payment_info_items.dart';

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
    required this.isLoading,
    required this.paymentSummaryInfo,
    this.selectPaymentMethodSection = const SizedBox.shrink(),
  });

  /// The payment summary information.
  final PaymentSummaryInfoResponse paymentSummaryInfo;

  /// Whether the content is loading.
  final bool isLoading;

  final Widget selectPaymentMethodSection;

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
          /// Displays the payment summary preview card.
          SubscriptionPaymentPreviewCard(
            paymentSummaryInfo: paymentSummaryInfo,
          ),
          /// Displays the payment breakdown section.
          PaymentInformationSection(
            items: getPaymentInfoItems(paymentSummaryInfo),
          ),
          /// Displays the payment method selection section.
          selectPaymentMethodSection,
        ],
      ),
    );
  }
}

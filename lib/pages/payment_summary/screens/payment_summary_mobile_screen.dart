import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_payment_preview_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/payment_information_section.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/select_payment_method_section.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/notifier/payment_summary_notifier.dart';

/// {@template payment_summary_mobile_content}
/// Only the content of the payment summary, without Scaffold, AppBar or FAB.
/// Expects the notifier and loading state to be managed by the parent.
/// {@endtemplate}
class PaymentSummaryMobileScreen extends StatelessWidget {
  const PaymentSummaryMobileScreen({
    super.key,
    required this.notifier,
    required this.isLoading,
  });

  final PaymentSummaryNotifier notifier;
  final bool isLoading;

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
          SubscriptionPaymentPreviewCard(
            paymentSummaryInfo: notifier.paymentSummaryInfo,
          ),
          PaymentInformationSection(items: getPaymentInfoItems()),
          const SelectPaymentMethodSection(),
        ],
      ),
    );
  }
}

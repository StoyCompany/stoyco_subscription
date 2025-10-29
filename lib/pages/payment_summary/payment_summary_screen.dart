import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/screens/payment_summary_mobile_screen.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({
    super.key,
    required this.paymentSummaryInfo,
    this.isLoading = false,
    required this.selectPaymentMethodSection,
  });

  final PaymentSummaryInfoResponse paymentSummaryInfo;
  final bool isLoading;
  final Widget selectPaymentMethodSection;

  @override
  Widget build(BuildContext context) {
    if (!StoycoScreenSize.isPhone(context)) {
      return const Center(child: Text('En Desarrollo'));
    } else {
      return PaymentSummaryMobileScreen(
        isLoading: isLoading,
        paymentSummaryInfo: paymentSummaryInfo,
        selectPaymentMethodSection: selectPaymentMethodSection,
      );
    }
  }
}

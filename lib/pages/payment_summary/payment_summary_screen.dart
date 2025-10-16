import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/screens/payment_summary_mobile_screen.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({super.key, this.subscriptionId});

  final String? subscriptionId;

  @override
  Widget build(BuildContext context) {
    if (!StoycoScreenSize.isPhone(context)) {
      return const Center(child: Text('En Desarrollo'));
    } else {
      return PaymentSummaryMobileScreen(subscriptionId: subscriptionId);
    }
  }
}

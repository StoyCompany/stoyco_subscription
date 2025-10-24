import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/notifier/payment_summary_notifier.dart';
import 'package:stoyco_subscription/pages/payment_summary/screens/payment_summary_mobile_screen.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({
    super.key,
    required this.notifier,
    required this.isLoading,
  });

  final PaymentSummaryNotifier notifier;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!StoycoScreenSize.isPhone(context)) {
      return const Center(child: Text('En Desarrollo'));
    } else {
      return PaymentSummaryMobileScreen(
        notifier: notifier,
        isLoading: isLoading,
      );
    }
  }
}

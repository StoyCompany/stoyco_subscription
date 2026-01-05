import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/subscription_payment_preview_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/payment_information_section.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/helpers/format_payment_info_items.dart';

/// {@template payment_summary_web_screen}
/// Displays the content of the payment summary for desktop/web devices.
///
/// This widget does not include a [Scaffold], [AppBar], or floating action button.
/// It expects the [PaymentSummaryInfoResponse] and loading state to be managed by the parent.
///
/// The content includes:
///  - A preview card with the payment summary information.
///  - A section with payment breakdown details (plan and IVA).
///  - A section to select the payment method.
///
/// The layout is optimized for desktop screens with a centered, max-width container
/// and responsive spacing.
///
/// Example usage:
/// ```dart
/// PaymentSummaryWebScreen(
///   paymentSummaryInfo: myPaymentInfo,
///   isLoading: false,
///   selectPaymentMethodSection: MyPaymentMethodWidget(),
/// )
/// ```
///
/// {@endtemplate}
class PaymentSummaryWebScreen extends StatelessWidget {
  /// Creates a [PaymentSummaryWebScreen].
  ///
  /// [paymentSummaryInfo] provides the payment summary data.
  /// [isLoading] controls whether to show a loading indicator.
  /// [selectPaymentMethodSection] is the widget for payment method selection.
  const PaymentSummaryWebScreen({
    super.key,
    required this.isLoading,
    required this.paymentSummaryInfo,
    this.selectPaymentMethodSection = const SizedBox.shrink(),
  });

  /// The payment summary information.
  final PaymentSummaryInfoResponse paymentSummaryInfo;

  /// Whether the content is loading.
  final bool isLoading;

  /// The widget for selecting payment method.
  final Widget selectPaymentMethodSection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: StoycoScreenSize.width(
            context,
            800,
            desktop: 800,
            desktopLarge: 900,
          ),
        ),
        child: Padding(
          padding: StoycoScreenSize.symmetric(
            context,
            horizontal: 40,
            horizontalDesktop: 60,
            horizontalDesktopLarge: 80,
          ),
          child: Column(
            spacing: StoycoScreenSize.height(
              context,
              32,
              desktop: 32,
              desktopLarge: 40,
            ),
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
        ),
      ),
    );
  }
}
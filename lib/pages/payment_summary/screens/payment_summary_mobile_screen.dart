import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_payment_preview_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/payment_information_section.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_summary_info_model.dart';
import 'package:stoyco_subscription/pages/payment_summary/notifier/payment_summary_notifier.dart';

/// {@template payment_summary_mobile_screen}
/// A [PaymentSummaryMobileScreen] page (template with logic) for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a mobile-friendly payment summary page, including plan details, payment breakdown, selectable payment methods, and a total-to-pay action button. Integrates with a notifier for state management and loading states. Serves as a high-level template with business logic, composing multiple organisms, molecules, and atoms.
///
/// ### Atomic Level
/// **Page** – High-level layout structure with business logic, composed of templates, organisms, molecules, and atoms for payment summary and checkout flows.
///
/// ### Parameters
/// - `subscriptionId`: The optional subscription ID to load payment summary data for.
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a scaffolded mobile payment summary page with app bar, loading indicator, payment details, and action button.
///
/// ### Example
/// ```dart
/// const PaymentSummaryMobileScreen(
///   subscriptionId: 'sub_123',
/// )
/// ```
/// {@endtemplate}
class PaymentSummaryMobileScreen extends StatefulWidget {
  /// {@macro payment_summary_mobile_screen}
  const PaymentSummaryMobileScreen({
    super.key, 
    this.subscriptionId,
    this.onTapPaymentSubscriptionPlan,
    this.selectPaymentMethodSection,
  });

  /// The optional subscription ID to load payment summary data for.
  final String? subscriptionId;

  /// Callback for when the payment subscription plan is tapped.
  final VoidCallback? onTapPaymentSubscriptionPlan;

  final Widget? selectPaymentMethodSection;

  @override
  State<PaymentSummaryMobileScreen> createState() => _PaymentSummaryMobileScreenState();
}

class _PaymentSummaryMobileScreenState extends State<PaymentSummaryMobileScreen> {
  late PaymentSummaryNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = PaymentSummaryNotifier(subscriptionId: widget.subscriptionId);
    notifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    notifier.removeListener(_onNotifierChanged);
    notifier.dispose();
    super.dispose();
  }

  void _onNotifierChanged() {
    setState(() {});
  }

  String getTotalToPayText() {
    final PaymentSummaryInfoModel? info = notifier.paymentSummaryInfo;
    final String code = info?.currencyCode ?? 'MXN';
    final String symbol = info?.currencySymbol ?? r'$';
    final String total = info?.totalPrice.toStringAsFixed(2) ?? '';
    return 'Total a pagar $code $symbol$total';
  }

  List<Map<String, String>> getPaymentInfoItems() {
    final PaymentSummaryInfoModel? info = notifier.paymentSummaryInfo;
    final String code = info?.currencyCode ?? 'MXN';
    final String symbol = info?.currencySymbol ?? r'$';
    return <Map<String, String>>
    [
      <String, String>
      
      {
        'key': 'Plan',
        'value': '$code $symbol${info?.planPrice.toStringAsFixed(2) ?? '0.00'}',
      },
      <String, String>{
        'key': 'IVA',
        'value': '$code $symbol${info?.iva.toStringAsFixed(2) ?? ''}',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = notifier.isLoading;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: StoycoColors.deepCharcoal,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {Navigator.of(context).pop();},
            icon: StoycoAssets.lib.assets.icons.leftArrow.svg(
              height: StoycoScreenSize.height(context, 24),
              width: StoycoScreenSize.width(context, 24),
              package: 'stoyco_subscription',
            ),
          ),
          title: Center(
            child: Text(
              'Resumen de compra',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: StoycoScreenSize.fontSize(context, 16),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: StoycoAssets.lib.assets.icons.payment.bellIcon.svg(
                height: StoycoScreenSize.height(context, 24),
                width: StoycoScreenSize.width(context, 24),
                package: 'stoyco_subscription',
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ButtonGradientText(
          type: isLoading ? ButtonGradientTextType.inactive : ButtonGradientTextType.primary,
          paddingButton: StoycoScreenSize.fromLTRB(
            context,
            bottom: 5,
            right: 16,
            left: 16,
          ),
          text: getTotalToPayText(),
          onPressed: widget.onTapPaymentSubscriptionPlan,
        ), 
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Padding(
                padding: StoycoScreenSize.symmetric(context, horizontal: 23),
                child: Column(
                  spacing: StoycoScreenSize.height(context, 24),
                  children: <Widget>[
                    SizedBox(height: StoycoScreenSize.height(context, 59)),
                    SubscriptionPaymentPreviewCard(
                      paymentSummaryInfo: notifier.paymentSummaryInfo,
                    ),
                    PaymentInformationSection(
                      items: getPaymentInfoItems(),
                    ),
                    widget.selectPaymentMethodSection ?? const SizedBox.shrink(),
                  ],
                ),
              ),
      ),
    );
  }
}

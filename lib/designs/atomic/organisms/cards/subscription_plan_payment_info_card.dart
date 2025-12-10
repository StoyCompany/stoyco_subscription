import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/cards/card_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/currencies/currency_width_flag.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';

/// {@template subscription_plan_payment_info_card}
/// A [SubscriptionPlanPaymentInfoCard] organism for the Stoyco Subscription Atomic Design System.
/// Displays payment summary information for a subscription plan, including title, price, trial subtitle, and payment notes.
///
/// ### Atomic Level
/// **Organism** – Composed of molecules and atoms for complex layout and integration.
///
/// ### Parameters
/// - `paymentSummaryInfo`: The payment summary data model containing title, breakdown, trial subtitle, and payment notes.
///
/// ### Returns
/// Renders a card with payment summary details, including styled title, price, trial information, and payment notes.
///
/// ### Example
/// ```dart
/// SubscriptionPlanPaymentInfoCard(
///   paymentSummaryInfo: paymentSummaryInfo,
/// )
/// ```
/// {@endtemplate}


class SubscriptionPlanPaymentInfoCard extends StatelessWidget {

  const SubscriptionPlanPaymentInfoCard({
    super.key,
    required this.paymentSummaryInfo,
  });

  final PaymentSummaryInfoResponse paymentSummaryInfo;
  
  /// The payment summary data model containing title, breakdown, trial subtitle, and payment notes.

  @override
  Widget build(BuildContext context) {
    return CardGradient(
      child: Padding(
        padding: StoycoScreenSize.symmetric(context, horizontal: 24, vertical: 32),
        child: Column(
          spacing: StoycoScreenSize.height(context, 16),
          children: <Widget>[
            Text(
              paymentSummaryInfo.title,
              style: TextStyle(
                  fontFamily: FontFamilyToken.akkuratPro,
                  fontWeight: FontWeight.bold,
                  fontSize: StoycoScreenSize.fontSize(context, 28),
                  color: StoycoColors.softWhite,
              ),
              textAlign: TextAlign.center,
            ),
            CurrencyWidthFlag(
              currencyCode: paymentSummaryInfo.breakdown.currencyCode,
              price: paymentSummaryInfo.breakdown.planAmount,
              currencySymbol: paymentSummaryInfo.breakdown.currencySymbol,
              currencyFontSize: 16,
            ),
            Visibility(
              visible: paymentSummaryInfo.trialSubtitle.isNotEmpty,
              child: Text(
                paymentSummaryInfo.trialSubtitle,
                style: TextStyle(
                    fontFamily: FontFamilyToken.akkuratPro,
                    color: StoycoColors.softWhite,
                    fontWeight: FontWeight.w400,
                    fontSize: StoycoScreenSize.fontSize(context, 14),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
                '${paymentSummaryInfo.paymentStartNote}\n'
                '• Te enviaremos un correo de recordatorio 7 días antes del cobro.\n'
                '• Cancela cuando quieras, consulta los términos y condiciones.',
                style: TextStyle(
                    fontFamily: FontFamilyToken.akkuratPro,
                    color: StoycoColors.softWhite,
                    fontWeight: FontWeight.w400,
                    fontSize: StoycoScreenSize.fontSize(context, 12),
                )
              ),
          ],
        ),
      ),
    );
  }
}

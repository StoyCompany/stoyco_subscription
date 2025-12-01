import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/flags/currency_flag.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';

/// {@template subscription_payment_preview_card}
/// A card widget that displays a preview of the user's subscription payment details.
///
/// This widget shows the plan name, total price, currency, a short description,
/// and the start date of the subscription. It uses a glassmorphic effect for the background
/// and includes a currency flag icon for visual context.
///
/// If [paymentSummaryInfo] is null or any field is empty, those fields will be collapsed.
///
/// Example usage:
/// ```dart
/// SubscriptionPaymentPreviewCard(
///   paymentSummaryInfo: PaymentSummaryInfoModel(
///     planName: 'Premium Plan',
///     totalPrice: 199,
///     currencySymbol: '\$',
///     currencyCode: 'MXN',
///     shortDescription: 'Access to all premium features.',
///     startDate: '25 Oct 2025',
///   ),
/// )
/// ```
/// {@endtemplate}
class SubscriptionPaymentPreviewCard extends StatelessWidget {
  /// Creates a [SubscriptionPaymentPreviewCard].
  ///
  /// [paymentSummaryInfo] provides the data to display in the card.
  /// If null or fields are empty, those sections will be collapsed.
  const SubscriptionPaymentPreviewCard({super.key, this.paymentSummaryInfo});

  /// The model containing the payment summary information to display.
  final PaymentSummaryInfoResponse? paymentSummaryInfo;

  @override
  Widget build(BuildContext context) {
    final String? title = paymentSummaryInfo?.title;
    final String? trialSubtitle = paymentSummaryInfo?.trialSubtitle;
    final String? paymentStartNote = paymentSummaryInfo?.paymentStartNote;
    final bool hasTotalAmount =
        paymentSummaryInfo?.breakdown.totalAmount != null;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 30,
            color: Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ],
        // Background colors/Grey
        color: Color(0xFF202532),
      ),
      child: IntrinsicHeight(
        child: GlassmorphicContainer(
          width: double.infinity,
          height: double.infinity,
          blur: 8,
          border: 2,
          borderGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0x00FFFFFF), Color(0xFF4639E7)],
            stops: <double>[0, 1],
          ),
          borderRadius: StoycoScreenSize.radius(context, 24),
          linearGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF202532), Color(0xFF202532)],
            stops: <double>[0, 1],
          ),
          child: Container(
            padding: StoycoScreenSize.symmetric(
              context,
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: StoycoScreenSize.height(context, 4),
              children: <Widget>[
                // Title
                if (title?.isNotEmpty ?? false)
                  Text(
                    title!,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: StoycoColors.softWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: StoycoScreenSize.fontSize(context, 20),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // Price row
                if (hasTotalAmount)
                  Row(
                    spacing: StoycoScreenSize.width(context, 8),
                    children: <Widget>[
                      Text(
                        '${paymentSummaryInfo?.breakdown.currencySymbol ?? r'$'}${paymentSummaryInfo?.breakdown.totalAmount}',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: StoycoColors.softWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: StoycoScreenSize.fontSize(context, 24),
                          ),
                        ),
                      ),
                      Row(
                        spacing: StoycoScreenSize.width(context, 4),
                        children: <Widget>[
                          Text(
                            '${paymentSummaryInfo?.breakdown.currencyCode}',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: StoycoColors.iconDefault,
                                fontWeight: FontWeight.w700,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  16,
                                ),
                              ),
                            ),
                          ),
                          CurrencyFlag(
                            height: StoycoScreenSize.height(context, 16),
                            width: StoycoScreenSize.width(context, 24),
                            currencyCode:
                                paymentSummaryInfo?.breakdown.currencyCode ??
                                'MXN',
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),

                // Trial subtitle
                if (trialSubtitle?.isNotEmpty ?? false)
                  Text(
                    trialSubtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: StoycoColors.softWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: StoycoScreenSize.fontSize(context, 16),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // Payment start note
                if (paymentStartNote?.isNotEmpty ?? false)
                  Text(
                    paymentStartNote!,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: StoycoColors.softWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: StoycoScreenSize.fontSize(context, 14),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

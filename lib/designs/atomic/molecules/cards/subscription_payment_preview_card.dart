import 'package:flutter/widgets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/flags/currency_flag.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_summary_info_model.dart';

class SubscriptionPaymentPreviewCard extends StatelessWidget {
  const SubscriptionPaymentPreviewCard({super.key, this.paymentSummaryInfo});

  final PaymentSummaryInfoModel? paymentSummaryInfo;

  @override
  Widget build(BuildContext context) => Container(
    // box-shadow: 5px 5px 30px 0px #00000040;
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
    child: GlassmorphicContainer(
      width: double.infinity,
      height: StoycoScreenSize.height(context, 160),
      blur: 8,
      border: 2,
      borderGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0x00FFFFFF), Color(0xFF4639E7)],
        stops: [0, 1],
      ),
      borderRadius: 24,
      linearGradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF202532), Color(0xFF202532)],
        stops: [0, 1],
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
          children: [
            Text(
              paymentSummaryInfo?.planName ?? 'Plan Premium',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: StoycoColors.softWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: StoycoScreenSize.fontSize(context, 20),
                ),
              ),
            ),
            Row(
              spacing: StoycoScreenSize.width(context, 8),
              children: <Widget>[
                Text(
                  '${paymentSummaryInfo?.currencySymbol ?? r'$'}${paymentSummaryInfo?.totalPrice}',
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
                      '${paymentSummaryInfo?.currencyCode}',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: StoycoColors.iconDefault,
                          fontWeight: FontWeight.w700,
                          fontSize: StoycoScreenSize.fontSize(context, 16),
                        ),
                      ),
                    ),
                    CurrencyFlag(
                      height: StoycoScreenSize.height(context, 16),
                      width: StoycoScreenSize.width(context, 24),
                      currencyCode: paymentSummaryInfo?.currencyCode ?? 'MXN',
                    ),
                  ],
                ),
              ],
            ),
            Text(
              paymentSummaryInfo?.shortDescription ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: StoycoColors.softWhite,
                fontWeight: FontWeight.w700,
                fontSize: StoycoScreenSize.fontSize(context, 16),
              ),
              ),
            ),
            Text(
              'A partir del ${paymentSummaryInfo?.startDate ?? '25 oct 2025'}: ${paymentSummaryInfo?.totalPrice} ${paymentSummaryInfo?.currencySymbol ?? ''}/mes.',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: StoycoColors.softWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: StoycoScreenSize.fontSize(context, 14),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

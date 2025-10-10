import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/subscription_payment_preview_card.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/payment_information_section.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/sections/select_payment_method_section.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class PaymentSummaryMobileScreen extends StatelessWidget {
  const PaymentSummaryMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: StoycoColors.deepCharcoal,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: StoycoAssets.lib.assets.icons.leftArrow.svg(
              height: StoycoScreenSize.height(context, 24),
              width: StoycoScreenSize.width(context, 24),
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
              icon: StoycoAssets.lib.assets.icons.bellIcon.svg(
                height: StoycoScreenSize.height(context, 24),
                width: StoycoScreenSize.width(context, 24),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: StoycoScreenSize.height(context, 56),
          child: ButtonGradient(
            backgroundGradientColor: const LinearGradient(
              colors: <Color>[StoycoColors.darkBlue, StoycoColors.blue],
            ),
            borderRadius: 16,
            width: StoycoScreenSize.width(context, 330),
            child: Center(
              child: Text(
                r'Total a pagar $9.99',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: StoycoScreenSize.fontSize(context, 16),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: StoycoScreenSize.symmetric(context, horizontal: 23),
          child: Column(
            spacing: StoycoScreenSize.height(context, 24),
            children: <Widget>[
              SizedBox(height: StoycoScreenSize.height(context, 59)),
              const SubscriptionPaymentPreviewCard(),
              const PaymentInformationSection(
                items: [
                  {'key': 'Plan', 'value': r'MX $600'},
                  {'key': 'IVA', 'value': r'MX $10'},
                ],
              ),
              const SelectPaymentMethodSection(),
            ],
          ),
        ),
      ),
    );
  }
}

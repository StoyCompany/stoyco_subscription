import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class ExpiredSubscriptionModal extends StatelessWidget {
  const ExpiredSubscriptionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          StoycoScreenSize.radius(context, 24),
        ),
      ),
      color: StoycoColors.deepCharcoal,
      padding: StoycoScreenSize.symmetric(context, vertical: 8, horizontal: 16),
      child: Column(
        spacing: StoycoScreenSize.height(context, 16),
        children: <Widget>[
          StoycoAssets.lib.assets.icons.common.closeWindow.svg(
            package: 'stoyco_subscription',
          ),
          Text(
            'Tienes suscripciones vencidas',
            style: TextStyle(
              fontFamily: FontFamilyToken.akkuratPro,
              fontWeight: FontWeight.w700,
              fontSize: StoycoScreenSize.fontSize(context, 20),
              color: StoycoColors.text,
            ),
          ),
          Text(
            'No pudimos procesar el pago con tu tarjeta. Actualiza tus datos para seguir disfrutando de beneficios exclusivos.',
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: StoycoScreenSize.fontSize(context, 16),
                color: StoycoColors.text,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ButtonGradient(
            child: Padding(
              padding: StoycoScreenSize.symmetric(
                context,
                vertical: 12,
                horizontal: 24,
              ),
              child: Text(
                'Renovar',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: StoycoScreenSize.fontSize(context, 16),
                    color: StoycoColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Gap(StoycoScreenSize.height(context, 16)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/modals/dialog_container_v2.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class ExpiredSubscriptionModal extends StatelessWidget {
  const ExpiredSubscriptionModal({
    super.key,
    required this.onTapCloseButton,
    required this.onTapMainButton,
  });

  final VoidCallback onTapCloseButton;
  final VoidCallback onTapMainButton;

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      backgroundColor: StoycoColors.deepCharcoal,
      padding: StoycoScreenSize.symmetric(context, vertical: 8, horizontal: 16),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: StoycoScreenSize.height(context, 16),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: onTapCloseButton,
                  child: StoycoAssets.lib.assets.icons.closeWindow.svg(
                    package: 'stoyco_subscription',
                    height: StoycoScreenSize.height(context, 24),
                    width: StoycoScreenSize.width(context, 24),
                  ),
                ),
              ],
            ),
            Text(
              'Tienes suscripciones vencidas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamilyToken.akkuratPro,
                fontWeight: FontWeight.w700,
                fontSize: StoycoScreenSize.fontSize(context, 20),
                color: StoycoColors.text,
              ),
            ),
            Text(
              'No pudimos procesar el pago con tu tarjeta. Actualiza tus datos para seguir disfrutando de beneficios exclusivos.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: StoycoScreenSize.fontSize(context, 16),
                  color: StoycoColors.text,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ButtonGradient(
              onPressed: onTapMainButton,
              width: double.infinity,
              backgroundGradientColor: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[StoycoColors.darkBlue, StoycoColors.blue],
              ),
              borderRadius: StoycoScreenSize.radius(context, 16),
              child: Padding(
                padding: StoycoScreenSize.symmetric(
                  context,
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Text(
                  'Renovar ahora',
                  textAlign: TextAlign.center,
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
      ],
    );
  }
}

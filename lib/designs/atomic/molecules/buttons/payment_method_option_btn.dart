import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class PaymentMethodOptionBtn extends StatelessWidget {
  const PaymentMethodOptionBtn({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final Widget icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ButtonGradient(
      borderRadius: StoycoScreenSize.radius(context, 16),
      backgroundColor: StoycoColors.backgroundGrey,
      onPressed: onTap,
      child: Padding(
        padding: StoycoScreenSize.symmetric(context, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: StoycoScreenSize.width(context, 63)),
            icon,
            SizedBox(width: StoycoScreenSize.width(context, 8)),
            Text(
              textAlign: TextAlign.center,
              text,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: StoycoColors.text,
                  fontSize: StoycoScreenSize.fontSize(context, 16),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

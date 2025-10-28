import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// A button widget for selecting a payment method option.
///
/// Displays a gradient button with a customizable icon and label.
/// When pressed, triggers the [onTap] callback.
///
/// Typically used to present different payment method choices to the user.
///
/// Example usage:
/// ```dart
/// PaymentMethodOptionBtn(
///   icon: Icon(Icons.credit_card),
///   text: 'Credit Card',
///   onTap: () { /* handle tap */ },
/// )
/// ```
class PaymentMethodOptionBtn extends StatelessWidget {
  /// Creates a [PaymentMethodOptionBtn].
  ///
  /// [icon] is the widget displayed at the start of the button.
  /// [text] is the label shown next to the icon.
  /// [onTap] is called when the button is pressed.
  const PaymentMethodOptionBtn({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  /// The icon widget displayed in the button.
  final Widget icon;

  /// The label text displayed in the button.
  final String text;

  /// Callback when the button is pressed.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ButtonGradient(
      borderRadius: StoycoScreenSize.radius(context, 16),
      backgroundColor: StoycoColors.backgroundGrey,
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x2B344580),
          blurRadius: 30,
          offset: Offset(0, -20),
        ),
      ],
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

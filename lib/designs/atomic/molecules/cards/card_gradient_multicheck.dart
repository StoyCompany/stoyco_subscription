
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/checks/custom_checkbox_row.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template terms_privacy_auto_renew_card}
/// A [TermsPrivacyAutoRenewCard] molecule for the Stoyco Subscription Atomic Design System.
/// Renders a card with gradient background, rounded corners, and two checkboxes for terms and privacy acceptance.
///
/// ### Atomic Level
/// **Molecule** – Composed of checkboxes and card container.
///
/// ### Parameters
/// - `valueTerms`: Whether the terms checkbox is checked.
/// - `valuePrivacy`: Whether the privacy checkbox is checked.
/// - `onChangedTerms`: Callback when the terms checkbox is toggled.
/// - `onChangedPrivacy`: Callback when the privacy checkbox is toggled.
/// - `onTapTerms`: Callback to navigate to terms and conditions.
/// - `onTapPrivacy`: Callback to navigate to privacy policy.
///
/// ### Returns
/// Renders a gradient card with two checkboxes for terms and privacy, enabling navigation and validation for actions.
///
/// ### Example
/// ```dart
/// TermsPrivacyAutoRenewCard(
///   valueTerms: true,
///   valuePrivacy: false,
///   onChangedTerms: (v) {},
///   onChangedPrivacy: (v) {},
///   onTapTerms: () {},
///   onTapPrivacy: () {},
/// )
/// ```
/// {@endtemplate}

class TermsPrivacyAutoRenewCard extends StatelessWidget {
  /// Creates a [TermsPrivacyAutoRenewCard] molecule for the Stoyco Subscription Design System.
  ///
  /// - [valueTerms]: Whether the terms checkbox is checked.
  /// - [valuePrivacy]: Whether the privacy checkbox is checked.
  /// - [onChangedTerms]: Callback when the terms checkbox is toggled.
  /// - [onChangedPrivacy]: Callback when the privacy checkbox is toggled.
  /// - [onTapTerms]: Callback to navigate to terms and conditions.
  /// - [onTapPrivacy]: Callback to navigate to privacy policy.
  const TermsPrivacyAutoRenewCard({
    super.key,
    required this.valueTerms,
    required this.valuePrivacy,
    required this.onChangedTerms,
    required this.onChangedPrivacy,
    required this.onTapTerms,
    required this.onTapPrivacy,
  });

  /// Whether the terms checkbox is checked.
  final bool valueTerms;
  /// Whether the privacy checkbox is checked.
  final bool valuePrivacy;

  /// Callback when the terms checkbox is toggled.
  final ValueChanged<bool?> onChangedTerms;
  /// Callback when the privacy checkbox is toggled.
  final ValueChanged<bool?> onChangedPrivacy;

  /// Callback to navigate to terms and conditions.
  final VoidCallback onTapTerms;
  /// Callback to navigate to privacy policy.
  final VoidCallback onTapPrivacy;


  @override
  Widget build(BuildContext context) {

    final TextStyle labelTextStyle = TextStyle(
        fontFamily: FontFamilyToken.akkuratPro,
        color: StoycoColors.text,
        fontSize: StoycoScreenSize.fontSize(context, 14),
        fontWeight: FontWeight.w500,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StoycoScreenSize.radius(context, 16)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: <double>[0.0751, 0.5643, 0.6543],
          colors: <Color>[
            Color.fromRGBO(255, 255, 255, 0.25),
            Color.fromRGBO(0, 0, 0, 0.25),
            Color.fromRGBO(0, 0, 0, 0.25),
          ],
        ),
      ),
      padding: StoycoScreenSize.all(context, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomCheckboxRow(
            value: valueTerms,
            onChanged: onChangedTerms,
            labelWidget: RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Acepto ',
                    style: labelTextStyle,
                  ),
                  TextSpan(
                    text: 'Términos y condiciones de acceso y uso.*',
                    style: labelTextStyle.copyWith(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            onTapLabel: onTapTerms,
          ),
          Gap(StoycoScreenSize.height(context, 16)),
          CustomCheckboxRow(
            value: valuePrivacy,
            onChanged: onChangedPrivacy,
            labelWidget: RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Acepto ',
                    style: labelTextStyle,
                  ),
                  TextSpan(
                    text: 'Políticas de privacidad.*',
                    style: labelTextStyle.copyWith(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            onTapLabel: onTapPrivacy,
          ),
        ],
      ),
    );
  }
}

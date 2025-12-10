import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/modals/dialog_container_v2.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template expired_subscription_modal}
/// Modal dialog displayed when a user has expired subscriptions.
///
/// Shows a notification about payment processing failures and prompts
/// the user to update their payment information to renew their subscription.
///
/// **Features:**
/// - Displays warning message about expired subscriptions
/// - Explains payment processing failure
/// - Provides action button to renew subscription
/// - Includes close button for dismissal
/// - Responsive design that adapts to screen size
///
/// **Usage:**
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ExpiredSubscriptionModal(
///     onTapCloseButton: () => Navigator.pop(context),
///     onTapMainButton: () {
///       Navigator.pop(context);
///       Navigator.push(
///         context,
///         MaterialPageRoute(
///           builder: (_) => PaymentUpdateScreen(),
///         ),
///       );
///     },
///   ),
/// );
/// ```
/// {@endtemplate}
class ExpiredSubscriptionModal extends StatelessWidget {
  /// {@macro expired_subscription_modal}
  const ExpiredSubscriptionModal({
    super.key,
    required this.onTapCloseButton,
    required this.onTapMainButton,
  });

  /// Callback invoked when the close button (X) is tapped.
  ///
  /// Typically used to dismiss the modal without taking action.
  ///
  /// **Example:**
  /// ```dart
  /// onTapCloseButton: () => Navigator.pop(context),
  /// ```
  final VoidCallback onTapCloseButton;

  /// Callback invoked when the "Renovar ahora" (Renew now) button is tapped.
  ///
  /// Should navigate the user to the payment update or renewal flow.
  ///
  /// **Example:**
  /// ```dart
  /// onTapMainButton: () {
  ///   Navigator.pop(context);
  ///   navigateToPaymentUpdate();
  /// },
  /// ```
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
            // Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: onTapCloseButton,
                  child: StoycoAssets.lib.assets.icons.common.closeWindow.svg(
                    package: 'stoyco_subscription',
                    height: StoycoScreenSize.height(context, 24),
                    width: StoycoScreenSize.width(context, 24),
                  ),
                ),
              ],
            ),
            // Title
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
            // Description
            Text(
              'No pudimos procesar el pago con tu tarjeta. Actualiza tus datos para seguir disfrutando de beneficios exclusivos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: FontFamilyToken.akkuratPro,
                  fontSize: StoycoScreenSize.fontSize(context, 16),
                  color: StoycoColors.text,
                  fontWeight: FontWeight.w400,
              ),
            ),
            // Renew button
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
                  style: TextStyle(
                      fontFamily: FontFamilyToken.akkuratPro,
                      fontSize: StoycoScreenSize.fontSize(context, 16),
                      color: StoycoColors.text,
                      fontWeight: FontWeight.w700,
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

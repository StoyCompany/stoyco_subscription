import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template modal_base_subscription}
/// A modal dialog [ModalBaseSubscription] atom for the Stoyco Subscription Design System.
/// Displays a styled modal with icon, title, description, and a primary action button for success, error, or custom states.
///
/// ### Atomic Level
/// **Atom** – Smallest UI unit.
///
/// ### Parameters
/// - `title`: The main title displayed in the modal.
/// - `titleStyle`: Custom style for the title text.
/// - `description`: Optional description text below the title.
/// - `descriptionStyle`: Custom style for the description text.
/// - `nameOnTapNavigate`: Custom label for the action button (used in custom type).
/// - `onTapNavigate`: Callback executed when the action button is pressed.
/// - `type`: Modal type (success, error, custom).
/// - `icon`: Custom icon widget (used in custom type).
/// - `spacing`: Vertical spacing between modal elements (default: 32).
///
/// ### Returns
/// Renders a modal dialog with icon, title, description, and a gradient action button, suitable for atomic feedback and navigation.
///
/// ### Example
/// ```dart
/// ModalBaseSubscription(
///   title: 'Subscription Successful',
///   description: 'Your subscription is now active.',
///   onTapNavigate: () {},
///   type: ModalBaseSubscriptionType.success,
/// )
/// ```
/// {@endtemplate}

enum ModalBaseSubscriptionType {
  success,
  error,
  custom,
}

/// {@macro modal_base_subscription}
class ModalBaseSubscription extends StatelessWidget {
  const ModalBaseSubscription({
    super.key,
    required this.title,
    this.description,
    this.nameOnTapNavigate,
    required this.onTapNavigate,
    this.type = ModalBaseSubscriptionType.success,
    this.icon,
    this.titleStyle,
    this.descriptionStyle,
    this.spacing = 32,
    this.canPop = true,
  });

  /// The main title displayed in the modal.
  final String title;
  /// Custom style for the title text.
  final TextStyle? titleStyle;
  /// Optional description text below the title.
  final String? description;
  /// Custom style for the description text.
  final TextStyle? descriptionStyle;
  /// Custom label for the action button (used in custom type).
  final String? nameOnTapNavigate;
  /// Callback executed when the action button is pressed.
  final VoidCallback onTapNavigate;
  /// Custom icon widget (used in custom type).
  final Widget? icon;
  /// Modal type (success, error, custom).
  final ModalBaseSubscriptionType type;
  /// Vertical spacing between modal elements. Defaults to 32.
  final double spacing;
  /// Determines if the modal can be dismissed by popping the navigation stack.
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final Widget icon;
    final String buttonText;

    switch (type) {
      case ModalBaseSubscriptionType.success:
        icon = StoycoAssets.lib.assets.icons.plan.tagSubscription.svg(
          package: 'stoyco_subscription',
          width: StoycoScreenSize.height(context, 60),
          height: StoycoScreenSize.height(context, 65),
        );
        buttonText = 'Continuar';
      case ModalBaseSubscriptionType.error:
        icon = StoycoAssets.lib.assets.icons.plan.creditCardValidation.svg(
          package: 'stoyco_subscription',
          width: StoycoScreenSize.height(context, 72),
          height: StoycoScreenSize.height(context, 72),
        );
        buttonText = 'Volver';
      case ModalBaseSubscriptionType.custom:
        icon = this.icon ?? Icon( Icons.info, size: StoycoScreenSize.height(context, 48));
        buttonText = nameOnTapNavigate ?? 'Continuar';
    }

    return PopScope(
      canPop: canPop,
      child: Padding(
        padding: StoycoScreenSize.symmetric(
            context,
            horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: StoycoScreenSize.height(context, spacing),
          children: <Widget>[
            icon,
            Text(
              title,
              style: titleStyle ?? GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: StoycoScreenSize.fontSize(context, 26),
                  color: StoycoColors.softWhite,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null)
              Text(
                description!,
                style: descriptionStyle ?? GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                    fontSize: StoycoScreenSize.fontSize(context, 16),
                    color: StoycoColors.softWhite,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ButtonGradientText(
              type: ButtonGradientTextType.primary,
              text: buttonText,
              onPressed: onTapNavigate,
            ),
          ],
        ),
      ),
    );
  }
}

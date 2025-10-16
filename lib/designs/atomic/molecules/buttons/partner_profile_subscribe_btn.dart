import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

/// {@template partner_profile_subscribe_btn}
/// A button widget for subscribing to a partner's plan or viewing the active subscription.
///
/// Displays a gradient button with dynamic content:
/// - If [isLoading] is true, shows a skeleton loader.
/// - If the user has an active plan ([hasActivePlan]), shows an alert icon and "View my subscription".
/// - Otherwise, shows the lowest subscription price and a call to action to subscribe.
///
/// The button is disabled if required subscription data is missing.
/// {@endtemplate}
class PartnerProfileSubscribeBtn extends StatelessWidget {
  /// Creates a [PartnerProfileSubscribeBtn].
  ///
  /// [lowestSubscriptionValue], [lowestSubscriptionCurrency], and [lowestSubscriptionCurrencySymbol]
  /// are used to display the minimum subscription price.
  ///
  /// [hasActivePlan] determines if the button shows "View my subscription" or the subscribe CTA.
  ///
  /// [onTap] is called when the button is pressed.
  ///
  /// [isLoading] shows a skeleton loader instead of the button when true.
  const PartnerProfileSubscribeBtn({
    super.key,
    this.lowestSubscriptionValue,
    this.lowestSubscriptionCurrency,
    this.lowestSubscriptionCurrencySymbol,
    this.hasActivePlan,
    this.onTap,
    this.isLoading = false,
  });

  /// The lowest subscription value to display.
  final double? lowestSubscriptionValue;

  /// The currency code for the lowest subscription value.
  final String? lowestSubscriptionCurrency;

  /// The currency symbol for the lowest subscription value.
  final String? lowestSubscriptionCurrencySymbol;

  /// Whether the user currently has an active subscription plan.
  final bool? hasActivePlan;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Callback when the button is pressed.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: StoycoScreenSize.symmetric(context, horizontal: 15),
        child: SkeletonCard(
          width: double.infinity,
          height: StoycoScreenSize.height(context, 70),
          borderRadius: BorderRadius.circular(
            StoycoScreenSize.radius(context, 24),
          ),
        ),
      );
    }

    final bool isEmpty =
        lowestSubscriptionValue == null ||
        lowestSubscriptionCurrency == null ||
        lowestSubscriptionCurrency!.isEmpty ||
        lowestSubscriptionCurrencySymbol == null ||
        lowestSubscriptionCurrencySymbol!.isEmpty;

    if (isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: StoycoScreenSize.symmetric(context, horizontal: 15),
      child: ButtonGradient(
        onPressed: () => onTap?.call(),
        backgroundColor: StoycoColors.backgroundGrey,
        height: StoycoScreenSize.height(context, 70),
        borderRadius: StoycoScreenSize.radius(context, 24),
        child: Padding(
          padding: StoycoScreenSize.symmetric(
            context,
            vertical: 11,
            horizontal: 28,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: StoycoScreenSize.width(context, 15),
            children: <Widget>[
              Row(
                spacing: StoycoScreenSize.width(context, 4),
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  (hasActivePlan ?? false)
                      ? StoycoAssets.lib.assets.icons.alertIcon.svg()
                      : StoycoAssets.lib.assets.icons.subsciptionButtonIcon
                            .svg(),
                  SizedBox(width: StoycoScreenSize.width(context, 10)),
                  (hasActivePlan ?? false)
                      ? Text(
                          'Ver mi suscripción',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: FontFamilyToken.akkuratPro,
                            fontSize: StoycoScreenSize.fontSize(context, 14),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: StoycoScreenSize.height(context, 4),
                          children: <Widget>[
                            Text(
                              '¡Suscríbete desde ${lowestSubscriptionCurrencySymbol ?? ''} ${lowestSubscriptionValue ?? 0} ${lowestSubscriptionCurrency ?? ''}!',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: FontFamilyToken.akkuratPro,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  14,
                                ),
                              ),
                            ),
                            Text(
                              'Disfruta de contenido exclusivo.',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: FontFamilyToken.akkuratPro,
                                fontSize: StoycoScreenSize.fontSize(
                                  context,
                                  12,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              StoycoAssets.lib.assets.icons.doubleRightArrow.svg(),
            ],
          ),
        ),
      ),
    );
  }
}

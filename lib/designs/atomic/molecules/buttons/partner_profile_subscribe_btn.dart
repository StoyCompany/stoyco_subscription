import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/buttons/button_gradient.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';

class PartnerProfileSubscribeBtn extends StatelessWidget {
  const PartnerProfileSubscribeBtn({
    super.key,
    this.lowestSubscriptionValue,
    this.lowestSubscriptionCurrency,
    this.lowestSubscriptionCurrencySymbol,
    this.hasActivePlan,
    this.onTap,
    this.isLoading = false,
  });

  final double? lowestSubscriptionValue;
  final String? lowestSubscriptionCurrency;
  final String? lowestSubscriptionCurrencySymbol;
  final bool? hasActivePlan;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: StoycoScreenSize.symmetric(context, horizontal: 15),
        child: SkeletonCard(
          width: double.infinity,
          height: StoycoScreenSize.height(context, 70),
          borderRadius: BorderRadius.circular(24),
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
        borderRadius: 24,
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
                      ? StoycoAssets.lib.assets.icons.subsciptionButtonIcon
                            .svg()
                      : StoycoAssets.lib.assets.icons.alertIcon.svg(),
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

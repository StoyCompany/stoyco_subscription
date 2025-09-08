import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/flags/currency_flag.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_corner.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/tags/tag_gradient_icon.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/buttons/button_gradient_text.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/card_image_description_tag.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/dropdowns/html_dropdown.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_plans/models/subscription_plan.dart';

class CardSubscriptionPlan extends StatelessWidget {
  const CardSubscriptionPlan({
    super.key, 
    required this.plan,
    this.titleFontSize = 28,
    this.priceFontSize = 38,
    this.currencyFontSize = 16,
    this.onTapRenewSubscription,
    this.onTapCancelSubscription,
    this.onTapFreeTrial,
  });

  final SubscriptionPlan plan;
  final double titleFontSize;
  final double priceFontSize;
  final double currencyFontSize;
  final void Function(SubscriptionPlan)? onTapRenewSubscription;
  final void Function(SubscriptionPlan)? onTapCancelSubscription;
  final void Function(SubscriptionPlan)? onTapFreeTrial;

  @override
  Widget build(BuildContext context) {
    return CardImageDescriptionTag(
      key: ValueKey<String>('cardImageDescriptionTag_${plan.id}'),
      imageUrl: plan.imageUrl,
      tag: plan.subscribed 
        ? TagCorner(key: ValueKey<String>('tagCorner_${plan.id}'), title: 'Actual') 
        : plan.recommended 
          ? TagGradientIcon(key: ValueKey<String>('tagGradient_${plan.id}'), title: 'Recomendado') 
            : null,
      description: Column(
        children: <Widget>[
          Text(
            plan.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: StoycoScreenSize.fontSize(context, titleFontSize),
              fontFamily: 'Montserrat',
              color: StoycoColors.softWhite,
            ),
          ),
          Gap(StoycoScreenSize.width(context, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '\$${plan.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: StoycoScreenSize.fontSize(context, priceFontSize),
                  fontFamily: 'Montserrat',
                  color: StoycoColors.softWhite,
                ),
              ),
              Gap(StoycoScreenSize.width(context, 5)),
              Text(
                plan.currencyCode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    currencyFontSize,
                  ),
                  fontFamily: 'Montserrat',
                  color: StoycoColors.iconDefault,
                ),
              ),
              Gap(StoycoScreenSize.width(context, 1)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CurrencyFlag(
                  key: ValueKey<String>('currencyFlag_${plan.id}'),
                  currencyCode: plan.currencyCode,
                ),
              ),
            ],
          ),
          HtmlDropdown(
            key: ValueKey<String>('htmlDropdown_${plan.id}'),
            title: 'Beneficios',
            htmlContent: plan.description,
          ),
          if (plan.subscribed) ...<Widget>[
            Gap(StoycoScreenSize.height(context, 32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'packages/stoyco_subscription/lib/assets/icons/exclamacion.svg',
                ),
                Gap(StoycoScreenSize.width(context, 8)),
                Text(
                  'Tu suscripción actual  vence ${plan.expiresAt}',
                  style: TextStyle(
                    fontSize: StoycoScreenSize.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: StoycoColors.softWhite,
                  ),
                ),
              ],
            ),
            Gap(StoycoScreenSize.height(context, 32)),
            ButtonGradientText(
              type: ButtonGradientTextType.primary,
              text: 'Renovar',
              onPressed: () {
                if (onTapRenewSubscription != null) {
                  onTapRenewSubscription!(plan);
                }
              },
            ),
            Gap(StoycoScreenSize.height(context, 16)),
            ButtonGradientText(
              type: ButtonGradientTextType.primary,
              text: 'Cancelar suscripción',
              onPressed: () {
                if (onTapCancelSubscription != null) {
                  onTapCancelSubscription!(plan);
                }
              },
            )
          ] else ...<Widget>[
            ButtonGradientText(
              type: ButtonGradientTextType.primary,
              text: 'Probar gratis durante 1 mes',
              onPressed: () {
                if (onTapFreeTrial != null) {
                  onTapFreeTrial!(plan);
                }
              },
            ),
            Gap(StoycoScreenSize.height(context, 16)),
            Text(
              plan.messageDiscount,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: StoycoScreenSize.fontSize(context, 14),
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: StoycoColors.softWhite,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

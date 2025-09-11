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
import 'package:stoyco_subscription/designs/utils/formatter_dates.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';
import 'package:stoyco_subscription/pages/subscription_plans/presentation/helpers/models/card_subscription_plan_params.dart';

class CardSubscriptionPlan extends StatelessWidget {
  /// Card widget for displaying a subscription plan with customizable styles and actions.
  ///
  /// This widget is part of the Stoyco atomic design system and is used to visually represent a subscription plan, including price, currency, and various design tokens.
  ///
  /// The widget supports custom styles and exposes callbacks for subscription actions.
  ///
  /// Example usage:
  /// ```dart
  /// CardSubscriptionPlan(
  ///   plan: myPlan,
  ///   onTapRenewSubscription: (plan) => ...,
  ///   onTapCancelSubscription: (plan) => ...,
  ///   onTapFreeTrial: (plan) => ...,
  ///   styleParams: SubscriptionPlanScreenStyleParams(
  ///     titleFontSize: 28,
  ///     ... other style overrides
  ///   )
  /// ```
  ///
  /// Parameters:
  /// - [plan]: Subscription plan model.
  /// - [onTapRenewSubscription]: Callback when renew subscription is tapped.
  /// - [onTapCancelSubscription]: Callback when cancel subscription is tapped.
  /// - [onTapFreeTrial]: Callback when free trial is tapped.
  /// - [styleParams]: Style parameters for customizing appearance.
  
  const CardSubscriptionPlan({
    super.key,
    required this.plan,
    required this.onTapRenewSubscription,
    required this.onTapCancelSubscription,
    required this.onTapFreeTrial,
    required this.styleParams,
  });

  final SubscriptionPlan plan;
  final SubscriptionPlanScreenStyleParams styleParams;
  final void Function(SubscriptionPlan) onTapRenewSubscription;
  final void Function(SubscriptionPlan) onTapCancelSubscription;
  final void Function(SubscriptionPlan) onTapFreeTrial;

  

  @override
  Widget build(BuildContext context) {
    return CardImageDescriptionTag(
      key: ValueKey<String>('cardImageDescriptionTag_${plan.id}'),
      imageUrl: plan.imageUrl,
      tag: plan.subscribed 
        ? TagCorner(
            key: ValueKey<String>('tagCorner_${plan.id}'), 
            title: 'Actual',
            height: styleParams.tagCornerHeight,
            width: styleParams.tagCornerWidth,
            cutSize: styleParams.tagCornerCutSize,
            gradientColorsBorder: styleParams.tagCornerGradientColorsBorder,
            color: styleParams.tagCornerColor,
            cornerRadius: styleParams.tagCornerRadius,
            paddingText: styleParams.tagCornerPaddingText,
            textStyle: styleParams.tagCornerTextStyle,
          ) 
        : plan.recommended 
          ? TagGradientIcon(
              key: ValueKey<String>('tagGradient_${plan.id}'), 
              title: 'Recomendado',
              height: styleParams.tagGradientHeight,
              width: styleParams.tagGradientWidth,
              borderRadius: styleParams.tagGradientBorderRadius,
              gradient: styleParams.tagGradientGradient,
              margin: styleParams.tagGradientMargin,
              padding: styleParams.tagGradientPadding,
              titleStyle: styleParams.titleStyleTagGradient,
            ) : null,
      description: Column(
        children: <Widget>[
          Text(
            plan.name,
            style: styleParams.planNameTextStyle ?? TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: StoycoScreenSize.fontSize(context, styleParams.titleFontSize),
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
                style: styleParams.planPriceTextStyle ?? TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: StoycoScreenSize.fontSize(context, styleParams.priceFontSize),
                  fontFamily: 'Montserrat',
                  color: StoycoColors.softWhite,
                ),
              ),
              Gap(StoycoScreenSize.width(context, 5)),
              Text(
                plan.currencyCode,
                style: styleParams.planCurrencyTextStyle ?? TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    styleParams.currencyFontSize,
                  ),
                  fontFamily: 'Montserrat',
                  color: StoycoColors.iconDefault,
                ),
              ),
              Gap(StoycoScreenSize.width(context, 1)),
              Padding(
                padding: StoycoScreenSize.fromLTRB(context, left: 8),
                child: CurrencyFlag(
                  key: ValueKey<String>('currencyFlag_${plan.id}'),
                  height: styleParams.currencyFlagHeight,
                  width: styleParams.currencyFlagWidth,
                  currencyCode: plan.currencyCode,
                ),
              ),
            ],
          ),
          HtmlDropdown(
            key: ValueKey<String>('htmlDropdown_${plan.id}'),
            title: 'Beneficios',
            contentPadding: styleParams.htmlDropdownContentPadding,
            selectorPadding: styleParams.htmlDropdownSelectorPadding,
            titleTextStyle: styleParams.htmlDropdownTitleTextStyle,
            htmlContent: plan.description,
          ),
          if (plan.subscribed) ...<Widget>[
            Padding(
              padding: styleParams.messageInformationPadding ?? StoycoScreenSize.fromLTRB(
                context, 
                right: 16, 
                left: 16, 
                top: 20,
                bottom: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'packages/stoyco_subscription/lib/assets/icons/exclamacion.svg',
                    width: styleParams.exclamationIconWidth,
                    height: styleParams.exclamationIconHeight,
                  ),
                  Gap(StoycoScreenSize.width(context, 8)),
                  Expanded(
                    child: Text(
                      'Tu suscripción actual vence el ${formatDateDMY(plan.expiresAt)}',
                      style: styleParams.messageInformationTextStyle ?? TextStyle(
                        fontSize: StoycoScreenSize.fontSize(context, 16),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: StoycoColors.softWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            ButtonGradientText(
              type: ButtonGradientTextType.primary,
              paddingButton: styleParams.onTapRenewSubscriptionPadding ?? StoycoScreenSize.fromLTRB(
                context, 
                bottom: 16, 
                right: 16, 
                left: 16,
              ),
              text: 'Renovar',
              onPressed: () => onTapRenewSubscription(plan),
            ),
            ButtonGradientText(
              type: ButtonGradientTextType.secondary,
              paddingButton: styleParams.onTapCancelSubscriptionPadding ?? StoycoScreenSize.fromLTRB(
                context, 
                bottom: 5, 
                right: 16, 
                left: 16,
              ),
              text: 'Cancelar suscripción',
              onPressed: () => onTapCancelSubscription(plan),
            )
          ] else ...<Widget>[
            ButtonGradientText(
              type: ButtonGradientTextType.primary,
              paddingButton: styleParams.onTapFreeTrialPadding ?? StoycoScreenSize.fromLTRB(
                context, 
                top: 20, 
                bottom: 16, 
                right: 16, 
                left: 16,
              ),
              text: 'Probar gratis durante 1 mes',
              onPressed: () => onTapFreeTrial(plan)
            ),
            Gap(StoycoScreenSize.height(context, 16)),
            Text(
              plan.messageDiscount,
              textAlign: TextAlign.center,
              style: styleParams.planMessageDiscountTextStyle ?? TextStyle(
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

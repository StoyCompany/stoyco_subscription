import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/flags/currency_flag.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/cards/card_image_description_tag.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/dropdowns/html_dropdown.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/designs/utils/formatter_currency.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';
import 'package:stoyco_subscription/pages/subscription_plans/presentation/helpers/models/card_subscription_plan_params.dart';


/// {@template subscription_plan_card}
/// A highly customizable subscription plan card organism for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays detailed information about a subscription plan, including name, price, currency, benefits, and status. Provides actions for renewing, canceling, or subscribing to a plan, with visual cues for active and recommended plans.
///
/// ### Atomic Level
/// **Organism** – Complex UI component composed of atoms and molecules.
///
/// ### Parameters
/// - `plan`: The subscription plan model to display.
/// - `styleParams`: Style parameters for customizing the appearance of the card.
/// - `onTapRenewSubscription`: Callback when the renew subscription action is tapped.
/// - `onTapCancelSubscription`: Callback when the cancel subscription action is tapped.
/// - `onTapNewSubscription`: Callback when the new subscription or free trial action is tapped.
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a visually rich card with plan details, status tags, benefit dropdown, and action buttons, adapting its layout and content based on the plan's state.
///
/// ### Example
/// ```dart
/// SubscriptionPlanCard(
///   plan: myPlan,
///   styleParams: myStyleParams,
///   onTapRenewSubscription: (plan) => print('Renew: \\${plan.name}'),
///   onTapCancelSubscription: (plan) => print('Cancel: \\${plan.name}'),
///   onTapNewSubscription: (plan) => print('Subscribe: \\${plan.name}'),
/// )
/// ```
/// {@endtemplate}
class SubscriptionPlanCancelCard extends StatelessWidget {

  /// {@macro subscription_plan_card}
  const SubscriptionPlanCancelCard({
    super.key,
    required this.plan,
    this.styleParams = const SubscriptionPlanScreenStyleParams(),
  });

  /// The subscription plan model to display.
  final SubscriptionPlan plan;

  /// Style parameters for customizing the appearance of the card.
  final SubscriptionPlanScreenStyleParams styleParams;

  @override
  Widget build(BuildContext context) {
    return CardImageDescriptionTag(
      key: ValueKey<String>('cardImageDescriptionTagCancel_${plan.id}'),
      imageUrl: plan.imageUrl,
      marginCard: EdgeInsets.zero,
      paddingCard: EdgeInsets.zero,
      description: Column(
        children: <Widget>[
          Padding(
              padding: StoycoScreenSize.symmetric(context, horizontal: 16),
              child: Text(
                plan.name,
                style: styleParams.planNameTextStyle ?? GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StoycoScreenSize.fontSize(context, styleParams.titleFontSize),
                    color: StoycoColors.softWhite,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Gap(StoycoScreenSize.width(context, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${plan.currencySymbol}${formatPrice(plan.price)}',
                style: styleParams.planPriceTextStyle ?? GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StoycoScreenSize.fontSize(context, styleParams.priceFontSize),
                    color: StoycoColors.softWhite,
                  ),
                ),
              ),
              Gap(StoycoScreenSize.width(context, 5)),
              Text(
                plan.currencyCode,
                style: styleParams.planCurrencyTextStyle ?? GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: StoycoScreenSize.fontSize(
                        context,
                        styleParams.currencyFontSize,
                      ),
                      color: StoycoColors.iconDefault,
                    ),
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
        ],
      ),
    );
  }
}

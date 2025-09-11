import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tap_menu_items/tab_menu_item.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/card_subcription_plan.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/presentation/helpers/models/card_subscription_plan_params.dart';

class SubscriptionPlansList extends StatefulWidget {
    /// Displays a list of subscription plans for a given partner and user.
    ///
    /// This widget is part of the Stoyco atomic design system and provides a customizable UI for displaying monthly and annual subscription plans.
    ///
    /// The widget supports custom styles via [styleParams], and exposes callbacks for subscription actions.
    ///
    /// Example usage:
    /// ```dart
    /// SubscriptionPlansList(
    ///   idPartner: 'partnerId',
    ///   idUser: 'userId',
    ///   crossAxisCount: 2,
    ///   onTapCancelSubscription: (plan) => ...,
    ///   onTapFreeTrial: (plan) => ...,
    ///   onTapRenewSubscription: (plan) => ...,
    ///   styleParams: SubscriptionPlanScreenStyleParams(
    ///     titleStyle: TextStyle(...),
    ///       ...other style overrides
    ///   ),
    /// )
    /// ```
    ///
    /// Parameters:
    /// - [idPartner]: Partner/artist identifier.
    /// - [idUser]: User identifier.
    /// - [crossAxisCount]: Number of columns in the grid (default: 1).
    /// - [onTapCancelSubscription]: Callback when cancel subscription is tapped.
    /// - [onTapFreeTrial]: Callback when free trial is tapped.
    /// - [onTapRenewSubscription]: Callback when renew subscription is tapped.
    /// - [styleParams]: Optional style parameters for customizing appearance.
    const SubscriptionPlansList({
      super.key,
      required this.subscriptionPlanResponse,
      this.isLoading = false,
      this.crossAxisCount = 1,
      required this.onTapCancelSubscription,
      required this.onTapFreeTrial,
      required this.onTapRenewSubscription,
      this.styleParams = const SubscriptionPlanScreenStyleParams(),
    });

  /// Response containing lists of subscription plans.
  final SubscriptionPlanResponse subscriptionPlanResponse;

  final bool isLoading;

  /// Number of columns in the grid.
  final int crossAxisCount;

  /// Callback when cancel subscription is tapped.
  final void Function(SubscriptionPlan plan) onTapCancelSubscription;

  /// Callback when free trial is tapped.
  final void Function(SubscriptionPlan plan) onTapFreeTrial;

  /// Callback when renew subscription is tapped.
  final void Function(SubscriptionPlan plan) onTapRenewSubscription;

  /// Optional style parameters for customizing the appearance and design tokens.
  ///
  /// For custom design, use the [SubscriptionPlanScreenStyleParams] model.
  /// See [SubscriptionPlanScreenStyleParams] for all available custom parameters.
  final SubscriptionPlanScreenStyleParams styleParams;


  @override
  State<SubscriptionPlansList> createState() => _SubscriptionPlansListState();
}

class _SubscriptionPlansListState extends State<SubscriptionPlansList> {
  /// Whether monthly plans are currently shown.
  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SvgPicture.asset(
            'packages/stoyco_subscription/lib/assets/icons/tag_subscription.svg',
            width: widget.styleParams.tagSubscriptionWidth,
            height: widget.styleParams.tagSubscriptionHeight,
          ),
          Gap(StoycoScreenSize.height(context, 16)),
          Text(
            widget.subscriptionPlanResponse.partnerName,
            textAlign: TextAlign.center,
            style: widget.styleParams.titleStyle ?? TextStyle(
              color: StoycoColors.grayText,
              fontSize: StoycoScreenSize.fontSize(context, 24),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(StoycoScreenSize.height(context, 16)),
          Expanded(
            child: widget.isLoading
              //TODO: Replace with actual loading indicator
              ? ListView.builder(
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) => const SkeletonCard(
                    height: 180,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                )
              : TabMenuItem(
                  tabs: const <String>['Mensual', 'Anual'],
                  textDescription: 'Elige el plan que mejor se adapte a ti.',
                  isLoading: widget.isLoading,
                  textDescriptionStyle: widget.styleParams.textDescriptionStyle,
                  onTabChanged: (String value) {
                    setState(() {
                      isMonthly = value == 'Mensual';
                    });
                  },
                  initialNavIndex: isMonthly ? 0 : 1,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Wrap(
                        key: const ValueKey<String>('monthly_plans_wrap'),
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.subscriptionPlanResponse.monthlyPlans.map((SubscriptionPlan plan) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / widget.crossAxisCount,
                            child: CardSubscriptionPlan(
                              key: ValueKey<String>(plan.id),
                              plan: plan,
                              onTapCancelSubscription: widget.onTapCancelSubscription,
                              onTapFreeTrial: widget.onTapFreeTrial,
                              onTapRenewSubscription: widget.onTapRenewSubscription,
                              styleParams: widget.styleParams,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Wrap(
                        key: const ValueKey<String>('annual_plans_wrap'),
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.subscriptionPlanResponse.annualPlans.map((SubscriptionPlan plan) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / widget.crossAxisCount,
                            child: CardSubscriptionPlan(
                              key: ValueKey<String>(plan.id),
                              plan: plan,
                              onTapCancelSubscription: widget.onTapCancelSubscription,
                              onTapFreeTrial: widget.onTapFreeTrial,
                              onTapRenewSubscription: widget.onTapRenewSubscription,
                              styleParams: widget.styleParams,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

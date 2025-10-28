import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tap_menu_items/tab_menu_item.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/card_subcription_plan.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/presentation/helpers/models/card_subscription_plan_params.dart';

/// {@template subscription_plans_list}
/// A [SubscriptionPlansList] page (template with logic) for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Displays a responsive list of subscription plans, including monthly and annual options, with loading skeletons, tab navigation, and customizable style parameters. Integrates callbacks for subscription actions and adapts layout for phone and desktop.
///
/// ### Atomic Level
/// **Page** – High-level layout structure with business logic, composed of templates, organisms, molecules, and atoms for subscription plan selection flows.
///
/// ### Parameters
/// - `subscriptionPlanResponse`: Response containing lists of subscription plans.
/// - `isLoading`: Whether the screen is in a loading state. Defaults to false.
/// - `crossAxisCount`: Number of columns in the grid. Defaults to 1.
/// - `onTapCancelSubscription`: Callback when cancel subscription is tapped.
/// - `onTapNewSubscription`: Callback when free trial is tapped.
/// - `onTapRenewSubscription`: Callback when renew subscription is tapped.
/// - `styleParams`: Optional style parameters for customizing the appearance and design tokens.
/// - `key`: Optional widget key.
///
/// ### Returns
/// Renders a responsive subscription plans page with tab navigation, loading skeletons, and plan cards, suitable for atomic design systems.
///
/// ### Example
/// ```dart
/// SubscriptionPlansList(
///   subscriptionPlanResponse: myPlans,
///   onTapCancelSubscription: (plan) {},
///   onTapNewSubscription: (plan) {},
///   onTapRenewSubscription: (plan) {},
/// )
/// ```
/// {@endtemplate}
class SubscriptionPlansList extends StatefulWidget {
    /// {@macro subscription_plans_list}
    const SubscriptionPlansList({
      super.key,
      required this.subscriptionPlanResponse,
      this.isLoading = false,
      this.crossAxisCount = 1,
      required this.onTapCancelSubscription,
      required this.onTapNewSubscription,
      required this.onTapRenewSubscription,
      this.styleParams = const SubscriptionPlanScreenStyleParams(),
    });

  /// Response containing lists of subscription plans.
  final SubscriptionPlanResponse subscriptionPlanResponse;

  /// Whether the screen is in a loading state. Defaults to false.
  final bool isLoading;

  /// Number of columns in the grid. Defaults to 1.
  final int crossAxisCount;

  /// Callback when cancel subscription is tapped.
  final void Function(SubscriptionPlan plan) onTapCancelSubscription;

  /// Callback when free trial is tapped.
  final void Function(SubscriptionPlan plan) onTapNewSubscription;

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

  /// Returns true if there are monthly plans available.
  bool get hasMonthlyPlans => widget.subscriptionPlanResponse.monthlyPlans.isNotEmpty;
  /// Returns true if there are annual plans available.
  bool get hasAnnualPlans => widget.subscriptionPlanResponse.annualPlans.isNotEmpty;
  /// Returns true if there are no plans and not loading.
  bool get hasNoPlans => !hasMonthlyPlans && !hasAnnualPlans && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (StoycoScreenSize.isPhone(context)) ...<Widget>[
              StoycoAssets.lib.assets.icons.plan.tagSubscription.svg(
                width: widget.styleParams.tagSubscriptionWidth,
                height: widget.styleParams.tagSubscriptionHeight,
                package: 'stoyco_subscription',
              ),
              Gap(StoycoScreenSize.height(context, 16)),
              Text(
                hasNoPlans
                  ? 'No hay planes disponibles'
                  : widget.subscriptionPlanResponse.partnerName,
                textAlign: TextAlign.center,
                style: widget.styleParams.titleStyle ?? GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: StoycoColors.grayText,
                    fontSize: StoycoScreenSize.fontSize(context, 24),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Gap(StoycoScreenSize.height(context, 16)),
            ] else ...<Widget>[
              StoycoAssets.lib.assets.icons.plan.tagSubscriptionSlim.svg(
                width: widget.styleParams.tagSubscriptionWidth,
                height: widget.styleParams.tagSubscriptionHeight,
                package: 'stoyco_subscription',
              ),
              Gap(StoycoScreenSize.height(context, 12)),
              Text(
                'Suscripciones',
                textAlign: TextAlign.center,
                style: widget.styleParams.titleStyle ?? TextStyle(
                  color: StoycoColors.grayText,
                  fontSize: StoycoScreenSize.fontSize(context, 20),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Akkurat_Pro',
                ),
              ),
              Gap(StoycoScreenSize.height(context, 30)),
              Text(
                hasNoPlans
                  ? 'No hay planes disponibles'
                  : 'Elige el plan de ${widget.subscriptionPlanResponse.partnerName} que mejor se adapte a ti.',
                textAlign: TextAlign.center,
                style: widget.styleParams.titleStyle ?? TextStyle(
                  color: StoycoColors.grayText,
                  fontSize: StoycoScreenSize.fontSize(context, 25),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Akkurat_Pro',
                ),
              ),
              Gap(StoycoScreenSize.height(context, 30)),
            ],
            Expanded(
              child: widget.isLoading
                ? SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final double totalSpacing = (widget.crossAxisCount - 1) * 10;
                        final double cardWidth = (constraints.maxWidth - totalSpacing) / widget.crossAxisCount;
                        return Wrap(
                          key: const ValueKey<String>('monthly_plans_wrap'),
                          spacing: StoycoScreenSize.width(context, 8),
                          runSpacing: StoycoScreenSize.height(context, 8),
                          alignment: WrapAlignment.center,
                          children: List<Widget>.generate(3, (int index) {
                            return SizedBox(
                              width: cardWidth,
                              child: SkeletonCard(
                                height: cardWidth,
                                width: cardWidth,
                                margin: StoycoScreenSize.symmetric(
                                  context, 
                                  horizontal: 16, 
                                  horizontalPhone: 40,
                                  vertical: 12,
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    )
                  )
                : Visibility(
                  visible: hasMonthlyPlans || hasAnnualPlans,
                  replacement: const SizedBox.shrink(),
                  child: TabMenuItem(
                      tabs: hasMonthlyPlans && hasAnnualPlans
                        ? const <String>['Mensual', 'Anual']
                        : hasMonthlyPlans
                          ? const <String>['Mensual']
                          : hasAnnualPlans
                            ? const <String>['Anual']
                            : const <String>[],
                      textDescription: StoycoScreenSize.isPhone(context) ? 'Elige el plan que mejor se adapte a ti.' : null,
                      isLoading: widget.isLoading,
                      textDescriptionStyle: widget.styleParams.textDescriptionStyle,
                      onTabChanged: (String value) {
                        setState(() {
                          isMonthly = value == 'Mensual';
                        });
                      },
                      initialNavIndex: isMonthly ? 0 : 1,
                      children: <Widget>[
                        if (hasMonthlyPlans)
                          SingleChildScrollView(
                            child: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                final double totalSpacing = (widget.crossAxisCount - 1) * 10;
                                final double cardWidth = (constraints.maxWidth - totalSpacing) / widget.crossAxisCount;
                                final List<SubscriptionPlan> plans = widget.subscriptionPlanResponse.monthlyPlans;
                                return Wrap(
                                  key: const ValueKey<String>('monthly_plans_wrap'),
                                  spacing: StoycoScreenSize.width(context, 8),
                                  runSpacing: StoycoScreenSize.height(context, 8),
                                  alignment: WrapAlignment.center,
                                  children: plans.map((SubscriptionPlan plan) {
                                    return SizedBox(
                                      width: cardWidth,
                                      child: CardSubscriptionPlan(
                                        key: ValueKey<String>(plan.id),
                                        plan: plan,
                                        onTapCancelSubscription: widget.onTapCancelSubscription,
                                        onTapNewSubscription: widget.onTapNewSubscription,
                                        onTapRenewSubscription: widget.onTapRenewSubscription,
                                        styleParams: widget.styleParams,
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            )
                          ),
                        if (hasAnnualPlans)
                        SingleChildScrollView(
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              final double totalSpacing = (widget.crossAxisCount - 1) * 10;
                              final double cardWidth = (constraints.maxWidth - totalSpacing) / widget.crossAxisCount;
                              final List<SubscriptionPlan> plans = widget.subscriptionPlanResponse.annualPlans;
                              return Wrap(
                                key: const ValueKey<String>('annual_plans_wrap'),
                                spacing: StoycoScreenSize.width(context, 8),
                                runSpacing: StoycoScreenSize.height(context, 8),
                                alignment: WrapAlignment.center,
                                children: plans.map((SubscriptionPlan plan) {
                                  return SizedBox(
                                    width: cardWidth,
                                    child: CardSubscriptionPlan(
                                      key: ValueKey<String>(plan.id),
                                      plan: plan,
                                      onTapCancelSubscription: widget.onTapCancelSubscription,
                                      onTapNewSubscription: widget.onTapNewSubscription,
                                      onTapRenewSubscription: widget.onTapRenewSubscription,
                                      styleParams: widget.styleParams,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          )
                        ),
                      ],
                    ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

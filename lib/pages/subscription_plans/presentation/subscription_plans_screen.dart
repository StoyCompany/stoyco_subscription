import 'package:flutter/material.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tab_bar/tab_bar_custom.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/subscription_plan_card.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/assets.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/fonts.gen.dart';
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
///   onValidatePlatformAccess: (plan) {},
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
    required this.onValidatePlatformAccess,
    this.styleParams = const SubscriptionPlanScreenStyleParams(),
    this.onPlanTypeChanged,
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

  /// Callback when validating platform access.
  final void Function(SubscriptionPlan plan) onValidatePlatformAccess;

  /// Optional style parameters for customizing the appearance and design tokens.
  ///
  /// For custom design, use the [SubscriptionPlanScreenStyleParams] model.
  /// See [SubscriptionPlanScreenStyleParams] for all available custom parameters.
  final SubscriptionPlanScreenStyleParams styleParams;

  final void Function(bool isMonthly)? onPlanTypeChanged;

  @override
  State<SubscriptionPlansList> createState() => _SubscriptionPlansListState();
}

class _SubscriptionPlansListState extends State<SubscriptionPlansList> {
  /// Whether monthly plans are currently shown.
  bool isMonthly = true;

  @override
  void initState() {
    super.initState();
    if (widget.subscriptionPlanResponse.monthlyPlans.isNotEmpty) {
      isMonthly = true;
    } else if (widget.subscriptionPlanResponse.annualPlans.isNotEmpty) {
      isMonthly = false;
    }
  }

  /// Returns true if there are monthly plans available.
  bool get hasMonthlyPlans =>
      widget.subscriptionPlanResponse.monthlyPlans.isNotEmpty;

  /// Returns true if there are annual plans available.
  bool get hasAnnualPlans =>
      widget.subscriptionPlanResponse.annualPlans.isNotEmpty;

  /// Returns true if there are no plans and not loading.
  bool get hasNoPlans =>
      !hasMonthlyPlans && !hasAnnualPlans && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isPhone = StoycoScreenSize.isPhone(context);

    return Scaffold(
      backgroundColor: StoycoColors.midnightInk,
      body: SafeArea(
        child: Padding(
          padding: isPhone
              ? EdgeInsets.zero
              : StoycoScreenSize.fromLTRB(context, left: 24, right: 40),
          child: CustomScrollView(
            slivers: <Widget>[
              _buildIconHeader(context, isPhone),
              _buildTitle(context, isPhone),
              if (!isPhone) _buildDescription(context),
              _buildTabBar(context, isPhone),
              _buildPlansContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconHeader(BuildContext context, bool isPhone) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: StoycoScreenSize.height(context, isPhone ? 0 : 24),
          bottom: StoycoScreenSize.height(context, isPhone ? 14 : 12),
        ),
        child: Center(
          child: isPhone
              ? StoycoAssets.lib.assets.icons.plan.tagSubscription.svg(
                  width: widget.styleParams.tagSubscriptionWidth,
                  height: widget.styleParams.tagSubscriptionHeight,
                  package: 'stoyco_subscription',
                )
              : StoycoAssets.lib.assets.icons.plan.tagSubscriptionSlim.svg(
                  width: widget.styleParams.tagSubscriptionWidth,
                  height: widget.styleParams.tagSubscriptionHeight,
                  package: 'stoyco_subscription',
                ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isPhone) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: StoycoScreenSize.fromLTRB(
            context,
            left: 24,
            right: 24,
            bottom: isPhone ? 4 : 16,
          ),
          child: Text(
            isPhone
                ? (hasNoPlans
                      ? 'No hay planes disponibles'
                      : widget.subscriptionPlanResponse.partnerName)
                : 'Suscripciones',
            textAlign: TextAlign.center,
            style:
                widget.styleParams.titleStyle ??
                TextStyle(
                  color: StoycoColors.grayText,
                  fontSize: StoycoScreenSize.fontSize(
                    context,
                    isPhone ? 24 : 20,
                  ),
                  fontWeight: FontWeight.w700,
                  fontFamily: FontFamilyToken.akkuratPro,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: StoycoScreenSize.height(context, 16)),
        child: Center(
          child: Padding(
            padding: StoycoScreenSize.symmetric(context, horizontal: 24),
            child: Text(
              hasNoPlans
                  ? 'No hay planes disponibles'
                  : 'Elige el plan de ${widget.subscriptionPlanResponse.partnerName} que mejor se adapte a ti.',
              textAlign: TextAlign.center,
              style:
                  widget.styleParams.titleStyle ??
                  TextStyle(
                    color: StoycoColors.grayText,
                    fontSize: StoycoScreenSize.fontSize(context, 25),
                    fontWeight: FontWeight.w700,
                    fontFamily: FontFamilyToken.akkuratPro,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isPhone) {
    if (!hasMonthlyPlans && !hasAnnualPlans) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final double barHeight = isPhone
        ? StoycoScreenSize.height(context, 90)
        : StoycoScreenSize.height(context, 80);

    return SliverAppBar(
      backgroundColor: StoycoColors.midnightInk,
      surfaceTintColor: StoycoColors.midnightInk,
      toolbarHeight: barHeight,
      pinned: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: StoycoScreenSize.symmetric(context, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool hasBothPlans = hasMonthlyPlans && hasAnnualPlans;

                  // Calculate responsive width
                  final double maxTabBarWidth = isPhone
                      ? constraints.maxWidth
                      : StoycoScreenSize.width(context, 800);

                  final double tabBarWidth =
                      constraints.maxWidth < maxTabBarWidth
                      ? constraints.maxWidth
                      : maxTabBarWidth;

                  return CustomTabBar(
                    width: tabBarWidth,
                    tabs: hasBothPlans
                        ? const <String>['Mensual', 'Anual']
                        : hasMonthlyPlans
                        ? const <String>['Mensual']
                        : const <String>['Anual'],
                    initialNavIndex: _getTabInitialIndex(),
                    isLoading: widget.isLoading,
                    onTabChanged: (int index) {
                      setState(() {
                        isMonthly = hasMonthlyPlans && hasAnnualPlans
                            ? index == 0
                            : hasMonthlyPlans;
                      });
                      widget.onPlanTypeChanged?.call(isMonthly);
                    },
                  );
                },
              ),
            ),
            if (isPhone && !widget.isLoading) ...<Widget>[
              SizedBox(height: StoycoScreenSize.height(context, 15)),
              Padding(
                padding: StoycoScreenSize.symmetric(context, horizontal: 8),
                child: Text(
                  'Elige el plan que mejor se adapte a ti.',
                  textAlign: TextAlign.left,
                  style:
                      widget.styleParams.textDescriptionStyle ??
                      TextStyle(
                        fontSize: StoycoScreenSize.fontSize(context, 16),
                        fontFamily: FontFamilyToken.akkuratPro,
                        fontWeight: FontWeight.bold,
                        color: StoycoColors.iconDefault,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlansContent(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingContent(context);
    }

    if (!hasMonthlyPlans && !hasAnnualPlans) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final List<SubscriptionPlan> plans;
    if (hasMonthlyPlans && hasAnnualPlans) {
      plans = isMonthly
          ? widget.subscriptionPlanResponse.monthlyPlans
          : widget.subscriptionPlanResponse.annualPlans;
    } else if (hasMonthlyPlans) {
      plans = widget.subscriptionPlanResponse.monthlyPlans;
    } else {
      plans = widget.subscriptionPlanResponse.annualPlans;
    }

    return _buildPlansGrid(context, plans);
  }

  Widget _buildLoadingContent(BuildContext context) {
    final bool isPhone = StoycoScreenSize.isPhone(context);

    return SliverToBoxAdapter(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isPhone
                ? double.infinity
                : StoycoScreenSize.width(context, 800),
          ),
          child: Padding(
            padding: StoycoScreenSize.symmetric(
              context,
              horizontal: isPhone ? 0 : 40,
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double totalSpacing = (widget.crossAxisCount - 1) * 10;
                final double cardWidth =
                    (constraints.maxWidth - totalSpacing) /
                    widget.crossAxisCount;
                return Wrap(
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlansGrid(BuildContext context, List<SubscriptionPlan> plans) {
    final bool isPhone = StoycoScreenSize.isPhone(context);

    return SliverToBoxAdapter(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isPhone
                ? double.infinity
                : StoycoScreenSize.width(context, 800),
          ),
          child: Padding(
            padding: StoycoScreenSize.symmetric(
              context,
              horizontal: isPhone ? 0 : 40,
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double totalSpacing = (widget.crossAxisCount - 1) * 10;
                final double cardWidth =
                    (constraints.maxWidth - totalSpacing) /
                    widget.crossAxisCount;
                return Wrap(
                  spacing: StoycoScreenSize.width(context, 8),
                  runSpacing: StoycoScreenSize.height(context, 8),
                  alignment: WrapAlignment.center,
                  children: plans.map((SubscriptionPlan plan) {
                    return SizedBox(
                      width: cardWidth,
                      child: SubscriptionPlanCard(
                        key: ValueKey<String>(plan.id),
                        plan: plan,
                        onTapCancelSubscription: widget.onTapCancelSubscription,
                        onTapNewSubscription: widget.onTapNewSubscription,
                        onTapRenewSubscription: widget.onTapRenewSubscription,
                        onValidatePlatformAccess: widget.onValidatePlatformAccess,
                        styleParams: widget.styleParams,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  int _getTabInitialIndex() {
    if (hasMonthlyPlans && hasAnnualPlans) {
      return isMonthly ? 0 : 1;
    }
    return 0;
  }
}

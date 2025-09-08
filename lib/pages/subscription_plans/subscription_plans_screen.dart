import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_subscription/designs/atomic/atoms/skeletons/skeleton_card.dart';
import 'package:stoyco_subscription/designs/atomic/molecules/tap_menu_items/tab_menu_item.dart';
import 'package:stoyco_subscription/designs/atomic/organisms/cards/card_subcription_plan.dart';
import 'package:stoyco_subscription/designs/atomic/tokens/src/gen/colors.gen.dart';
import 'package:stoyco_subscription/designs/responsive/screen_size.dart';
import 'package:stoyco_subscription/pages/subscription_plans/models/subscription_plan.dart';
import 'package:stoyco_subscription/pages/subscription_plans/models/subscription_plan_parent.dart';

class SubscriptionPlansList extends StatefulWidget {
  const SubscriptionPlansList({
    super.key, 
    required this.idPartner, 
    this.crossAxisCount = 1,
  });

  final String idPartner;
  final int crossAxisCount;

  @override
  State<SubscriptionPlansList> createState() => _SubscriptionPlansListState();
}

class _SubscriptionPlansListState extends State<SubscriptionPlansList> {
  bool isMonthly = true;
  bool isLoading = true;
  List<SubscriptionPlan> monthlyPlans = <SubscriptionPlan>[];
  List<SubscriptionPlan> annualPlans = <SubscriptionPlan>[];
  String title = '';

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => isLoading = true);
    final String jsonStr = await rootBundle.loadString(
      'assets/mocks/subscription_plan_by_user.json',
    );
    final SubscriptionPlanParent parent = SubscriptionPlanParent.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
    setState(() {
      title = parent.artistName;
      monthlyPlans = parent.monthlyPlans;
      annualPlans = parent.annualPlans;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SvgPicture.asset(
            'packages/stoyco_subscription/lib/assets/icons/tag_subscription.svg',
          ),
          Gap(StoycoScreenSize.height(context, 16)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: StoycoColors.grayText,
              fontSize: StoycoScreenSize.fontSize(context, 24),
              fontFamily: 'Akkurat_Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) => const SkeletonCard(
                      height: 180,
                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  )
                : TabMenuItem(
                    tabs: const <String>['Mensual', 'Anual'],
                    textDescription: 'Elige el plan que mejor se adapte a ti.',
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
                          children: monthlyPlans.map((SubscriptionPlan plan) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / widget.crossAxisCount - 16,
                              child: CardSubscriptionPlan(
                                key: ValueKey<String>(plan.id),
                                plan: plan,
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
                          children: annualPlans.map((SubscriptionPlan plan) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / widget.crossAxisCount - 16,
                              child: CardSubscriptionPlan(
                                key: ValueKey<String>(plan.id),
                                plan: plan,
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

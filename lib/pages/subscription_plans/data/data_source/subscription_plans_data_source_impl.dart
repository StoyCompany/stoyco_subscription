

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/domain/data_source/subscription_plans_data_source.dart';

class SubscriptionPlansDataSourceImpl implements SubscriptionPlansDataSource {

  SubscriptionPlansDataSourceImpl(this._environment);

  final StoycoEnvironment _environment;

  @override
  Future<SubscriptionPlanResponse> getSubscriptionPlans(GetSubscriptionPlansRequest request) async {

    final String jsonStr = await rootBundle.loadString(
      'assets/mocks/subscription_plan_by_user.json',
    );
    
    return SubscriptionPlanResponse.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
  }
}

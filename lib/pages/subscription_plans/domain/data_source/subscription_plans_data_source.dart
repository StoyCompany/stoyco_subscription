
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';

abstract class SubscriptionPlansDataSource {
  Future<SubscriptionPlanResponse> getSubscriptionPlans(GetSubscriptionPlansRequest request);
}

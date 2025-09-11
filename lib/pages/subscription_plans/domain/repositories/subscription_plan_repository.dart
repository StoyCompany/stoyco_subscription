
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/failure.dart';

abstract class SubscriptionPlanRepository {
  Future<Either<Failure, SubscriptionPlanResponse>> getSubscriptionPlans(GetSubscriptionPlansRequest request);
}

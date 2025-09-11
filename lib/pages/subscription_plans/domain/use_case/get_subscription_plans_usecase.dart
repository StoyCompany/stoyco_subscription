
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/domain/repositories/subscription_plan_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/use_case.dart';

class GetSubscriptionPlansUseCase extends UseCase<SubscriptionPlanResponse, GetSubscriptionPlansRequest> {
  GetSubscriptionPlansUseCase({required this.repository});

  final SubscriptionPlanRepository repository;

  @override
  Future<Either<Failure, SubscriptionPlanResponse>> call(GetSubscriptionPlansRequest requests) {
    return repository.getSubscriptionPlans(requests);
  }
}

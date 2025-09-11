
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/domain/data_source/subscription_plans_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/domain/repositories/subscription_plan_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/failure.dart';

class SubscriptionPlanRepositoryImpl implements SubscriptionPlanRepository {
  SubscriptionPlanRepositoryImpl({
    required SubscriptionPlansDataSource remoteDataSource,
  }) : _subscriptionPlansDataSource = remoteDataSource;

  final SubscriptionPlansDataSource _subscriptionPlansDataSource;
  
  @override
  Future<Either<Failure, SubscriptionPlanResponse>> getSubscriptionPlans(GetSubscriptionPlansRequest request) async {
    try {
      final SubscriptionPlanResponse subscriptionPlan = await _subscriptionPlansDataSource.getSubscriptionPlans(request);
      return Right<Failure, SubscriptionPlanResponse>(subscriptionPlan);
    } on Failure catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(error);
    } on Error catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(ExceptionFailure.decode(error));
    }
  }
}

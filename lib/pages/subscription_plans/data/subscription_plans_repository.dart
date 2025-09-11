
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/get_subscription_plans_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_data_source.dart';

class SubscriptionPlansRepository{

  SubscriptionPlansRepository(this._dataSource, this.userToken);

   /// The data source used by the repository.
  final SubscriptionPlansDataSource _dataSource;

  /// The user's authentication token.
  late String userToken;

  /// Updates the user token and propagates it to the data source.
  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
  }


  Future<Either<Failure, SubscriptionPlanResponse>> getSubscriptionPlans(GetSubscriptionPlansRequest request) async {
    try {
      final Response<Map<String, dynamic>> response = await _dataSource.getSubscriptionPlans(request);

      if (response.statusCode == 200 && response.data != null) {
        return Right<Failure, SubscriptionPlanResponse>(SubscriptionPlanResponse.fromJson(response.data!));
      } else {
        return Left<Failure, SubscriptionPlanResponse>(
          ExceptionFailure.decode(
            Exception('Error fetching subscription plans'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, SubscriptionPlanResponse>(ExceptionFailure.decode(error));
    }
  }
}

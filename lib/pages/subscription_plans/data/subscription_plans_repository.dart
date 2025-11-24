import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart' as local_error;
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart' as local_exception;
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart' as local_failure;
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscribe_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_method_modification_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/request/subscription_modification_request.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan_response.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/subscription_plans_data_source.dart';

class SubscriptionPlansRepository with RepositoryCacheMixin {
  SubscriptionPlansRepository(this._dataSource, this.userToken);

  /// The data source used by the repository.
  final SubscriptionPlansDataSource _dataSource;

  /// The user's authentication token.
  late String userToken;

  /// Updates the user token and propagates it to the data source.
  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
    // Clear cache when token changes (user might have logged in/out)
    clearAllCache();
  }

  /// Fetches subscription plans based on the provided request.
  ///
  /// Returns an [Either] with [Failure] on error or [SubscriptionPlanResponse] on success.
  /// Results are cached for 5 minutes.
  Future<Either<local_failure.Failure, SubscriptionPlanResponse>> getSubscriptionPlans(String partnerId) async {
    try {
      final Response<Map<String, dynamic>> response = await _dataSource.getSubscriptionPlans(partnerId);

      if (response.statusCode == 200 && response.data != null) {
        return Right<local_failure.Failure, SubscriptionPlanResponse>(
          SubscriptionPlanResponse.fromJson(response.data!),
        );
      } else {
        return Left<local_failure.Failure, SubscriptionPlanResponse>(
          local_exception.ExceptionFailure.decode(
            Exception('Error fetching subscription plans'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left<local_failure.Failure, SubscriptionPlanResponse>(
        local_exception.DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<local_failure.Failure, SubscriptionPlanResponse>(
        local_error.ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<local_failure.Failure, SubscriptionPlanResponse>(
        local_exception.ExceptionFailure.decode(error),
      );
    }
  }

  Future<Either<Failure, bool>> subscribeToPlan(SubscribeRequest request) async {
    try {
      final Response<String> response = await _dataSource.subscribeToPlan(request);
      if (response.statusCode == 200) {
        return const Right<Failure, bool>(true);
      } else {
        return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error subscribing to plan')));
      }
    } on DioException catch (error) {
      return Left<Failure, bool>(DioFailure.decode(error));
    } on Error catch (error) {
      return Left<Failure, bool>(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left<Failure, bool>(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> unsubscribe(SubscriptionModificationRequest request) async {
      try {
        final Response<String> response = await _dataSource.unsubscribe(request);
        if (response.statusCode == 200) {
          return const Right<Failure, bool>(true);
        } else {
          return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error unsubscribing plan')));
        }
      } on DioException catch (error) {
        return Left<Failure, bool>(DioFailure.decode(error));
      } on Error catch (error) {
        return Left<Failure, bool>(ErrorFailure.decode(error));
      } on Exception catch (error) {
        return Left<Failure, bool>(ExceptionFailure.decode(error));
      }
    }

    Future<Either<Failure, bool>> renewSubscription(SubscriptionModificationRequest request) async {
      try {
        final Response<String> response = await _dataSource.renewSubscription(request);
        if (response.statusCode == 200) {
          return const Right<Failure, bool>(true);
        } else {
          return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error renewing subscription')));
        }
      } on DioException catch (error) {
        return Left<Failure, bool>(DioFailure.decode(error));
      } on Error catch (error) {
        return Left<Failure, bool>(ErrorFailure.decode(error));
      } on Exception catch (error) {
        return Left<Failure, bool>(ExceptionFailure.decode(error));
      }
    }

    Future<Either<Failure, bool>> updateSubscriptionPaymentMethod(SubscriptionMethodModificationRequest request) async {
      try {
        final Response<String> response = await _dataSource.updateSubscriptionPaymentMethod(request);
        if (response.statusCode == 200) {
          return const Right<Failure, bool>(true);
        } else {
          return Left<Failure, bool>(ExceptionFailure.decode(Exception('Error updating payment method')));
        }
      } on DioException catch (error) {
        return Left<Failure, bool>(DioFailure.decode(error));
      } on Error catch (error) {
        return Left<Failure, bool>(ErrorFailure.decode(error));
      } on Exception catch (error) {
        return Left<Failure, bool>(ExceptionFailure.decode(error));
      }
    }
}

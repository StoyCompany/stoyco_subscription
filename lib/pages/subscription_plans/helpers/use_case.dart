import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/subscription_plans/helpers/error/failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}

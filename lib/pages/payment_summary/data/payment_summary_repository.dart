import 'package:either_dart/either.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_data_source.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// Repository class for partner profile-related operations.
///
/// This repository acts as an abstraction layer between the data source and the service,
/// providing methods to fetch partner subscription data and manage the user's authentication token.
class PaymentSummaryRepository {
  /// Creates a [PartnerProfileRepository] with the given [PartnerProfileDataSource] and [userToken].
  PaymentSummaryRepository(this._dataSource, this.userToken);

  /// The data source used for network operations.
  final PaymentSummaryDataSource _dataSource;

  /// The user's authentication token.
  late String userToken;

  /// Updates the stored authentication token and propagates it to the data source.
  void updateToken(String token) {
    userToken = token;
    _dataSource.updateToken(token);
  }

  /// Fetches payment summary information for a specific plan and recurrence type.
  ///
  /// Returns a [PaymentSummaryInfoResponse] with the payment details.
  /// Results are cached for 5 minutes as payment info is relatively stable.
  Future<Either<Failure, PaymentSummaryInfoResponse>> getPaymentSummaryByPlan({
    required String planId,
    required String recurrenceType,
  }) async {
    try {
      final PaymentSummaryInfoResponse data = await _dataSource.getPaymentSummaryByPlan(
        planId: planId,
        recurrenceType: recurrenceType,
      );
      return Right<Failure, PaymentSummaryInfoResponse>(data);
    } catch (e) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        ExceptionFailure.decode(e is Exception ? e : Exception(e.toString())),
      );
    }
  }
}

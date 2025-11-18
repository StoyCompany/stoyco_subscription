import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:stoyco_subscription/pages/partner_profile/data/partner_profile_data_source.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_data_source.dart';

/// Repository class for partner profile-related operations.
///
/// This repository acts as an abstraction layer between the data source and the service,
/// providing methods to fetch partner subscription data and manage the user's authentication token.
class PaymentSummaryRepository with RepositoryCacheMixin {
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
    // Clear cache when token changes (user might have logged in/out)
    clearAllCache();
  }

  /// Fetches payment summary information for a specific plan and recurrence type.
  ///
  /// Returns a [PaymentSummaryInfoResponse] with the payment details.
  /// Results are cached for 5 minutes as payment info is relatively stable.
  Future<PaymentSummaryInfoResponse> getPaymentSummaryByPlan({
    required String planId,
    required String recurrenceType,
  }) async {
    final result = await cachedCall<PaymentSummaryInfoResponse>(
      key: 'payment_summary_${planId}_$recurrenceType',
      ttl: const Duration(minutes: 5),
      fetcher: () async {
        try {
          final data = await _dataSource.getPaymentSummaryByPlan(
            planId: planId,
            recurrenceType: recurrenceType,
          );
          return Right(data);
        } catch (e) {
          return Left(
            ExceptionFailure.decode(
              e is Exception ? e : Exception(e.toString()),
            ),
          );
        }
      },
    );
    return result.fold((l) => throw Exception(l.message), (r) => r);
  }
}

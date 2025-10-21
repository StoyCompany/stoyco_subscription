import 'package:either_dart/either.dart';
import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// A [ChangeNotifier] that manages the state for the payment summary view.
///
/// Loads and exposes [PaymentSummaryInfoModel] data, as well as loading state.
/// Notifies listeners when the payment summary data is loaded or updated.
///
/// Example usage:
/// ```dart
/// final notifier = PaymentSummaryNotifier(subscriptionId: 'abc123');
/// // Listen to changes
/// notifier.addListener(() {
///   // React to updates
/// });
/// ```
class PaymentSummaryNotifier extends ChangeNotifier {
  /// Creates a [PaymentSummaryNotifier].
  ///
  /// Optionally provide a [planId] to load a specific payment summary.
  /// Automatically loads mock payment summary data on initialization.
  PaymentSummaryNotifier({this.planId, this.recurrenceType}) {
    loadPaymentSummary(planId, recurrenceType);
  }

  /// The subscription ID for which to load the payment summary.
  final String? planId;
  final String? recurrenceType;

  /// The current payment summary information.
  PaymentSummaryInfoResponse? paymentSummaryInfo;

  /// Whether the payment summary is currently loading.
  bool isLoading = true;

  /// Loads mock payment summary data and notifies listeners.
  ///
  /// Sets [isLoading] to true while loading, then updates [paymentSummaryInfo]
  /// with mock data and sets [isLoading] to false.
  Future<void> loadPaymentSummary(
    String? planId,
    String? recurrenceType,
  ) async {
    if (planId == null || recurrenceType == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();

    final Either<Failure, PaymentSummaryInfoResponse> result =
        await PaymentSummaryService.instance.getPaymentSummaryByPlan(
          planId: planId,
          recurrenceType: recurrenceType,
        );

    result.fold(
      (Failure failure) {
        paymentSummaryInfo = null;
      },
      (PaymentSummaryInfoResponse response) {
        paymentSummaryInfo = response;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}

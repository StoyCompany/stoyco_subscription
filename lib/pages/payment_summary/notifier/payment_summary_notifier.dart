import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_summary_info_model.dart';

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
  /// Optionally provide a [subscriptionId] to load a specific payment summary.
  /// Automatically loads mock payment summary data on initialization.
  PaymentSummaryNotifier({this.subscriptionId}) {
    loadMockPaymentSummary();
  }

  /// The subscription ID for which to load the payment summary.
  final String? subscriptionId;

  /// The current payment summary information.
  PaymentSummaryInfoModel? paymentSummaryInfo;

  /// Whether the payment summary is currently loading.
  bool isLoading = true;

  /// Loads mock payment summary data and notifies listeners.
  ///
  /// Sets [isLoading] to true while loading, then updates [paymentSummaryInfo]
  /// with mock data and sets [isLoading] to false.
  Future<void> loadMockPaymentSummary() async {
    isLoading = true;
    notifyListeners();

    // Mock data
    paymentSummaryInfo = const PaymentSummaryInfoModel(
      planName: 'Plan Premium',
      totalPrice: 299.99,
      shortDescription: 'Acceso ilimitado a todos los contenidos premium.',
      startDate: '2024-06-01',
      planPrice: 259.99,
      iva: 40.00,
      currencySymbol: r'$',
      currencyCode: 'MXN',
    );

    print('paymentSummaryInfo: $paymentSummaryInfo');
    isLoading = false;
    notifyListeners();
  }
}

import 'package:flutter/widgets.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/payment_summary_info_model.dart';

class PaymentSummaryNotifier extends ChangeNotifier {
  PaymentSummaryNotifier({this.subscriptionId}) {
    loadMockPaymentSummary();
  }

  final String? subscriptionId;

  PaymentSummaryInfoModel? paymentSummaryInfo;
  bool isLoading = true;

  Future<void> loadMockPaymentSummary() async {
    isLoading = true;
    notifyListeners();

    //Mock data
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

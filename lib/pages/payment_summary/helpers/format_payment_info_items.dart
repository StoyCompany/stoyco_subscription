import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';

/// Returns a list of key-value pairs with payment information items.
///
/// Each item contains a 'key' (label) and a 'value' (amount with currency).
List<Map<String, String>> getPaymentInfoItems(PaymentSummaryInfoResponse info) {
  final String code = info.breakdown.currencyCode;
  final String symbol = info.breakdown.currencySymbol;
  return <Map<String, String>>[
    <String, String>{
      'key': 'Plan',
      'value': '$code $symbol${info.breakdown.planAmount.toStringAsFixed(2)}',
    },
    <String, String>{
      'key': 'IVA',
      'value': '$code $symbol${info.breakdown.ivaAmount.toStringAsFixed(2)}',
    },
  ];
}

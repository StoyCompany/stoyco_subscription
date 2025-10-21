import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_summary_info_model.g.dart';

/// {@template payment_summary_info_model}
/// A data model representing payment summary information for the Stoyco Subscription Atomic Design System.
///
/// ### Overview
/// Encapsulates all relevant details for a payment summary, including plan name, pricing, taxes, currency, and a short description. Useful for displaying payment breakdowns in UI components.
/// 
/// ### Parameters
/// - `planName`: The name of the subscription plan.
/// - `totalPrice`: The total price to be paid (including taxes).
/// - `shortDescription`: A short description of the plan or payment.
/// - `startDate`: The start date of the subscription.
/// - `planPrice`: The base price of the plan (before taxes).
/// - `iva`: The tax (IVA) amount included in the total price.
/// - `currencySymbol`: The currency symbol (e.g., '$').
/// - `currencyCode`: The currency code (e.g., 'MXN').
///
/// ### Returns
/// Provides a serializable model for payment summary information, supporting JSON serialization and value equality.
///
/// ### Example
/// ```dart
/// final info = PaymentSummaryInfoModel(
///   planName: 'Premium Plan',
///   totalPrice: 199.0,
///   shortDescription: 'Access to all premium features.',
///   startDate: '2025-10-25',
///   planPrice: 170.0,
///   iva: 29.0,
///   currencySymbol: '\$',
///   currencyCode: 'MXN',
/// );
/// ```
/// {@endtemplate}
/// 
@JsonSerializable()
/// {@macro payment_summary_info_model}
class PaymentSummaryInfoModel extends Equatable {

  /// Creates a [PaymentSummaryInfoModel] with all required payment summary fields.
  const PaymentSummaryInfoModel({
    required this.planName,
    required this.totalPrice,
    required this.shortDescription,
    required this.startDate,
    required this.planPrice,
    required this.iva,
    required this.currencySymbol,
    required this.currencyCode,
  });

  /// Creates a [PaymentSummaryInfoModel] from a JSON map.
  factory PaymentSummaryInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryInfoModelFromJson(json);

  /// The name of the subscription plan.
  final String planName;

  /// The total price to be paid (including taxes).
  final double totalPrice;

  /// A short description of the plan or payment.
  final String shortDescription;

  /// The start date of the subscription.
  final String startDate;

  /// The base price of the plan (before taxes).
  final double planPrice;

  /// The tax (IVA) amount included in the total price.
  final double iva;

  /// The currency symbol (e.g., '$').
  final String currencySymbol;

  /// The currency code (e.g., 'MXN').
  final String currencyCode;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => _$PaymentSummaryInfoModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
    planName,
    totalPrice,
    shortDescription,
    startDate,
    planPrice,
    iva,
    currencySymbol,
    currencyCode,
  ];
}

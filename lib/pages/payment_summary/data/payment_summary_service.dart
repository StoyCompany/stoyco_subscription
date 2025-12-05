import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_subscription/envs/envs.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/models/response/payment_symmary_info_response.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_data_source.dart';
import 'package:stoyco_subscription/pages/payment_summary/data/payment_summary_repository.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/error.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/exception.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/errors/failure.dart';

/// {@template payment_summary_service}
/// Service for managing payment summary operations.
///
/// Provides methods to fetch payment information for subscription plans,
/// including pricing details, discounts, and billing information.
/// Handles authentication token management manually.
///
/// **Usage:**
/// ```dart
/// // Initialize service
/// final service = PaymentSummaryService(
///   environment: StoycoEnvironment.production,
///   userToken: 'your_token_here',
///   functionToUpdateToken: () async => await getNewToken(),
/// );
///
/// // Get payment summary
/// final result = await service.getPaymentSummaryByPlan(
///   planId: '507f1f77bcf86cd799439011',
///   recurrenceType: 'Monthly',
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (summary) => print('Total: \$${summary.totalAmount}'),
/// );
/// ```
/// {@endtemplate}
class PaymentSummaryService {
  /// Factory constructor for initializing the service.
  ///
  /// Automatically handles token retrieval and refresh from Firebase Auth.
  ///
  /// - [firebaseAuth]: Required Firebase Auth instance for authentication
  /// - [environment]: API environment (defaults to development)
  factory PaymentSummaryService({
    required FirebaseAuth firebaseAuth,
    StoycoEnvironment environment = StoycoEnvironment.development,
  }) {
    instance = PaymentSummaryService._(
      firebaseAuth: firebaseAuth,
      environment: environment,
    );
    return instance;
  }

  /// Private constructor for singleton pattern.
  PaymentSummaryService._({
    required this.firebaseAuth,
    this.environment = StoycoEnvironment.development,
  }) {
    _dataSource = PaymentSummaryDataSource(environment: environment);
    _repository = PaymentSummaryRepository(_dataSource, '');
  }

  /// Singleton instance of [PaymentSummaryService].
  static late PaymentSummaryService instance;

  /// The current environment (development, production, testing).
  final StoycoEnvironment environment;

  /// Firebase Auth instance for automatic token management.
  final FirebaseAuth firebaseAuth;

  late final PaymentSummaryDataSource _dataSource;
  late final PaymentSummaryRepository _repository;

  /// Gets the current user token from Firebase Auth.
  Future<String> _getToken() async {
    final User? user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in to Firebase');
    }
    final String? token = await user.getIdToken();
    if (token == null) {
      throw Exception('Failed to retrieve Firebase ID token');
    }
    return token;
  }

  /// Updates the token in the data source and repository.
  Future<void> _updateTokenInLayers() async {
    final String token = await _getToken();
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  /// Fetches payment summary information for a specific subscription plan.
  ///
  /// Returns detailed payment information including pricing, discounts,
  /// taxes, and total amounts for the specified plan and billing cycle.
  ///
  /// **Parameters:**
  /// - [planId]: MongoDB ObjectId of the subscription plan
  /// - [recurrenceType]: Billing cycle (e.g., "Monthly", "Yearly")
  ///
  /// **Returns:**
  /// - [Right]: [PaymentSummaryInfoResponse] with payment details on success
  /// - [Left]: [Failure] with error information on failure
  ///
  /// **Example:**
  /// ```dart
  /// final result = await service.getPaymentSummaryByPlan(
  ///   planId: '507f1f77bcf86cd799439011',
  ///   recurrenceType: 'Monthly',
  /// );
  ///
  /// result.fold(
  ///   (failure) {
  ///     print('Error: ${failure.message}');
  ///     showErrorDialog(failure.message);
  ///   },
  ///   (summary) {
  ///     print('Plan: ${summary.planName}');
  ///     print('Subtotal: \$${summary.subtotal}');
  ///     print('Discount: \$${summary.discount}');
  ///     print('Tax: \$${summary.tax}');
  ///     print('Total: \$${summary.totalAmount}');
  ///     displayPaymentSummary(summary);
  ///   },
  /// );
  /// ```
  Future<Either<Failure, PaymentSummaryInfoResponse>> getPaymentSummaryByPlan({
    required String planId,
    required String recurrenceType,
  }) async {
    try {
      await _updateTokenInLayers();
      final PaymentSummaryInfoResponse result = await _repository.getPaymentSummaryByPlan(
        planId: planId,
        recurrenceType: recurrenceType,
      );
      return Right<Failure, PaymentSummaryInfoResponse>(result);
    } on DioException catch (error) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        DioFailure.decode(error),
      );
    } on Error catch (error) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        ErrorFailure.decode(error),
      );
    } on Exception catch (error) {
      return Left<Failure, PaymentSummaryInfoResponse>(
        ExceptionFailure.decode(error),
      );
    }
  }
}

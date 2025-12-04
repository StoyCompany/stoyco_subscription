import 'dart:async';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
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
  /// **Parameters:**
  /// - [environment]: API environment (defaults to development)
  /// - [userToken]: Initial authentication token
  /// - [functionToUpdateToken]: Optional function to refresh the token when needed
  ///
  /// **Example:**
  /// ```dart
  /// final service = PaymentSummaryService(
  ///   environment: StoycoEnvironment.production,
  ///   userToken: 'initial_token',
  ///   functionToUpdateToken: () async {
  ///     return await FirebaseAuth.instance.currentUser?.getIdToken();
  ///   },
  /// );
  /// ```
  factory PaymentSummaryService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?> Function()? functionToUpdateToken,
  }) {
    instance = PaymentSummaryService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    return instance;
  }

  /// Private constructor for singleton pattern.
  PaymentSummaryService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _dataSource = PaymentSummaryDataSource(environment: environment);
    _repository = PaymentSummaryRepository(_dataSource, userToken);
    _repository.updateToken(userToken);
    _dataSource.updateToken(userToken);
  }

  /// Singleton instance of [PaymentSummaryService].
  static PaymentSummaryService instance = PaymentSummaryService._();

  /// Current authentication token.
  String userToken;

  /// Current API environment.
  StoycoEnvironment environment;

  /// Optional function to refresh the authentication token.
  Future<String?> Function()? functionToUpdateToken;

  late final PaymentSummaryDataSource _dataSource;
  late final PaymentSummaryRepository _repository;

  /// Updates the authentication token across all layers.
  ///
  /// Call this method when the user's authentication token changes
  /// (e.g., after login or token refresh).
  ///
  /// **Example:**
  /// ```dart
  /// final newToken = await FirebaseAuth.instance.currentUser?.getIdToken();
  /// service.updateToken(newToken ?? '');
  /// ```
  void updateToken(String token) {
    userToken = token;
    _repository.updateToken(token);
    _dataSource.updateToken(token);
  }

  /// Sets the function used to refresh the authentication token.
  ///
  /// This function will be called automatically when the token is empty
  /// or needs to be refreshed.
  ///
  /// **Example:**
  /// ```dart
  /// service.setFunctionToUpdateToken(() async {
  ///   return await FirebaseAuth.instance.currentUser?.getIdToken();
  /// });
  /// ```
  void setFunctionToUpdateToken(Future<String?> Function()? function) {
    functionToUpdateToken = function;
  }

  /// Verifies and updates the authentication token if necessary.
  ///
  /// This method is called automatically before API requests to ensure
  /// a valid token is available.
  ///
  /// **Throws:**
  /// - [FunctionToUpdateTokenNotSetException] if token is empty and no update function is set
  /// - [EmptyUserTokenException] if token refresh fails or returns empty
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }
      final String? newToken = await functionToUpdateToken!();
      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _repository.updateToken(newToken);
        _dataSource.updateToken(newToken);
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
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
      await verifyToken();
      return await _repository.getPaymentSummaryByPlan(
        planId: planId,
        recurrenceType: recurrenceType,
      );
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

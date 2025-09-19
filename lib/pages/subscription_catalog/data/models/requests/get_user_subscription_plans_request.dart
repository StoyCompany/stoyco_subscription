/// {@template get_user_subscription_plans_request}
/// Request model for fetching user subscription plans.
///
/// Contains the [userId] required to retrieve the subscription plans
/// associated with a specific user.
/// {@endtemplate}
class GetUserSubscriptionPlansRequest {
  /// {@macro get_user_subscription_plans_request}
  const GetUserSubscriptionPlansRequest({required this.userId});

  /// The unique identifier of the user whose subscription plans are being requested.
  final String userId;
}

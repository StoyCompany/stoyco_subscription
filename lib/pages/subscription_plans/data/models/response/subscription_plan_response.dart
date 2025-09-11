import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';

part 'subscription_plan_response.g.dart';

/// Model representing a subscription plan group (parent).
@JsonSerializable()
class SubscriptionPlanResponse extends Equatable {
  const SubscriptionPlanResponse({
    required this.artistName,
    required this.monthlyPlans,
    required this.annualPlans,
  });

  factory SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanResponseFromJson(json);

  /// The name of the artist, athlete, or brand.
  final String artistName;

  /// List of monthly subscription plans.
  final List<SubscriptionPlan> monthlyPlans;

  /// List of annual subscription plans.
  final List<SubscriptionPlan> annualPlans;
  Map<String, dynamic> toJson() => _$SubscriptionPlanResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[artistName, monthlyPlans, annualPlans];
}

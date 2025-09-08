import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_plans/models/subscription_plan.dart';

part 'subscription_plan_parent.g.dart';

/// Model representing a subscription plan group (parent).
@JsonSerializable()
class SubscriptionPlanParent extends Equatable {
  const SubscriptionPlanParent({
    required this.artistName,
    required this.monthlyPlans,
    required this.annualPlans,
  });

  factory SubscriptionPlanParent.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanParentFromJson(json);

  /// The name of the artist, athlete, or brand.
  final String artistName;

  /// List of monthly subscription plans.
  final List<SubscriptionPlan> monthlyPlans;

  /// List of annual subscription plans.
  final List<SubscriptionPlan> annualPlans;
  Map<String, dynamic> toJson() => _$SubscriptionPlanParentToJson(this);

  @override
  List<Object?> get props => <Object?>[artistName, monthlyPlans, annualPlans];
}

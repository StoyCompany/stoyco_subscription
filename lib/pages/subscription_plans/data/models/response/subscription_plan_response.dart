import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/subscription_plan.dart';

part 'subscription_plan_response.g.dart';

/// Model representing a subscription plan group (parent).
@JsonSerializable()
class SubscriptionPlanResponse extends Equatable {
  const SubscriptionPlanResponse({
    required this.partnerID,
    required this.partnerName,
    required this.monthlyPlans,
    required this.annualPlans,
  });

  const SubscriptionPlanResponse.empty()
      : partnerID = '',
        partnerName = '',
        monthlyPlans = const <SubscriptionPlan>[],
        annualPlans = const <SubscriptionPlan>[];

  factory SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanResponseFromJson(json);

  /// The name of the artist, athlete, or brand.
  final String partnerID;

  final String partnerName;

  /// List of monthly subscription plans.
  final List<SubscriptionPlan> monthlyPlans;

  /// List of annual subscription plans.
  final List<SubscriptionPlan> annualPlans;
  Map<String, dynamic> toJson() => _$SubscriptionPlanResponseToJson(this);

  @override
  List<Object?> get props => <Object?>[partnerID, partnerName, monthlyPlans, annualPlans];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_subscription_plans_request.g.dart';

/// Model representing a subscription plan option (child).
@JsonSerializable()
class GetSubscriptionPlansRequest extends Equatable {
  /// Creates a [GetSubscriptionPlansRequest] model.
  ///
  /// [idPartner] is the unique identifier for the subscription plan.
  /// [idUser] is the unique identifier for the user.
  const GetSubscriptionPlansRequest({
    required this.idPartner,
    required this.idUser,
  });

  factory GetSubscriptionPlansRequest.fromJson(Map<String, dynamic> json) => _$GetSubscriptionPlansRequestFromJson(json);

  /// The unique identifier for the subscription plan.
  final String idPartner;

  /// The unique identifier for the user.
  final String idUser;

  Map<String, dynamic> toJson() => _$GetSubscriptionPlansRequestToJson(this);

  @override
  List<Object?> get props => <Object?>[
    idPartner,
    idUser,
  ];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'access_content.g.dart';

@JsonSerializable()
class AccessContent extends Equatable {
  const AccessContent({
    required this.contentId,
    required this.partnerId,
    required this.planIds,
    this.visibleFrom,
    this.visibleUntil,
  });

  factory AccessContent.fromJson(Map<String, dynamic> json) => _$AccessContentFromJson(json);

  final String contentId;
  final String partnerId;
  final List<String> planIds;
  final DateTime? visibleFrom;
  final DateTime? visibleUntil;

  Map<String, dynamic> toJson() => _$AccessContentToJson(this);

  @override
  List<Object?> get props => <Object?>[
    contentId,
    partnerId,
    planIds,
    visibleFrom,
    visibleUntil,
  ];
}

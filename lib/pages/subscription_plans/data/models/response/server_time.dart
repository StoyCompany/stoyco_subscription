import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_time.g.dart';

/// Model representing the server time response.
@JsonSerializable()
class ServerTime extends Equatable {
  /// Creates a [ServerTime] model.
  ///
  /// [utcDateTime] - The server time in UTC.
  /// [unixTimestamp] - The Unix timestamp in seconds.
  /// [iso8601] - The ISO 8601 formatted date string.
  const ServerTime({
    required this.utcDateTime,
    required this.unixTimestamp,
    required this.iso8601,
  });

  factory ServerTime.fromJson(Map<String, dynamic> json) =>
      _$ServerTimeFromJson(json);

  /// The server time in UTC.
  final DateTime utcDateTime;

  /// The Unix timestamp in seconds.
  final int unixTimestamp;

  /// The ISO 8601 formatted date string.
  final String iso8601;

  Map<String, dynamic> toJson() => _$ServerTimeToJson(this);

  @override
  List<Object?> get props => <Object?>[utcDateTime, unixTimestamp, iso8601];
}

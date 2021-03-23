import 'package:json_annotation/json_annotation.dart';

part 'cleaning_period.g.dart';

@JsonSerializable()
class CleaningPeriod {
  String uid;
  DateTime start;
  DateTime end;
  bool isLive;
  DateTime? lastUpdate;

  CleaningPeriod({
    required this.uid,
    required this.start,
    required this.end,
    required this.isLive,
    this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$CleaningPeriodToJson(this);

  factory CleaningPeriod.fromJson(Map<String, dynamic> json) =>
      _$CleaningPeriodFromJson(json);
}

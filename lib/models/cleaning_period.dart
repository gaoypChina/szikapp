import 'package:json_annotation/json_annotation.dart';

part 'cleaning_period.g.dart';

///Represents a series of [CleaningTask]s
@JsonSerializable()
class CleaningPeriod {
  String uid;
  DateTime start;
  DateTime end;
  @JsonKey(name: 'is_live')
  bool isLive;
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;

  CleaningPeriod({
    required this.uid,
    required this.start,
    required this.end,
    this.isLive = false,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$CleaningPeriodToJson(this);

  factory CleaningPeriod.fromJson(Map<String, dynamic> json) =>
      _$CleaningPeriodFromJson(json);
}

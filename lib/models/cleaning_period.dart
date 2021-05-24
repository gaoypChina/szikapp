import 'package:json_annotation/json_annotation.dart';

part 'cleaning_period.g.dart';

typedef Json = Map<String, dynamic>;

///Represents a series of [CleaningTask]s
@JsonSerializable()
class CleaningPeriod {
  String uid;
  DateTime start;
  DateTime end;
  @JsonKey(name: 'is_live')
  bool isLive;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  CleaningPeriod({
    required this.uid,
    required this.start,
    required this.end,
    this.isLive = false,
    required this.lastUpdate,
  });

  Json toJson() => _$CleaningPeriodToJson(this);

  factory CleaningPeriod.fromJson(Json json) => _$CleaningPeriodFromJson(json);
}

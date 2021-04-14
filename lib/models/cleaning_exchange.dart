import 'package:json_annotation/json_annotation.dart';

part 'cleaning_exchange.g.dart';

@JsonSerializable()
class CleaningExchange {
  @JsonValue('task_id')
  String taskID;
  @JsonValue('initiator_id')
  String initiatorID;
  @JsonValue('replace_task_id')
  String? replaceTaskID;
  @JsonValue('responder_id')
  String? responderID;
  bool approved;
  List<Map<String, dynamic>>? rejected;
  @JsonValue('last_update')
  DateTime lastUpdate;

  CleaningExchange({
    required this.taskID,
    required this.initiatorID,
    this.replaceTaskID,
    this.responderID,
    this.approved = false,
    this.rejected,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$CleaningExchangeToJson(this);

  factory CleaningExchange.fromJson(Map<String, dynamic> json) =>
      _$CleaningExchangeFromJson(json);
}

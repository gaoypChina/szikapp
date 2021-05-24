import 'package:json_annotation/json_annotation.dart';

part 'cleaning_exchange.g.dart';

typedef Json = Map<String, dynamic>;

@JsonSerializable()
class CleaningExchange {
  String uid;
  @JsonKey(name: 'task_id')
  String taskID;
  @JsonKey(name: 'initiator_id')
  String initiatorID;
  @JsonKey(name: 'replace_task_id')
  String? replaceTaskID;
  @JsonKey(name: 'responder_id')
  String? responderID;
  bool approved;
  List<Map<String, dynamic>>? rejected;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  CleaningExchange({
    required this.uid,
    required this.taskID,
    required this.initiatorID,
    this.replaceTaskID,
    this.responderID,
    this.approved = false,
    this.rejected,
    required this.lastUpdate,
  });

  Json toJson() => _$CleaningExchangeToJson(this);

  factory CleaningExchange.fromJson(Json json) =>
      _$CleaningExchangeFromJson(json);
}

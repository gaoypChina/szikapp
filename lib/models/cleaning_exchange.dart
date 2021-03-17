import 'package:json_annotation/json_annotation.dart';

part 'cleaning_exchange.g.dart';

@JsonSerializable()
class CleaningExchange {
  String taskID;
  String initiatorID;
  String? replaceTaskID;
  String? responderID;
  bool approved;
  List<Map<String, dynamic>>? rejected;
  DateTime? lastUpdate;

  CleaningExchange({
    required this.taskID,
    required this.initiatorID,
    required this.replaceTaskID,
    this.responderID,
    this.approved = false,
    this.rejected,
    this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$CleaningExchangeToJson(this);

  factory CleaningExchange.fromJson(Map<String, dynamic> json) =>
      _$CleaningExchangeFromJson(json);
}

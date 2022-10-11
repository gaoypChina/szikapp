import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';
import 'interfaces.dart';

part 'cleaning_exchange.g.dart';

///Konyhatakarítás-csere adatmodell osztály. Szerializálható `JSON` formátumba
///és vice versa.
@JsonSerializable()
class CleaningExchange implements Identifiable, Cachable {
  @override
  String id;
  @JsonKey(name: 'task_id')
  String taskID;
  @JsonKey(name: 'initiator_id')
  String initiatorID;
  @JsonKey(name: 'replace_task_id')
  String? replaceTaskID;
  bool approved;
  List<Json>? replacements;
  @override
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;

  CleaningExchange({
    required this.id,
    required this.taskID,
    required this.initiatorID,
    this.replaceTaskID,
    this.approved = false,
    this.replacements,
    required this.lastUpdate,
  });

  Json toJson() => _$CleaningExchangeToJson(this);

  factory CleaningExchange.fromJson(Json json) =>
      _$CleaningExchangeFromJson(json);
}

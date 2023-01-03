import 'package:json_annotation/json_annotation.dart';

import '../utils/types.dart';
import 'interfaces.dart';
import 'models.dart';

part 'cleaning_exchange.g.dart';

///Konyhatakarítás-csere adatmodell osztály. Szerializálható `JSON` formátumba
///és vice versa.
@JsonSerializable()
class CleaningExchange implements Identifiable, Cachable {
  @override
  @JsonKey(name: 'uid')
  String id;
  @JsonKey(name: 'task_id')
  String taskID;
  @JsonKey(name: 'initiator_id')
  String initiatorID;
  TaskStatus status;
  List<Json> replacements;
  @override
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;

  CleaningExchange({
    required this.id,
    required this.taskID,
    required this.initiatorID,
    this.status = TaskStatus.created,
    this.replacements = const [],
    required this.lastUpdate,
  });

  Json toJson() => _$CleaningExchangeToJson(this);

  factory CleaningExchange.fromJson(Json json) =>
      _$CleaningExchangeFromJson(json);
}

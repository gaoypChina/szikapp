import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';
import 'models.dart';

part 'cleaning_exchange.g.dart';

@JsonSerializable(explicitToJson: true)
class Replacement {
  @JsonKey(name: 'task_id')
  String taskID;
  @JsonKey(name: 'replacer_id')
  String replacerID;
  TaskStatus status;

  Replacement({
    required this.taskID,
    required this.replacerID,
    this.status = TaskStatus.created,
  });

  Json toJson() => _$ReplacementToJson(this);

  factory Replacement.fromJson(Json json) => _$ReplacementFromJson(json);
}

///Konyhatakarítás-csere adatmodell osztály. Szerializálható `JSON` formátumba
///és vice versa.
@JsonSerializable(explicitToJson: true)
class CleaningExchange implements Identifiable, Cachable {
  @override
  @JsonKey(name: 'uid')
  String id;
  @JsonKey(name: 'task_id')
  String taskID;
  @JsonKey(name: 'initiator_id')
  String initiatorID;
  TaskStatus status;
  List<Replacement> replacements;
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

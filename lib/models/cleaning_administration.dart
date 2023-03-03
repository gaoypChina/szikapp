import 'package:json_annotation/json_annotation.dart';
import '../utils/utils.dart';
import 'models.dart';

part 'cleaning_administration.g.dart';

///Konyhatakarítás periódus adatmodell osztály. Takarítások [CleaningTask]
///összefüggő időszakát reprezentálja. Szerializálható `JSON` formátumba és
///vice versa.
@JsonSerializable()
class CleaningPeriod implements Identifiable, Cachable {
  @override
  @JsonKey(name: 'uid')
  String id;
  DateTime start;
  DateTime end;
  @JsonKey(name: 'is_live')
  bool isLive;
  @override
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;

  CleaningPeriod({
    required this.id,
    required this.start,
    required this.end,
    this.isLive = false,
    required this.lastUpdate,
  });

  Json toJson() => _$CleaningPeriodToJson(this);

  factory CleaningPeriod.fromJson(Json json) => _$CleaningPeriodFromJson(json);
}

@JsonSerializable()
class CleaningParticipants implements Cachable {
  @JsonKey(name: 'group_ids')
  List<String> groupIDs;
  @JsonKey(name: 'black_list')
  List<String> blackList;
  @override
  @JsonKey(name: 'last_update')
  DateTime lastUpdate;

  CleaningParticipants({
    required this.groupIDs,
    required this.blackList,
    required this.lastUpdate,
  });

  Json toJson() => _$CleaningParticipantsToJson(this);

  factory CleaningParticipants.fromJson(Json json) =>
      _$CleaningParticipantsFromJson(json);
}

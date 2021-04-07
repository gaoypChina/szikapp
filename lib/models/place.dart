import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  final String id;
  final String name;
  final String type;
  String? description;
  @JsonValue('overseer_ids')
  List<String>? overseerIDs;
  @JsonValue('last_update')
  DateTime lastUpdate;

  Place({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.overseerIDs,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

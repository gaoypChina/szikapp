import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  final String id;
  final String name;
  final String type;
  String description;
  String overseerID;
  DateTime lastUpdate;

  Place({
    this.id,
    this.name,
    this.type,
    this.description,
    this.overseerID,
    this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

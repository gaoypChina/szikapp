import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  final String name;
  String? description;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Resource({
    required this.name,
    this.description,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() => _$ResourceToJson(this);

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);
}

@JsonSerializable()
class Place extends Resource {
  final String id;
  final String type;
  @JsonKey(name: 'overseer_ids')
  List<String>? overseerIDs;

  Place(
      {required this.id,
      required name,
      description,
      required this.type,
      this.overseerIDs,
      required lastUpdate})
      : super(
          name: name,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Map<String, dynamic> toJson() => _$PlaceToJson(this);

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@JsonSerializable()
class Boardgame extends Resource {
  final String id;
  @JsonKey(name: 'icon_link')
  final String iconLink;

  Boardgame(
      {required this.id,
      required name,
      description,
      required this.iconLink,
      required lastUpdate})
      : super(
          name: name,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Map<String, dynamic> toJson() => _$BoardgameToJson(this);

  factory Boardgame.fromJson(Map<String, dynamic> json) =>
      _$BoardgameFromJson(json);
}

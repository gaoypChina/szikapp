import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

typedef Json = Map<String, dynamic>;

@JsonSerializable(explicitToJson: true)
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

  Json toJson() => _$ResourceToJson(this);

  factory Resource.fromJson(Json json) => _$ResourceFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class Place extends Resource {
  final String id;
  final String type;
  @JsonKey(name: 'overseer_ids')
  List<String>? overseerIDs;

  Place(
      {required this.id,
      required String name,
      String? description,
      required this.type,
      this.overseerIDs,
      required DateTime lastUpdate})
      : super(
          name: name,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$PlaceToJson(this);

  factory Place.fromJson(Json json) => _$PlaceFromJson(json);

  String placeAsString() {
    return '#$id $name';
  }

  bool isEqual(Place? other) {
    if (other == null) return false;
    return id == other.id;
  }

  @override
  String toString() => name;
}

@JsonSerializable(explicitToJson: true)
class Boardgame extends Resource {
  final String id;
  @JsonKey(name: 'icon_link')
  final String iconLink;

  Boardgame(
      {required this.id,
      required String name,
      String? description,
      required this.iconLink,
      required DateTime lastUpdate})
      : super(
          name: name,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$BoardgameToJson(this);

  factory Boardgame.fromJson(Json json) => _$BoardgameFromJson(json);

  String boardgameAsString() {
    return '#$id $name';
  }

  bool isEqual(Boardgame other) {
    return id == other.id;
  }

  @override
  String toString() => name;
}

import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';
import 'interfaces.dart';

part 'resource.g.dart';

///Alapvető erőforrást reprezentáló adatmodell ősosztály.
///Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class Resource implements Identifiable, Cachable {
  @override
  final String id;
  final String name;
  String? description;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Resource({
    required this.id,
    required this.name,
    this.description,
    required this.lastUpdate,
  });

  Json toJson() => _$ResourceToJson(this);

  factory Resource.fromJson(Json json) => _$ResourceFromJson(json);
}

///Kollégiumi helyiségeket megjelenítő adatmodell osztály. A [Resource]
///osztály leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class Place extends Resource {
  final String type;
  @JsonKey(name: 'overseer_ids')
  List<String> overseerIDs;

  Place({
    required id,
    required String name,
    String? description,
    required this.type,
    this.overseerIDs = const [],
    required DateTime lastUpdate,
  }) : super(
          id: id,
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

///Társasjátékokat megjelenítő adatmodell osztály. A [Resource] osztály
///leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class Boardgame extends Resource {
  @JsonKey(name: 'icon_link')
  final String iconLink;

  Boardgame({
    required id,
    required String name,
    String? description,
    required this.iconLink,
    required DateTime lastUpdate,
  }) : super(
          id: id,
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

@JsonSerializable(explicitToJson: true)
class Account extends Resource {
  final String username;
  final String credential;
  final String url;
  Account({
    required String id,
    required String name,
    String? description,
    required DateTime lastUpdate,
    required this.username,
    required this.credential,
    required this.url,
  }) : super(
          id: id,
          name: name,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$AccountToJson(this);

  factory Account.fromJson(Json json) => _$AccountFromJson(json);

  String accountAsString() {
    return '#$id $name';
  }

  bool isEqual(Account other) {
    return id == other.id;
  }

  @override
  String toString() => name;
}

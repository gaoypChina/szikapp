import 'package:json_annotation/json_annotation.dart';
import '../utils/utils.dart';
import 'models.dart';

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

enum PlaceType {
  @JsonValue('room')
  room,
  @JsonValue('public')
  public,
  @JsonValue('other')
  other,
}

///Kollégiumi helyiségeket megjelenítő adatmodell osztály. A [Resource]
///osztály leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class Place extends Resource {
  final PlaceType type;
  @JsonKey(name: 'overseer_ids')
  List<String> overseerIDs;

  Place({
    required super.id,
    required super.name,
    super.description,
    required this.type,
    this.overseerIDs = const [],
    required super.lastUpdate,
  });

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
    required super.id,
    required super.name,
    super.description,
    required this.iconLink,
    required super.lastUpdate,
  });

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
  final bool reservable;

  Account({
    required super.id,
    required super.name,
    super.description,
    required super.lastUpdate,
    required this.username,
    required this.credential,
    required this.url,
    this.reservable = true,
  });

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

@JsonSerializable(explicitToJson: true)
class Article extends Resource {
  final String url;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  Article({
    required super.id,
    required super.name,
    super.description,
    required super.lastUpdate,
    required this.imageUrl,
    required this.url,
  });

  @override
  Json toJson() => _$ArticleToJson(this);

  factory Article.fromJson(Json json) => _$ArticleFromJson(json);

  String articleAsString() {
    return '#$id $name';
  }

  bool isEqual(Account other) {
    return id == other.id;
  }

  @override
  String toString() => name;
}

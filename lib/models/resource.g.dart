// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
      overseerIDs: (json['overseer_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'type': _$PlaceTypeEnumMap[instance.type],
      'overseer_ids': instance.overseerIDs,
    };

const _$PlaceTypeEnumMap = {
  PlaceType.room: 'room',
  PlaceType.public: 'public',
  PlaceType.other: 'other',
};

Boardgame _$BoardgameFromJson(Map<String, dynamic> json) => Boardgame(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String?,
      iconLink: json['icon_link'] as String,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$BoardgameToJson(Boardgame instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'icon_link': instance.iconLink,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
      username: json['username'] as String,
      credential: json['credential'] as String,
      url: json['url'] as String,
      reservable: json['reservable'] as bool? ?? true,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'username': instance.username,
      'credential': instance.credential,
      'url': instance.url,
      'reservable': instance.reservable,
    };

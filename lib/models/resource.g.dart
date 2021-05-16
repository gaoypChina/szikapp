// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) {
  return Resource(
    name: json['name'] as String,
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    type: json['type'] as String,
    overseerIDs: (json['overseer_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'id': instance.id,
      'type': instance.type,
      'overseer_ids': instance.overseerIDs,
    };

Boardgame _$BoardgameFromJson(Map<String, dynamic> json) {
  return Boardgame(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    iconLink: json['icon_link'] as String,
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$BoardgameToJson(Boardgame instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'id': instance.id,
      'icon_link': instance.iconLink,
    };

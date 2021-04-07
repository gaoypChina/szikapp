// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    description: json['description'] as String?,
    overseerIDs: (json['overseerIDs'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    lastUpdate: DateTime.parse(json['lastUpdate'] as String),
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'overseerIDs': instance.overseerIDs,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

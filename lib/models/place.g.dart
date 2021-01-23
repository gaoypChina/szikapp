// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    placeID: json['placeID'] as String,
    name: json['name'] as String,
    number: json['number'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'placeID': instance.placeID,
      'name': instance.name,
      'number': instance.number,
      'description': instance.description,
    };

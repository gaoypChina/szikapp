// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    email: json['email'] as String?,
    memberIDs: (json['member_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'email': instance.email,
      'member_ids': instance.memberIDs,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

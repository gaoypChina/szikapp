// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    groupID: json['groupID'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    emailList: json['emailList'] as String,
    memberIDs: (json['memberIDs'] as List)?.map((e) => e as String)?.toList(),
    maxMemberCount: json['maxMemberCount'] as int,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupID': instance.groupID,
      'name': instance.name,
      'description': instance.description,
      'emailList': instance.emailList,
      'maxMemberCount': instance.maxMemberCount,
      'memberIDs': instance.memberIDs,
    };

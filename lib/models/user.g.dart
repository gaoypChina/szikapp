// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userID: json['userID'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    mobile: json['mobile'] as String,
    groupIDs: (json['groupIDs'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userID': instance.userID,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'groupIDs': instance.groupIDs,
    };

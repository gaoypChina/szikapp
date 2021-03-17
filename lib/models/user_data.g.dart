// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    userID: json['userID'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    mobile: json['mobile'] as String,
    birthday: json['birthday'] == null
        ? null
        : DateTime.parse(json['birthday'] as String),
    groupIDs: (json['groupIDs'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'userID': instance.userID,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'birthday': instance.birthday?.toIso8601String(),
      'groupIDs': instance.groupIDs,
    };

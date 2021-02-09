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
    permissions: (json['permissions'] as List)
        ?.map((e) => _$enumDecodeNullable(_$GroupPermissionEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupID': instance.groupID,
      'name': instance.name,
      'description': instance.description,
      'emailList': instance.emailList,
      'maxMemberCount': instance.maxMemberCount,
      'memberIDs': instance.memberIDs,
      'permissions': instance.permissions
          ?.map((e) => _$GroupPermissionEnumMap[e])
          ?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$GroupPermissionEnumMap = {
  GroupPermission.createAllTask: 'createAllTask',
  GroupPermission.readAllTask: 'readAllTask',
  GroupPermission.editAllTask: 'editAllTask',
  GroupPermission.createAgendaTask: 'createAgendaTask',
  GroupPermission.readAgendaTask: 'readAgendaTask',
  GroupPermission.editAgendaTask: 'editAgendaTask',
  GroupPermission.createTimetableTask: 'createTimetableTask',
  GroupPermission.readTimetableTask: 'readTimetableTask',
  GroupPermission.editTimetableTask: 'editTimetableTask',
  GroupPermission.createJanitorTask: 'createJanitorTask',
  GroupPermission.readJanitorTask: 'readJanitorTask',
  GroupPermission.editJanitorTask: 'editJanitorTask',
  GroupPermission.createReservationTask: 'createReservationTask',
  GroupPermission.readReservationTask: 'readReservationTask',
  GroupPermission.editReservationTask: 'editReservationTask',
  GroupPermission.createCleaningTask: 'createCleaningTask',
  GroupPermission.readCleaningTask: 'readCleaningTask',
  GroupPermission.editCleaningTask: 'editCleaningTask',
  GroupPermission.createBookloanTask: 'createBookloanTask',
  GroupPermission.readBookloanTask: 'readBookloanTask',
  GroupPermission.editBookloanTask: 'editBookloanTask',
  GroupPermission.createGroups: 'createGroups',
  GroupPermission.readGroups: 'readGroups',
  GroupPermission.editGroups: 'editGroups',
  GroupPermission.createUsers: 'createUsers',
  GroupPermission.readUsers: 'readUsers',
  GroupPermission.editUsers: 'editUsers',
};

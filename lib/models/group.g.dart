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
  GroupPermission.CAN_CREATE_ALL_TASK: 'createAllTask',
  GroupPermission.CAN_READ_ALL_TASK: 'readAllTask',
  GroupPermission.CAN_EDIT_ALL_TASK: 'editAllTask',
  GroupPermission.CAN_CREATE_AGENDA_TASK: 'createAgendaTask',
  GroupPermission.CAN_READ_AGENDA_TASK: 'readAgendaTask',
  GroupPermission.CAN_EDIT_AGENDA_TASK: 'editAgendaTask',
  GroupPermission.CAN_CREATE_TIMETABLE_TASK: 'createTimetableTask',
  GroupPermission.CAN_READ_TIMETABLE_TASK: 'readTimetableTask',
  GroupPermission.CAN_EDIT_TIMETABLE_TASK: 'editTimetableTask',
  GroupPermission.CAN_CREATE_JANITOR_TASK: 'createJanitorTask',
  GroupPermission.CAN_READ_JANITOR_TASK: 'readJanitorTask',
  GroupPermission.CAN_EDIT_JANITOR_TASK: 'editJanitorTask',
  GroupPermission.CAN_CREATE_RESERVATION_TASK: 'createReservationTask',
  GroupPermission.CAN_READ_RESERVATION_TASK: 'readReservationTask',
  GroupPermission.CAN_EDIT_RESERVATION_TASK: 'editReservationTask',
  GroupPermission.CAN_CREATE_CLEANING_TASK: 'createCleaningTask',
  GroupPermission.CAN_READ_CLEANING_TASK: 'readCleaningTask',
  GroupPermission.CAN_EDIT_CLEANING_TASK: 'editCleaningTask',
  GroupPermission.CAN_CREATE_BOOKLOAN_TASK: 'createBookloanTask',
  GroupPermission.CAN_READ_BOOKLOAN_TASK: 'readBookloanTask',
  GroupPermission.CAN_EDIT_BOOKLOAN_TASK: 'editBookloanTask',
  GroupPermission.CAN_CREATE_GROUPS: 'createGroups',
  GroupPermission.CAN_READ_GROUPS: 'readGroups',
  GroupPermission.CAN_EDIT_GROUPS: 'editGroups',
  GroupPermission.CAN_CREATE_USERS: 'createUsers',
  GroupPermission.CAN_READ_USERS: 'readUsers',
  GroupPermission.CAN_EDIT_USERS: 'editUsers',
};

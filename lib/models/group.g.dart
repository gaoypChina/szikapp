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
    maxMemberCount: json['max_member_count'] as int,
    permissions: (json['permissions'] as List<dynamic>?)
        ?.map((e) => _$enumDecode(_$PermissionEnumMap, e))
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
      'max_member_count': instance.maxMemberCount,
      'permissions':
          instance.permissions?.map((e) => _$PermissionEnumMap[e]).toList(),
      'last_update': instance.lastUpdate.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PermissionEnumMap = {
  Permission.pollView: 'pollView',
  Permission.pollCreate: 'pollCreate',
  Permission.pollEdit: 'pollEdit',
  Permission.pollDeleteAnswer: 'pollDeleteAnswer',
  Permission.pollSendAnswer: 'pollSendAnswer',
  Permission.pollSendNotification: 'pollSendNotification',
  Permission.pollResultsView: 'pollResultsView',
  Permission.pollResultsExport: 'pollResultsExport',
  Permission.cleaningTaskView: 'cleaningTaskView',
  Permission.cleaningPeriodCreate: 'cleaningPeriodCreate',
  Permission.cleaningPeriodEdit: 'cleaningPeriodEdit',
  Permission.cleaningTaskAssign: 'cleaningTaskAssign',
  Permission.cleaningTaskReserve: 'cleaningTaskReserve',
  Permission.cleaningTaskMissReport: 'cleaningTaskMissReport',
  Permission.cleaningExchangeOffer: 'cleaningExchangeOffer',
  Permission.cleaningExchangeAccept: 'cleaningExchangeAccept',
  Permission.cleaningExchangeReject: 'cleaningExchangeReject',
  Permission.janitorTaskView: 'janitorTaskView',
  Permission.janitorTaskCreate: 'janitorTaskCreate',
  Permission.janitorTaskEdit: 'janitorTaskEdit',
  Permission.janitorTaskStatusUpdate: 'janitorTaskStatusUpdate',
  Permission.janitorTaskSolutionAccept: 'janitorTaskSolutionAccept',
  Permission.reservationView: 'reservationView',
  Permission.reservationPlaceCreate: 'reservationPlaceCreate',
  Permission.reservationZoomCreate: 'reservationZoomCreate',
  Permission.reservationEdit: 'reservationEdit',
  Permission.contactsView: 'contactsView',
  Permission.contactsCreate: 'contactsCreate',
  Permission.contactsEdit: 'contactsEdit',
  Permission.userCreate: 'userCreate',
  Permission.userEdit: 'userEdit',
  Permission.userGroupsModify: 'userGroupsModify',
  Permission.groupCreate: 'groupCreate',
  Permission.groupEdit: 'groupEdit',
  Permission.groupPermissionsModify: 'groupPermissionsModify',
  Permission.resourceCreate: 'resourceCreate',
  Permission.resourceEdit: 'resourceEdit',
};

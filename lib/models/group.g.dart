// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      email: json['email'] as String?,
      memberIDs: (json['member_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxMemberCount: json['max_member_count'] as int? ?? 999,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PermissionEnumMap, e))
              .toList() ??
          const [],
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'email': instance.email,
      'member_ids': instance.memberIDs,
      'max_member_count': instance.maxMemberCount,
      'permissions':
          instance.permissions.map((e) => _$PermissionEnumMap[e]).toList(),
      'last_update': instance.lastUpdate.toIso8601String(),
    };

const _$PermissionEnumMap = {
  Permission.pollView: 'pollView',
  Permission.pollCreate: 'pollCreate',
  Permission.pollEdit: 'pollEdit',
  Permission.pollDeleteAnswer: 'pollDeleteAnswer',
  Permission.pollSendAnswer: 'pollSendAnswer',
  Permission.pollSendNotification: 'pollSendNotification',
  Permission.pollResultsView: 'pollResultsView',
  Permission.pollResultsExport: 'pollResultsExport',
  Permission.cleaningView: 'cleaningView',
  Permission.cleaningTaskView: 'cleaningTaskView',
  Permission.cleaningPeriodCreate: 'cleaningPeriodCreate',
  Permission.cleaningPeriodEdit: 'cleaningPeriodEdit',
  Permission.cleaningTaskAssign: 'cleaningTaskAssign',
  Permission.cleaningTaskReserve: 'cleaningTaskReserve',
  Permission.cleaningTaskMissReport: 'cleaningTaskMissReport',
  Permission.cleaningExchangeOffer: 'cleaningExchangeOffer',
  Permission.cleaningExchangeAccept: 'cleaningExchangeAccept',
  Permission.cleaningExchangeReject: 'cleaningExchangeReject',
  Permission.janitorView: 'janitorView',
  Permission.janitorTaskView: 'janitorTaskView',
  Permission.janitorTaskCreate: 'janitorTaskCreate',
  Permission.janitorTaskEdit: 'janitorTaskEdit',
  Permission.janitorTaskStatusUpdate: 'janitorTaskStatusUpdate',
  Permission.janitorTaskSolutionAccept: 'janitorTaskSolutionAccept',
  Permission.reservationView: 'reservationView',
  Permission.reservationPlaceCreate: 'reservationPlaceCreate',
  Permission.reservationZoomCreate: 'reservationZoomCreate',
  Permission.reservationBoardgameCreate: 'reservationBoardgameCreate',
  Permission.reservationEdit: 'reservationEdit',
  Permission.contactsView: 'contactsView',
  Permission.contactsCreate: 'contactsCreate',
  Permission.contactsEdit: 'contactsEdit',
  Permission.documentsView: 'documentsView',
  Permission.documentsCreate: 'documentsCreate',
  Permission.documentsEdit: 'documentsEdit',
  Permission.helpMeView: 'helpMeView',
  Permission.beerWithMeView: 'beerWithMeView',
  Permission.spiritualView: 'spiritualView',
  Permission.formsView: 'formsView',
  Permission.bookLoanView: 'bookLoanView',
  Permission.profileView: 'profileView',
  Permission.profileEdit: 'profileEdit',
  Permission.userCreate: 'userCreate',
  Permission.userEdit: 'userEdit',
  Permission.userGroupsModify: 'userGroupsModify',
  Permission.groupView: 'groupView',
  Permission.groupCreate: 'groupCreate',
  Permission.groupEdit: 'groupEdit',
  Permission.groupPermissionsModify: 'groupPermissionsModify',
  Permission.resourceView: 'resourceView',
  Permission.resourceCreate: 'resourceCreate',
  Permission.resourceEdit: 'resourceEdit',
  Permission.admin: 'admin',
};

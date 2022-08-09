// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      nick: json['nick'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      secondaryPhone: json['secondaryPhone'] as String?,
      preferences: json['preferences'] == null
          ? null
          : Preferences.fromJson(json['preferences'] as Map<String, dynamic>),
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PermissionEnumMap, e))
              .toList() ??
          const [],
      groupIDs: (json['group_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastUpdate: DateTime.parse(json['last_update'] as String),
    )..profilePicture = json['profile_picture'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profile_picture': instance.profilePicture,
      'nick': instance.nick,
      'preferences': instance.preferences?.toJson(),
      'group_ids': instance.groupIDs,
      'permissions':
          instance.permissions.map((e) => _$PermissionEnumMap[e]).toList(),
      'last_update': instance.lastUpdate.toIso8601String(),
      'birthday': instance.birthday?.toIso8601String(),
      'phone': instance.phone,
      'secondaryPhone': instance.secondaryPhone,
    };

const _$PermissionEnumMap = {
  Permission.admin: 'admin',
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
  Permission.reservationAccountCreate: 'reservationAccountCreate',
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
  Permission.calendarView: 'calendarView',
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
};

import '../utils/utils.dart';

///Az applikációban előforduló jogosultságokat reprezentáló enum típus.
enum Permission {
  admin,

  pollView,
  pollCreate,
  pollEdit,
  pollDeleteAnswer,
  pollSendAnswer,
  pollSendNotification,
  pollResultsView,
  pollResultsExport,

  cleaningView,
  cleaningTaskView,
  cleaningPeriodCreate,
  cleaningPeriodEdit,
  cleaningTaskAssign,
  cleaningTaskReserve,
  cleaningTaskMissReport,
  cleaningExchangeOffer,
  cleaningExchangeAccept,
  cleaningExchangeReject,

  janitorView,
  janitorTaskView,
  janitorTaskCreate,
  janitorTaskEdit,
  janitorTaskStatusUpdate,
  janitorTaskSolutionAccept,

  reservationView,
  reservationPlaceCreate,
  reservationAccountCreate,
  reservationBoardgameCreate,
  reservationEdit,

  contactsView,
  contactsCreate,
  contactsEdit,

  documentsView,
  documentsCreate,
  documentsEdit,

  helpMeView,

  beerWithMeView,

  spiritualView,

  formsView,

  bookLoanView,

  calendarView,

  passwordsView,

  profileView,
  profileEdit,
  userCreate,
  userEdit,
  userGroupsModify,

  groupView,
  groupCreate,
  groupEdit,
  groupPermissionsModify,

  resourceView,
  resourceCreate,
  resourceEdit;

  @override
  String toString() => name;

  static Permission decodePermission(dynamic source) {
    for (var permission in Permission.values) {
      if (permission.toString() == source.toString()) {
        return permission;
      }
    }
    throw NotValidPermissionException(
      '`$source` is not one of the supported values.',
    );
  }

  static List<Permission> permissionsFromJson(List<dynamic> rawPermissions) {
    var permissions = <Permission>[];
    for (var rawPermission in rawPermissions) {
      try {
        permissions.add(Permission.decodePermission(rawPermission));
      } on NotValidPermissionException catch (_) {
        continue;
      }
    }
    return permissions;
  }
}

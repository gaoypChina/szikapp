///Az applikációban előforduló jogosultságokat reprezentáló enum típus.
enum Permission {
  pollView,
  pollCreate,
  pollEdit,
  pollDeleteAnswer,
  pollSendAnswer,
  pollSendNotification,
  pollResultsView,
  pollResultsExport,

  cleaningTaskView,
  cleaningPeriodCreate,
  cleaningPeriodEdit,
  cleaningTaskAssign,
  cleaningTaskReserve,
  cleaningTaskMissReport,
  cleaningExchangeOffer,
  cleaningExchangeAccept,
  cleaningExchangeReject,

  janitorTaskView,
  janitorTaskCreate,
  janitorTaskEdit,
  janitorTaskStatusUpdate,
  janitorTaskSolutionAccept,

  reservationView,
  reservationPlaceCreate,
  reservationZoomCreate,
  reservationEdit,

  contactsView,
  contactsCreate,
  contactsEdit,

  userCreate,
  userEdit,
  userGroupsModify,

  groupCreate,
  groupEdit,
  groupPermissionsModify,

  resourceCreate,
  resourceEdit,
}

extension PermissionToString on Permission {
  String toShortString() {
    return toString().split('.').last;
  }
}

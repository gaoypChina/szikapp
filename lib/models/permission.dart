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
  reservationZoomCreate,
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
  resourceEdit,

  admin,
}

extension PermissionToString on Permission {
  String toShortString() {
    return toString().split('.').last;
  }
}

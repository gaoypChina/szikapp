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
}

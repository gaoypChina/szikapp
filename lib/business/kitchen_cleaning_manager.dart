import 'package:flutter/material.dart';

import '../models/models.dart';
import '../utils/utils.dart';

///Konyhatakarítás funkció logikai működését megvalósító singleton
///háttérosztály.
class KitchenCleaningManager extends ChangeNotifier {
  ///Csoportok, aminek a konyhatakát végeznie kell
  CleaningParticipants _participantData = CleaningParticipants(
    groupIDs: [],
    blackListGroup: [],
    blackListUser: [],
    whiteListUser: [],
    lastUpdate: DateTime.now(),
  );

  ///Konyhatakarítási feladatok listája
  List<CleaningTask> _cleaningTasks = [];

  ///Konyhatakarítás-cserék listája
  List<CleaningExchange> _cleaningExchanges = [];

  ///Konyhatakarítási periódusok listája
  List<CleaningPeriod> _cleaningPeriods = [];

  bool _adminEdit = false;

  ///Singleton osztálypéldány
  static final KitchenCleaningManager _instance =
      KitchenCleaningManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory KitchenCleaningManager() => _instance;

  ///Privát kontruktor, ami inicializálja a [cleaningPeriods] paramétert.
  KitchenCleaningManager._privateConstructor();

  CleaningParticipants get cleaningParticipants => _participantData;
  List<CleaningTask> get tasks => List.unmodifiable(_cleaningTasks);
  List<CleaningExchange> get exchanges => List.unmodifiable(_cleaningExchanges);
  List<CleaningPeriod> get periods => List.unmodifiable(_cleaningPeriods);

  bool get isAdminEditing => _adminEdit;

  void performBackButtonPressed() {
    _adminEdit = false;
    notifyListeners();
  }

  void adminEdit() {
    _adminEdit = true;
    notifyListeners();
  }

  bool hasCurrentPeriod() => periods
      .any((period) => DateTime.now().isInInterval(period.start, period.end));
  CleaningPeriod getCurrentPeriod() => periods.firstWhere(
      (period) => DateTime.now().isInInterval(period.start, period.end));

  bool hasOpenPeriod() =>
      periods.any((period) => period.start.isAfter(DateTime.now()));
  CleaningPeriod getOpenPeriod() =>
      periods.firstWhere((period) => period.start.isAfter(DateTime.now()));

  bool userHasActiveExchange({required String userID}) =>
      exchanges.any((exchange) =>
          exchange.status != TaskStatus.approved &&
          exchange.initiatorID == userID);

  ///Checks whether user has applied task for the current period
  bool userHasAppliedCurrentTask({required String userID}) {
    if (!hasCurrentPeriod()) return false;
    var currentPeriod = getCurrentPeriod();
    return tasks.any((task) =>
        task.participantIDs.contains(userID) &&
        task.start.isInInterval(currentPeriod.start, currentPeriod.end));
  }

  ///User has a task in the current period that was not due yet
  bool usersAppliedCurrentTaskIsNotInThePast({required String userID}) {
    if (!hasCurrentPeriod()) return false;
    var currentPeriod = getCurrentPeriod();
    return tasks.any((task) =>
        task.participantIDs.contains(userID) &&
        task.start.isInInterval(DateTime.now(), currentPeriod.end));
  }

  ///Returns the applied task for the user from the current period
  CleaningTask getUserCurrentTask({required String userID}) {
    var currentPeriod = getCurrentPeriod();
    return tasks.firstWhere((task) =>
        task.participantIDs.contains(userID) &&
        task.start.isInInterval(currentPeriod.start, currentPeriod.end));
  }

  ///Returns all tasks of the current period
  List<CleaningTask> getCurrentTasks() {
    if (!hasCurrentPeriod()) return [];
    var currentPeriod = getCurrentPeriod();
    return tasks
        .where((task) =>
            task.start.isInInterval(currentPeriod.start, currentPeriod.end))
        .toList();
  }

  ///Checks whether user has applied task for the next period
  bool userHasAppliedOpenTask({required String userID}) {
    if (!hasOpenPeriod()) return false;
    var openPeriod = getOpenPeriod();
    return tasks.any((task) =>
        task.participantIDs.contains(userID) &&
        task.start.isInInterval(openPeriod.start, openPeriod.end));
  }

  ///Returns the applied task for the user from the open period
  CleaningTask getUserOpenTask({required String userID}) {
    var openPeriod = getOpenPeriod();
    return tasks.firstWhere((task) =>
        task.participantIDs.contains(userID) &&
        task.start.isInInterval(openPeriod.start, openPeriod.end));
  }

  ///Returns all tasks of the next period
  List<CleaningTask> getOpenTasks() {
    if (!hasOpenPeriod()) return [];
    var openPeriod = getOpenPeriod();
    return tasks
        .where(
            (task) => task.start.isInInterval(openPeriod.start, openPeriod.end))
        .toList();
  }

  ///Checks if there is a task that was due yesterday.
  bool hasYesterdayTask() {
    var yesterday = DateTime.now().subtract(const Duration(days: 1));
    return tasks.any((task) => task.start.isSameDate(yesterday));
  }

  /// Returns yesterday's cleaning task.
  CleaningTask getYesterdayTask() {
    var yesterday = DateTime.now().subtract(const Duration(days: 1));
    return tasks.firstWhere((task) => task.start.isSameDate(yesterday));
  }

  List<String> getParticipantIDs(List<Group> groups) {
    var participantIDs = <String>[];
    for (var groupID in _participantData.groupIDs) {
      participantIDs.addAll(
        groups.firstWhere((group) => group.id == groupID).memberIDs,
      );
    }
    participantIDs = participantIDs.toSet().toList();
    for (var groupID in _participantData.blackListGroup) {
      participantIDs.removeWhere(
        (participantID) => groups
            .firstWhere((group) => group.id == groupID)
            .memberIDs
            .contains(participantID),
      );
    }
    participantIDs.removeWhere((participantID) =>
        _participantData.blackListUser.contains(participantID));
    participantIDs.addAll(_participantData.whiteListUser);
    participantIDs = participantIDs.toSet().toList();
    return participantIDs;
  }

  ///Konyhatakarítási feladatok frissítése. A függvény lekéri a szerverről a
  ///legfrissebb feladatlistát. Alapértelmezetten az aktuális napot megelőző
  ///naptól a folyó konhatakarítási periódus végéig szinkronizál.
  Future<void> refreshTasks({DateTime? start, DateTime? end}) async {
    if (_cleaningPeriods.isEmpty) return;
    start ??= _cleaningPeriods.first.start.subtract(const Duration(days: 1));
    end ??= _cleaningPeriods.last.end;

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };

    try {
      var io = IO();
      _cleaningTasks = await io.getCleaningTask(parameters: parameter);
    } on IOException {
      _cleaningTasks = [];
    }
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb
  ///konyhatakarítás-csere listát. Alapértelmezetten csak a nyitott cseréket
  ///szinkronizálja az aktuális periódusból.
  Future<void> refreshExchanges({TaskStatus? status, DateTime? start}) async {
    try {
      var io = IO();
      var parameters = <String, String>{};
      start ??= hasCurrentPeriod() ? getCurrentPeriod().start : DateTime.now();
      parameters = {
        'start': start.toIso8601String(),
        if (status != null) 'status': status.toString()
      };

      _cleaningExchanges = await io.getCleaningExchange(parameters: parameters);
    } on IOException {
      _cleaningExchanges = [];
    }
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb konyhatakarítási
  ///periódus listát. Alapértelmezetten csak a jelenleg aktív periódust
  ///szinkronizálja.
  Future<void> refreshPeriods({DateTime? start, bool isLive = true}) async {
    start ??= DateTime.now();

    var parameter = {
      'start': start.toIso8601String(),
      'is_live': isLive.toString(),
    };

    try {
      var io = IO();
      _cleaningPeriods = await io.getCleaningPeriod(parameters: parameter);
    } on IOException {
      _cleaningPeriods = [];
    }
  }

  Future<void> refreshCleaningParticipants() async {
    try {
      var io = IO();
      _participantData = await io.getCleaningParticipants();
    } on IOException {
      return;
    }
  }

  Future<void> editCleaningParticipants(
      {required CleaningParticipants newParticipantData}) async {
    var io = IO();
    await io.putCleaningParticipants(data: newParticipantData);
    _participantData = newParticipantData;
    notifyListeners();
  }

  Future<void> autoAssignTasks() async {
    var io = IO();
    await io.getCleaningAutoAssign();
  }

  ///Elmaradt konyhatakarítás jelentése.
  Future<bool> reportInsufficiency({required CleaningTask task}) async {
    var io = IO();
    task.status = TaskStatus.awaitingApproval;
    var parameter = {'id': task.id};
    await io.putCleaningTask(data: task, parameters: parameter);
    _cleaningTasks.removeWhere((cleaningTask) => cleaningTask.id == task.id);
    _cleaningTasks.add(task);
    return true;
  }

  ///Új konyhatakarítási periódus hozzáadása. A függvény feltölti a szerverre az
  ///új periódust, ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja
  ///a listához.
  Future<bool> createCleaningPeriod({required CleaningPeriod period}) async {
    var io = IO();
    await io.postCleaningPeriod(data: period);
    _cleaningPeriods.add(period);
    return true;
  }

  ///Periódus szerkesztése. A függvény feltölti a szerverre a módosított
  ///periódust, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editCleaningPeriod({required CleaningPeriod period}) async {
    var io = IO();
    var parameter = {'id': period.id};
    await io.putCleaningPeriod(data: period, parameters: parameter);
    _cleaningPeriods
        .removeWhere((cleaningPeriod) => cleaningPeriod.id == period.id);
    _cleaningPeriods.add(period);
    return true;
  }

  ///Feladat szerkesztése. A függvény feltölti a szerverre a módosított
  ///feladatot, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editCleaningTask({required CleaningTask task}) async {
    var io = IO();
    var parameter = {'id': task.id};
    await io.putCleaningTask(data: task, parameters: parameter);
    _cleaningTasks.removeWhere((cleaningTask) => cleaningTask.id == task.id);
    _cleaningTasks.add(task);
    return true;
  }

  ///Új csere hozzáadása. A függvény feltölti a szerverre az új cserét,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> createCleaningExchangeOccasion(
      {required CleaningExchange exchange}) async {
    var io = IO();
    await io.postCleaningExchange(data: exchange);
    _cleaningExchanges.add(exchange);
    return true;
  }

  ///Cserealkalom felajánlása.
  Future<bool> offerCleaningExchangeOccasion(
      {required CleaningExchange exchange, required String replaceUid}) async {
    var io = IO();
    var parameters = {'exchangeId': exchange.id, 'replacementId': replaceUid};
    await io.getCleaningExchangeOffer(
      parameters: parameters,
      lastUpdate: exchange.lastUpdate,
    );
    return true;
  }

  ///Cserealkalom elfogadása.
  Future<bool> acceptCleaningExchangeOccasion(
      {required CleaningExchange exchange, required String replaceUid}) async {
    var io = IO();
    var parameters = {'exchangeId': exchange.id, 'replacementId': replaceUid};
    await io.getCleaningExchangeAccept(
      parameters: parameters,
      lastUpdate: exchange.lastUpdate,
    );
    return true;
  }

  ///Cserealkalom visszavonása.
  Future<bool> withdrawCleaningExchangeOccasion(
      {required CleaningExchange exchange, required String replaceUid}) async {
    var io = IO();
    var parameters = {'exchangeId': exchange.id, 'replacementId': replaceUid};
    await io.getCleaningExchangeWithdraw(
      parameters: parameters,
      lastUpdate: exchange.lastUpdate,
    );
    return true;
  }

  ///Cserealkalom visszautasítása.
  Future<bool> rejectCleaningExchangeOccasion(
      {required CleaningExchange exchange, required String replaceUid}) async {
    var io = IO();
    var parameters = {'exchangeId': exchange.id, 'replacementId': replaceUid};
    await io.getCleaningExchangeReject(
      parameters: parameters,
      lastUpdate: exchange.lastUpdate,
    );
    return true;
  }

  ///Cserealkalom törlése.
  Future<bool> deleteCleaningExchangeOccasion(
      {required CleaningExchange exchange}) async {
    var io = IO();
    var parameter = {'id': exchange.id};
    await io.deleteCleaningExchange(
        parameters: parameter, lastUpdate: exchange.lastUpdate);
    _cleaningExchanges.remove(exchange);
    return true;
  }
}

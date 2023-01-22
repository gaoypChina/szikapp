import 'package:flutter/material.dart';

import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/tasks.dart';
import '../utils/utils.dart';

///Konyhatakarítás funkció logikai működését megvalósító singleton
///háttérosztály.
class KitchenCleaningManager extends ChangeNotifier {
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

  CleaningPeriod getCurrentPeriod() => periods.firstWhere(
      (element) => DateTime.now().isInInterval(element.start, element.end));

  bool hasOpenPeriod() =>
      periods.any((element) => element.start.isAfter(DateTime.now()));
  CleaningPeriod getOpenPeriod() =>
      periods.firstWhere((element) => element.start.isAfter(DateTime.now()));

  bool userHasActiveExchange(String userID) =>
      exchanges.any((element) => element.initiatorID == userID);

  ///Checks whether user has applied task for the current period
  bool userHasAppliedTask(String userID) {
    var currentPeriod = getCurrentPeriod();
    return tasks.any((element) =>
        element.participantIDs.contains(userID) &&
        element.start.isInInterval(currentPeriod.start, currentPeriod.end));
  }

  ///Checks whether user has applied task for the next period
  bool userHasAppliedOpenTask(String userID) {
    var openPeriod = getOpenPeriod();
    return tasks.any((element) =>
        element.participantIDs.contains(userID) &&
        element.start.isInInterval(openPeriod.start, openPeriod.end));
  }

  ///Returns the applied task for the user from the current period
  CleaningTask getUserTask(String userID) {
    var currentPeriod = getCurrentPeriod();
    return tasks.firstWhere((element) =>
        element.participantIDs.contains(userID) &&
        element.start.isInInterval(currentPeriod.start, currentPeriod.end));
  }

  ///Returns all tasks of the current period
  List<CleaningTask> getCurrentTasks() {
    var currentPeriod = getCurrentPeriod();
    return tasks
        .where((element) =>
            element.start.isInInterval(currentPeriod.start, currentPeriod.end))
        .toList();
  }

  ///Returns all tasks of the next period
  List<CleaningTask> getOpenTasks() {
    var openPeriod = getOpenPeriod();
    return tasks
        .where((element) =>
            element.start.isInInterval(openPeriod.start, openPeriod.end))
        .toList();
  }

  ///Konyhatakarítási feladatok frissítése. A függvény lekéri a szerverről a
  ///legfrissebb feladatlistát. Alapértelmezetten az aktuális napot megelőző
  ///naptól a folyó konhatakarítási periódus végéig szinkronizál.
  Future<void> refreshTasks({DateTime? start, DateTime? end}) async {
    if (_cleaningPeriods.isEmpty) refreshPeriods();

    start ??= _cleaningPeriods.first.start;
    end ??= _cleaningPeriods.last.end;

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };

    try {
      var io = IO();
      _cleaningTasks = await io.getCleaning(parameter);
    } on IONotModifiedException {
      _cleaningTasks = [];
    }
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb
  ///konyhatakarítás-csere listát. Alapértelmezetten csak a nyitott cseréket
  ///szinkronizálja.
  Future<void> refreshExchanges({bool? approved}) async {
    try {
      var io = IO();
      var parameter = <String, String>{};
      if (approved != null) {
        parameter.addEntries({'approved': approved.toString()}.entries);
      }
      _cleaningExchanges = await io.getCleaningExchange(parameter);
    } on IONotModifiedException {
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
      _cleaningPeriods = await io.getCleaningPeriod(parameter);
    } on IONotModifiedException {
      _cleaningPeriods = [];
    }
  }

  ///Elmaradt konyhatakarítás jelentése.
  Future<bool> reportInsufficiency(CleaningTask task) async {
    var io = IO();
    task.status = TaskStatus.refused;
    var parameter = {'id': task.id};
    await io.putCleaning(task, parameter);
    _cleaningTasks.removeWhere((element) => element.id == task.id);
    _cleaningTasks.add(task);
    return true;
  }

  ///Új konyhatakarítási periódus hozzáadása. A függvény feltölti a szerverre az
  ///új periódust, ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja
  ///a listához.
  Future<bool> createCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    await io.postCleaningPeriod(period);
    _cleaningPeriods.add(period);
    return true;
  }

  ///Periódus szerkesztése. A függvény feltölti a szerverre a módosított
  ///periódust, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    var parameter = {'id': period.id};
    await io.patchCleaningPeriod(period, parameter);
    _cleaningPeriods.removeWhere((element) => element.id == period.id);
    _cleaningPeriods.add(period);
    return true;
  }

  ///Feladat szerkesztése. A függvény feltölti a szerverre a módosított
  ///feladatot, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editCleaningTask(CleaningTask task) async {
    var io = IO();
    var parameter = {'id': task.id};
    await io.putCleaning(task, parameter);
    _cleaningTasks.removeWhere((element) => element.id == task.id);
    _cleaningTasks.add(task);
    return true;
  }

  ///Új csere hozzáadása. A függvény feltölti a szerverre az új cserét,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> createCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    await io.postCleaningExchange(exchange);
    _cleaningExchanges.add(exchange);
    return true;
  }

  ///Cserealkalom felajánlása.
  Future<bool> offerCleaningExchangeOccasion(
      CleaningExchange exchange, String replaceUid) async {
    var io = IO();
    var parameter = {'id': exchange.id};
    await io.patchCleaningExchange(parameter, exchange.lastUpdate, replaceUid);
    return true;
  }

  ///Cserealkalom elfogadása.
  Future<bool> acceptCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.id};
    await io.patchCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }

  ///Cserealkalom visszavonása.
  Future<bool> withdrawCleaningExchangeOccasion(
      CleaningExchange exchange, String replaceUid) async {
    var io = IO();
    var parameter = {'id': exchange.id};
    await io.putCleaningExchange(parameter, exchange.lastUpdate, replaceUid);
    return true;
  }

  ///Cserealkalom visszautasítása.
  Future<bool> rejectCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.id};
    await io.putCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }

  ///Cserealkalom törlése.
  Future<bool> deleteCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.id};
    await io.deleteCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }
}

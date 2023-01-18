import 'package:flutter/material.dart';

import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/tasks.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

///Konyhatakarítás funkció logikai működését megvalósító singleton
///háttérosztály.
class KitchenCleaningManager extends ChangeNotifier {
  ///Konyhatakarítási feladatok listája
  List<CleaningTask> _cleaningTasks = [];
  int _selectedTask = -1;

  ///Konyhatakarítás-cserék listája
  List<CleaningExchange> _cleaningExchanges = [];
  int _selectedExchange = -1;

  ///Konyhatakarítási periódusok listája
  List<CleaningPeriod> _cleaningPeriods = [];
  int _selectedPeriod = -1;

  bool _adminEdit = false;

  int get selectedTaskIndex => _selectedTask;
  CleaningTask? get selectedTask =>
      _selectedTask != -1 ? _cleaningTasks[_selectedTask] : null;

  int get selectedExchangeIndex => _selectedTask;
  CleaningExchange? get selectedExchange =>
      _selectedExchange != -1 ? _cleaningExchanges[_selectedExchange] : null;

  int get selectedPeriodIndex => _selectedTask;
  CleaningPeriod? get selectedPeriod =>
      _selectedPeriod != -1 ? _cleaningPeriods[_selectedPeriod] : null;

  bool get isAdminEditing => _adminEdit;

  int indexOfTask(CleaningTask task) {
    for (var e in _cleaningTasks) {
      if (e.id == task.id) return _cleaningTasks.indexOf(e);
    }
    return -1;
  }

  int indexOfExchange(CleaningExchange exchange) {
    for (var e in _cleaningExchanges) {
      if (e.id == exchange.id) return _cleaningExchanges.indexOf(e);
    }
    return -1;
  }

  int indexOfPeriod(CleaningPeriod period) {
    for (var e in _cleaningPeriods) {
      if (e.id == period.id) return _cleaningPeriods.indexOf(e);
    }
    return -1;
  }

  void performBackButtonPressed() {
    _adminEdit = false;
    notifyListeners();
  }

  void adminEdit() {
    _adminEdit = true;
    notifyListeners();
  }

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
  Future<void> refreshExchanges({bool approved = false}) async {
    try {
      var io = IO();
      var parameter = {'approved': approved.toString()};
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

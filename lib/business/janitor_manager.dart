import 'package:flutter/material.dart';

import '../models/tasks.dart';
import '../utils/io.dart';

///Gondnoki kérések funkció logikai működését megvalósító singleton
///háttérosztály.
class JanitorManager extends ChangeNotifier {
  ///Kéréslista
  List<JanitorTask> _tasks = [];
  int _selectedIndex = -1;
  bool _createNewTask = false;
  bool _editTask = false;
  bool _adminEditTask = false;
  bool _feedbackTask = false;

  ///Singleton osztálypéldány
  static final JanitorManager _instance = JanitorManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory JanitorManager() => _instance;

  ///Privát konstruktor, ami inicializálja a [tasks] változót.
  JanitorManager._privateConstructor();

  List<JanitorTask> get tasks => List.unmodifiable(_tasks);

  int get selectedIndex => _selectedIndex;
  JanitorTask? get selectedTask =>
      selectedIndex != -1 ? _tasks[selectedIndex] : null;
  bool get isCreatingNewTask => _createNewTask;
  bool get isEditingTask => _editTask;
  bool get isAdminEditingTask => _adminEditTask;
  bool get isGivingFeedback => _feedbackTask;

  void createNewTask() {
    _createNewTask = true;
    _editTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    notifyListeners();
  }

  void performBackButtonPressed() {
    _selectedIndex = -1;
    _createNewTask = false;
    _editTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    notifyListeners();
  }

  void editTask(int index) {
    _editTask = true;
    _selectedIndex = index;
    _createNewTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    notifyListeners();
  }

  void adminEditTask(int index) {
    _selectedIndex = index;
    _adminEditTask = true;
    _createNewTask = false;
    _editTask = false;
    _feedbackTask = false;
    notifyListeners();
  }

  void feedbackTask(int index) {
    _selectedIndex = index;
    _feedbackTask = true;
    _createNewTask = false;
    _editTask = false;
    _adminEditTask = false;
    notifyListeners();
  }

  void setSelectedJanitorTask(String id) {
    final index = _tasks.indexWhere((element) => element.id == id);
    _selectedIndex = index;
    _createNewTask = false;
    _editTask = true;
    _adminEditTask = false;
    _feedbackTask = false;
    notifyListeners();
  }

  ///Státusz szerkesztése. A függvény megváltoztatja a feladat státuszát a
  ///megadott státuszra, mely validitásának ellenőrzése szerver oldalon
  ///történik.
  Future<bool> updateStatus(TaskStatus status, JanitorTask task) async {
    var io = IO();
    var parameter = {'id': task.id};
    await io.patchJanitor(status, parameter, task.lastUpdate);

    _tasks.firstWhere((element) => element.id == task.id).status = status;
    _createNewTask = false;
    _editTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Új feladat hozzáadása. A függvény feltölti a szerverre az új feladatot,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> addTask(JanitorTask task) async {
    if (_tasks.contains(task)) return false;

    var io = IO();
    await io.postJanitor(task);

    _tasks.add(task);
    _createNewTask = false;
    _editTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Feladat szerkesztése. A függvény feltölti a szerverre a módosított
  ///feladatot, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> updateTask(JanitorTask task) async {
    var io = IO();
    var parameter = {'id': task.id};
    await io.putJanitor(task, parameter);

    _tasks.removeWhere((element) => element.id == task.id);
    _tasks.add(task);
    _createNewTask = false;
    _editTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Feladat törlése. A függvény törli a szerverről a feladatot,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deleteTask(JanitorTask task) async {
    if (!_tasks.contains(task)) return true;

    var io = IO();
    var parameter = {'id': task.id};
    await io.deleteJanitor(parameter, task.lastUpdate);

    _tasks.remove(task);
    _createNewTask = false;
    _editTask = false;
    _adminEditTask = false;
    _feedbackTask = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb feladatlistát.
  ///Alapértelmezetten az elmúlt 31 nap feladatait szinkronizálja, ám a
  ///[from] paraméter beállításával lehetőség nyílik az intervallumot szűkíteni
  ///avagy bővíteni.
  Future<void> refresh({DateTime? from}) async {
    from ??= DateTime.now().subtract(const Duration(days: 31));

    var parameter = {'from': from.toIso8601String()};

    var io = IO();
    _tasks = await io.getJanitor(parameter);
  }

  ///Szűrés. A függvény a megadott paraméterek alapján szűri a feladatlistát.
  ///Ha minden paraméter üres, a teljes listát adja vissza.
  List<JanitorTask> filter({
    List<TaskStatus> statuses = const <TaskStatus>[],
    List<String> placeIDs = const <String>[],
    String participantID = '',
  }) {
    if (placeIDs.isEmpty && statuses.isEmpty && participantID.isEmpty) {
      return tasks;
    }
    var results = <JanitorTask>[];

    //Filter by all options that are specified
    for (var task in tasks) {
      if (participantID.isNotEmpty &&
          task.participantIDs.contains(participantID)) {
        results.add(task);
      } else if (statuses.isNotEmpty && statuses.contains(task.status)) {
        results.add(task);
      } else if (placeIDs.isNotEmpty && placeIDs.contains(task.placeID)) {
        results.add(task);
      }
    }
    return List.unmodifiable(results);
  }
}

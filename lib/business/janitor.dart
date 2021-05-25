import '../models/tasks.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

///Gondnoki kérések funkció logikai működését megvalósító singleton
///háttérosztály.
class Janitor {
  ///Kéréslista
  late List<JanitorTask> tasks;

  ///Singleton osztálypéldány
  static final Janitor _instance = Janitor._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory Janitor() => _instance;

  ///Privát konstruktor, ami inicializálja a [tasks] változót.
  Janitor._privateConstructor() {
    refresh();
  }

  ///Státusz szerkesztése. A függvény megváltoztatja a feladat státuszát a
  ///megadott státuszra, mely validitásának ellenőrzése szerver oldalon
  ///történik.
  Future<bool> editStatus(TaskStatus status, JanitorTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.patchJanitor(status, parameter);

    tasks.firstWhere((element) => element.uid == task.uid).status = status;

    return true;
  }

  ///Új feladat hozzáadása. A függvény feltölti a szerverre az új feladatot,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> addTask(JanitorTask task) async {
    if (tasks.contains(task)) return false;

    var io = IO();
    await io.postJanitor(task);

    tasks.add(task);

    return true;
  }

  ///Feladat szerkesztése. A függvény feltölti a szerverre a módosított
  ///feladatot, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editTask(JanitorTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.putJanitor(task, parameter);

    tasks.removeWhere((element) => element.uid == task.uid);
    tasks.add(task);

    return true;
  }

  ///Feladat törlése. A függvény törli a szerverről a feladatot,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deleteTask(JanitorTask task) async {
    if (!tasks.contains(task)) return true;

    var io = IO();
    var parameter = {'id': task.uid};
    await io.deleteJanitor(parameter, task.lastUpdate);

    tasks.remove(task);

    return true;
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb feladatlistát.
  ///Alapértelmezetten az elmúlt 31 nap feladatait szinkronizálja, ám a
  ///[from] paraméter beállításával lehetőség nyílik az intervallumot szűkíteni
  ///avagy bővíteni.
  Future<void> refresh({DateTime? from}) async {
    try {
      from ??= DateTime.now().subtract(const Duration(days: 31));

      var parameter = {'from': from.toIso8601String()};

      var io = IO();
      tasks = await io.getJanitor(parameter);
    } on IONotModifiedException {
      //TODO hibakezelés
      tasks = <JanitorTask>[];
    }
  }

  ///Szűrés. A függvény a megadott paraméterek alapján szűri a feladatlistát.
  ///Ha minden paraméter üres, a teljes listát adja vissza.
  List<JanitorTask> filter({
    List<TaskStatus> statuses = const <TaskStatus>[],
    List<String> placeIDs = const <String>[],
    String involvedID = '',
  }) {
    if (placeIDs.isEmpty && statuses.isEmpty && involvedID.isEmpty)
      return tasks;

    var filteredJanitorTasks = <JanitorTask>[];

    //Filter by all options that are specified
    for (var task in tasks) {
      if (involvedID.isNotEmpty && task.involvedIDs!.contains(involvedID))
        filteredJanitorTasks.add(task);
      else if (statuses.isNotEmpty && statuses.contains(task.status))
        filteredJanitorTasks.add(task);
      else if (placeIDs.isNotEmpty && placeIDs.contains(task.placeID))
        filteredJanitorTasks.add(task);
    }
    return filteredJanitorTasks;
  }
}

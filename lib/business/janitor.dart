import '../models/tasks.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

class Janitor {
  late List<JanitorTask> janitorTasks;

  static final Janitor _instance = Janitor._privateConstructor();
  factory Janitor() => _instance;
  Janitor._privateConstructor() {
    refresh();
  }

  Future<bool> editStatus(TaskStatus status, JanitorTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.patchJanitor(status, parameter);

    janitorTasks.firstWhere((element) => element.uid == task.uid).status =
        status;

    return true;
  }

  Future<bool> addTask(JanitorTask task) async {
    if (janitorTasks.contains(task)) return false;
    janitorTasks.add(task);

    var io = IO();
    await io.postJanitor(task);

    return true;
  }

  Future<bool> editTask(JanitorTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.putJanitor(task, parameter);

    janitorTasks.removeWhere((element) => element.uid == task.uid);
    janitorTasks.add(task);

    return true;
  }

  Future<bool> deleteTask(JanitorTask task) async {
    if (!janitorTasks.contains(task)) return false;

    var io = IO();
    var parameter = {'id': task.uid};
    await io.deleteJanitor(parameter, task.lastUpdate);

    janitorTasks.remove(task);

    return true;
  }

  Future<void> refresh({DateTime? from}) async {
    try {
      from ??= DateTime.now().subtract(const Duration(days: 31));
      var parameter = {'from': from.toIso8601String()};
      var io = IO();
      janitorTasks = await io.getJanitor(parameter);
    } on IONotModifiedException {
      janitorTasks = <JanitorTask>[];
    }
  }

  List<JanitorTask> filter({
    List<TaskStatus> statuses = const <TaskStatus>[],
    List<String> roomIDs = const <String>[],
    String involvedID = '',
  }) {
    if (roomIDs.isEmpty && statuses.isEmpty && involvedID.isEmpty)
      return janitorTasks;

    var filteredJanitorTasks = <JanitorTask>[];

    //Filter by all options that are specified
    for (var task in janitorTasks) {
      if (involvedID.isNotEmpty && task.involvedIDs!.contains(involvedID))
        filteredJanitorTasks.add(task);
      else if (statuses.isNotEmpty && statuses.contains(task.status))
        filteredJanitorTasks.add(task);
      else if (roomIDs.isNotEmpty && roomIDs.contains(task.placeID))
        filteredJanitorTasks.add(task);
    }
    return filteredJanitorTasks;
  }
}

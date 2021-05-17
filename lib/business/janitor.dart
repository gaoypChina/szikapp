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

  Future<bool> editStatus(TaskStatus status, int taskIndex) async {
    if (taskIndex >= janitorTasks.length || taskIndex < 0) return false;

    var io = IO();
    var parameter = {'id': janitorTasks[taskIndex].uid};
    await io.patchJanitor(status, parameter);

    janitorTasks[taskIndex].status = status;

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

  Future<void> refresh() async {
    try {
      var io = IO();
      janitorTasks = await io.getJanitor();
    } on IOException {
      janitorTasks = <JanitorTask>[];
    }
  }

  List<JanitorTask> filter(
      [List<TaskStatus> statuses = const <TaskStatus>[],
      List<String> roomIDs = const <String>[]]) {
    if (roomIDs.isEmpty && statuses.isEmpty) return janitorTasks;

    var filteredJanitorTasks = <JanitorTask>[];

    if (roomIDs.isEmpty) {
      //csak státuszra szűr
      for (var task in janitorTasks) {
        if (statuses.contains(task.status)) filteredJanitorTasks.add(task);
      }
    } else if (statuses.isEmpty) {
      //csak teremre szűr
      for (var task in janitorTasks) {
        if (roomIDs.contains(task.placeID)) filteredJanitorTasks.add(task);
      }
    } else {
      //mindkettőre szűrünk
      for (var task in janitorTasks) {
        if (roomIDs.contains(task.placeID) && statuses.contains(task.status))
          filteredJanitorTasks.add(task);
      }
    }
    return filteredJanitorTasks;
  }
}

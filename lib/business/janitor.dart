import '../models/tasks.dart';
import '../utils/io.dart';

class Janitor {
  late List<JanitorTask> janitorTasks;

  Janitor() {
    refresh();
  }

  Future<bool> editStatus(TaskStatus status, int taskIndex) async {
    if (taskIndex >= janitorTasks.length || taskIndex < 0) return false;

    janitorTasks[taskIndex].status = status;

    var io = IO();
    var parameter = <String, String>{'uuid': janitorTasks[taskIndex].uid};
    await io.patchJanitor(status, parameter);

    return true;
  }

  Future<bool> addTask(JanitorTask task) async {
    janitorTasks.add(task);

    var io = IO();
    await io.postJanitor(task);

    return true;
  }

  Future<bool> deleteTask(int taskIndex) async {
    if (taskIndex >= janitorTasks.length || taskIndex < 0) return false;

    janitorTasks.removeAt(taskIndex);

    var io = IO();
    var parameter = <String, String>{'uuid': janitorTasks[taskIndex].uid};
    await io.deleteJanitor(parameter, janitorTasks[taskIndex].lastUpdate);

    return true;
  }

  Future<void> refresh() async {
    var io = IO();
    janitorTasks = await io.getJanitor(null);
  }

  List<JanitorTask> filter(List<TaskStatus> statuses, List<String> roomIDs) {
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

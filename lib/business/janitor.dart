import '../models/tasks.dart';
import '../utils/io.dart';

class Janitor {
  late List<JanitorTask> janitorTasks; //kéréslista

  Janitor() {
    refresh();
  }

  bool editStatus(TaskStatus status, int taskIndex) {
    if (taskIndex >= janitorTasks.length) return false;

    janitorTasks[taskIndex].status = status;
    return true;
  }

  Future<bool> addTask(JanitorTask task) async {
    janitorTasks.add(task);

    var io = IO();
    await io.postJanitor(null, task);

    return true;
  }

  Future<bool> deleteTask(int taskIndex) async {
    janitorTasks.removeAt(taskIndex);

    var io = IO();
    await io.deleteJanitor(null);

    return true;
  }

  Future<void> refresh() async {
    var io = IO();
    janitorTasks = await io.getJanitor(null);
  }

  List<JanitorTask> filter(List<String> statuses, List<String> roomIDs) {
    if (roomIDs.isEmpty && statuses.isEmpty) return janitorTasks;

    var filteredJanitorTasks = <JanitorTask>[];

    if (roomIDs.isEmpty) //csak státuszra szűr
    {
      for (var task in janitorTasks) {
        if (statuses.contains(task.status)) filteredJanitorTasks.add(task);
      }
    } else if (statuses.isEmpty) //csak teremre szűr
    {
      for (var task in janitorTasks) {
        if (roomIDs.contains(task.roomID)) filteredJanitorTasks.add(task);
      }
    } else //mindkettőre szűrünk
    {
      for (var task in janitorTasks) {
        if (roomIDs.contains(task.roomID) && statuses.contains(task.status))
          filteredJanitorTasks.add(task);
      }
    }

    return filteredJanitorTasks;
  }
}

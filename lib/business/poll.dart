import '../models/tasks.dart';
import '../utils/io.dart';

class Poll {
  late List<PollTask> pollTasks;

  Poll() {
    refresh();
  }

  Future<bool> addPoll(PollTask task) async {
    pollTasks.add(task);
    var io = IO();
    await io.postPoll(task);
    return true;
  }

  Future<bool> editPoll(PollTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.patchPoll(task, parameter);

    pollTasks.removeWhere((element) => element.uid == task.uid);
    pollTasks.add(task);

    return true;
  }

  Future<bool> deletePoll(int taskIndex) async {
    if (taskIndex >= pollTasks.length || taskIndex < 0) return false;

    var io = IO();
    var parameter = {'id': pollTasks[taskIndex].uid};
    await io.deletePoll(parameter, pollTasks[taskIndex].lastUpdate);

    pollTasks.removeAt(taskIndex);

    return true;
  }

  Future<bool> addVote(Vote vote, int taskIndex) async {
    if (pollTasks[taskIndex].answers.contains(vote)) return false;

    var io = IO();
    var param = {'id': pollTasks[taskIndex].uid};
    await io.putPoll(vote, param);
    pollTasks[taskIndex].answers.add(vote);
    return true;
  }

  List<PollTask> filter(String userID) {
    var results = <PollTask>[];
    pollTasks.forEach((element) {
      element.answers?.forEach((vote) {
        if (vote.voterID == userID) results.add(element);
      });
    });
    return results;
  }

  Future<void> refresh() async {
    var io = IO();
    pollTasks = await io.getPoll(null);
  }
}

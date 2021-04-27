import 'package:szikapp/models/tasks.dart';

class Poll {
  late List<PollTask> poll;

  Poll() {
    refresh();
  }

  Future<bool> addPoll(PollTask task) async {
    poll.add(task);
    var io = IO();
    await io.postPoll(null, task);
    return true;
  }

  Future<bool> editPoll(PollTask task) async {
    poll.add(task);
    var io = IO();
    await io.patchPoll(null, task);
    return true;
  }

  Future<bool> deletePoll(int taskIndex) async {
    var io = IO();
    await io.deletePoll(null, poll[taskIndex]);
    poll.removeAt(taskIndex);
    return true;
  }

  Future<bool> addVote(Vote vote, int pollIndex) async {
    var io = IO();
    var param = {'id': poll[pollIndex].uid};
    await io.putPoll(param, vote);
    poll[pollIndex].answers?.add(vote);
    return true;
  }

  List<PollTask> filter(String userID) {
    List<PollTask> results = <PollTask>[];
    poll.forEach((element) {
      element.answers?.forEach((vote) {
        if (vote.voterID == userID) results.add(element);
      });
    });
    return results;
  }

  Future<void> refresh() async {
    var io = IO();
    poll = await io.getPoll(null);
  }
}

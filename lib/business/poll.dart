import '../main.dart';

import '../models/tasks.dart';
import '../utils/io.dart';

class Poll {
  late List<PollTask> pollTasks;

  static final Poll _instance = Poll._privateConstructor();
  factory Poll() => _instance;
  Poll._privateConstructor();

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

  Future<Map<dynamic, dynamic>> getResults(PollTask task) async {
    var io = IO();
    var param = {'id': task.uid};
    var resultTaskList = await io.getPoll(param);
    var resultTask = resultTaskList.first;

    var results = {};
    if (resultTask.isLive) {
      if (resultTask.answers.isNotEmpty) results['isLive'] = true;
    } else {
      if (resultTask.answers.isEmpty)
        results['isNotStarted'] = true;
      else
        results['isLive'] = false;
    }
    results['isConfidential'] = resultTask.isConfidential ? true : false;
    results['isMultipleChoice'] = resultTask.isMultipleChoice ? true : false;

    if (resultTask.isMultipleChoice) {
      for (var answerOption in resultTask.answerOptions) {
        results[answerOption] = resultTask.isConfidential ? 0 : [];
      }
    } else {
      results['yes'] = resultTask.isConfidential ? 0 : [];
      results['no'] = resultTask.isConfidential ? 0 : [];
      results['abstain'] = resultTask.isConfidential ? 0 : [];
    }

    for (var vote in resultTask.answers) {
      if (resultTask.isMultipleChoice) {
        for (var option in vote.votes)
          resultTask.isConfidential
              ? results[option] += 1
              : results[option].add(vote.voterID);
      } else {
        resultTask.isConfidential
            ? results[vote.votes.first] += 1
            : results[vote.votes.first].add(vote.voterID);
      }
    }

    return results;
  }

  List<PollTask> filter(String userID) {
    var results = <PollTask>[];
    for (var poll in pollTasks) {
      for (var vote in poll.answers) {
        if (vote.voterID == userID) results.add(poll);
      }
    }
    return results;
  }

  Future<void> refresh({String? issuer, String? involved}) async {
    var parameter = <String, String>{};
    if (issuer != null) parameter['issuer'] = issuer;
    if (involved != null) parameter['involved'] = involved;

    var io = IO();
    pollTasks = await io.getPoll(parameter);
  }
}

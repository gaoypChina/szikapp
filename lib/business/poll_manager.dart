import 'package:flutter/material.dart';

import '../models/tasks.dart';
import '../utils/utils.dart';

///Szavazás funkció logikai működését megvalósító singleton háttérosztály.
class PollManager extends ChangeNotifier {
  ///Szavazások listája
  List<PollTask> _polls = [];
  int _selectedIndex = -1;
  bool _createNewPoll = false;
  bool _editPoll = false;
  bool _vote = false;
  bool _viewPollResults = false;

  ///Singleton osztálypéldány
  static final PollManager _instance = PollManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory PollManager() => _instance;

  ///Privát konstruktor
  PollManager._privateConstructor();

  List<PollTask> get polls => List.unmodifiable(_polls);

  int get selectedIndex => _selectedIndex;
  PollTask? get selectedPoll =>
      selectedIndex != -1 ? _polls[selectedIndex] : null;
  bool get isCreatingNewPoll => _createNewPoll;
  bool get isEditingPoll => _editPoll;
  bool get isVoting => _vote;
  bool get isViewingPollResults => _viewPollResults;

  void createNewPoll() {
    _createNewPoll = true;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = -1;
    notifyListeners();
  }

  void editPoll(int index) {
    _createNewPoll = false;
    _editPoll = true;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = index;
    notifyListeners();
  }

  void vote(int index) {
    _createNewPoll = false;
    _editPoll = false;
    _vote = true;
    _viewPollResults = false;
    _selectedIndex = index;
    notifyListeners();
  }

  void setSelectedPollTask(String uid) {
    final index = _polls.indexWhere((element) => element.uid == uid);
    _createNewPoll = false;
    _editPoll = true;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = index;
    notifyListeners();
  }

  void viewPollResults(int index) {
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = true;
    _selectedIndex = index;
    notifyListeners();
  }

  void closePollResults() {
    _viewPollResults = false;
    notifyListeners();
  }

  ///Új szavazás hozzáadása. A függvény feltölti a szerverre az új szavazást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> addPoll(PollTask poll) async {
    var io = IO();
    await io.postPoll(poll);

    _polls.add(poll);
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Szavazás szerkesztése. A függvény feltölti a szerverre a módosított
  ///szavazást, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> updatePoll(PollTask poll) async {
    var io = IO();
    var parameter = {'id': poll.uid};
    await io.patchPoll(poll, parameter);

    _polls.removeWhere((element) => element.uid == poll.uid);
    _polls.add(poll);
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Szavazás törlése. A függvény törli a szerverről a szavazást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deletePoll(PollTask poll) async {
    if (!_polls.contains(poll)) return true;

    var io = IO();
    var parameter = {'id': poll.uid};
    await io.deletePoll(parameter, poll.lastUpdate);

    _polls.remove(poll);
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Szavazat leadása. A függvény leadja a felhasználó szavazatát a megadott
  ///szavazáson. Ha a szerveren sikeres a változtatás, lokálisan is megteszi.
  Future<bool> addVote(Vote vote, PollTask poll) async {
    if (poll.answers.contains(vote)) return false;

    var io = IO();
    var param = {'id': poll.uid};
    await io.putPoll(vote, param);

    poll.answers.add(vote);
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Szavazás eredményeinek megtekintése. Összegzi és megjeleníthető formába
  ///hozza a szavazás eredményeit.
  Future<Map<dynamic, dynamic>> getResults(PollTask poll) async {
    var io = IO();
    var param = {'id': poll.uid};
    var resultTaskList = await io.getPoll(param);
    var resultTask = resultTaskList.first;

    var results = {};
    if (resultTask.isLive) {
      if (resultTask.answers.isNotEmpty) results['isLive'] = true;
    } else {
      if (resultTask.answers.isEmpty) {
        results['isNotStarted'] = true;
      } else {
        results['isLive'] = false;
      }
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
        for (var option in vote.votes) {
          resultTask.isConfidential
              ? results[option] += 1
              : results[option].add(vote.voterID);
        }
      } else {
        resultTask.isConfidential
            ? results[vote.votes.first] += 1
            : results[vote.votes.first].add(vote.voterID);
      }
    }

    return results;
  }

  List<PollTask> filter({required String userID, bool? isLive}) {
    var results = <PollTask>[];

    //userID-ra mindenképp szűrünk
    for (var poll in polls) {
      for (var vote in poll.answers) {
        if (vote.voterID == userID) results.add(poll);
      }
    }

    //ha isLive-ra nem szűrünk
    if (isLive == null) {
      return List.unmodifiable(results);
    }

    //élő szavazásokat szűrjük ki: ha aktívak még
    if (isLive) {
      for (var poll in polls) {
        if (poll.isLive) results.add(poll);
      }
      return List.unmodifiable(results);
    }

    //lejárt szavazások: nem aktívak vagy a határidejük lejárt
    else {
      for (var poll in polls) {
        var negDif = poll.end.difference(DateTime.now()).isNegative;
        if (!poll.isLive || negDif) results.add(poll);
      }
      return List.unmodifiable(results);
    }
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb szavazáslistát.
  ///A paraméterek megadásával szűkíthető a szinkronizálandó adatok köre.
  Future<void> refresh({String? issuer, String? involved}) async {
    var parameter = <String, String>{};
    if (issuer != null) parameter['issuer'] = issuer;
    if (involved != null) parameter['involved'] = involved;

    try {
      var io = IO();
      _polls = await io.getPoll(parameter);
    } on IONotModifiedException {}
  }
}

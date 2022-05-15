import 'package:flutter/material.dart';

import '../models/models.dart';
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

  int indexOf(PollTask task) {
    for (var e in polls) {
      if (e.id == task.id) return polls.indexOf(e);
    }
    return -1;
  }

  void createNewPoll() {
    _createNewPoll = true;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    _selectedIndex = -1;
    notifyListeners();
  }

  void editPoll(int index) {
    _selectedIndex = index;
    _createNewPoll = false;
    _editPoll = true;
    _vote = false;
    _viewPollResults = false;
    notifyListeners();
  }

  void vote(int index) {
    _selectedIndex = index;
    _createNewPoll = false;
    _editPoll = false;
    _vote = true;
    _viewPollResults = false;
    _selectedIndex = index;
    notifyListeners();
  }

  void setSelectedPollTask(String id) {
    final index = _polls.indexWhere((element) => element.id == id);
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

  void unselectPoll() {
    _selectedIndex = -1;
    notifyListeners();
  }

  void performBackButtonPressed() {
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
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
    var parameter = {'id': poll.id};
    await io.patchPoll(poll, parameter);

    _polls.removeWhere((element) => element.id == poll.id);
    _polls.add(poll);
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    notifyListeners();
    return true;
  }

  ///Szavazás törlése. A függvény törli a szerverről a szavazást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deletePoll(PollTask poll) async {
    if (!_polls.any((element) => element.id == poll.id)) return false;

    var io = IO();
    var parameter = {'id': poll.id};
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
    var param = {'id': poll.id};
    await io.putPoll(vote, param);

    poll.answers.add(vote);
    _createNewPoll = false;
    _editPoll = false;
    _vote = false;
    _viewPollResults = false;
    notifyListeners();
    return true;
  }

  /// Szavazás eredményeinek megtekintése. Összegzi és megjeleníthető formába
  /// hozza a szavazás eredményeit.
  Map<String, dynamic> getResults({
    required PollTask poll,
    required List<Group> groups,
  }) {
    var voters = <String>{};
    var results = <String, dynamic>{
      'allVoteCount': 0,
    };

    for (var answerOption in poll.answerOptions) {
      results[answerOption] = <String, dynamic>{
        'voteCount': 0,
        if (!poll.isConfidential) 'voterIDs': <String>[],
      };
    }

    for (var vote in poll.answers) {
      voters.add(vote.voterID);
      for (var answerOption in vote.votes) {
        results[answerOption]['voteCount'] += 1;
        if (!poll.isConfidential) {
          results[answerOption]['voterIDs'].add(vote.voterID);
        }
        results['allVoteCount'] += 1;
      }
    }

    Set possibleVoters = <String>{};
    for (var id in poll.participantIDs) {
      if (id.startsWith('g')) {
        possibleVoters
            .addAll(groups.firstWhere((element) => element.id == id).memberIDs);
      } else {
        possibleVoters.add(id);
      }
    }

    results['allVoterCount'] = voters.length;
    results['nonVoterIDs'] = possibleVoters.difference(voters);

    return results;
  }

  bool hasVoted({required String userID, required PollTask poll}) {
    return poll.answers.any((element) => element.voterID == userID);
  }

  List<PollTask> filter({required bool isLive}) {
    var results = <PollTask>[];

    if (isLive) {
      for (var element in polls) {
        if (element.isLive && element.end.isAfter(DateTime.now())) {
          results.add(element);
        }
      }
    } else {
      for (var element in polls) {
        if (!element.isLive || element.end.isBefore(DateTime.now())) {
          results.add(element);
        }
      }
    }
    return results;
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb szavazáslistát.
  ///A paraméterek megadásával szűkíthető a szinkronizálandó adatok köre.
  Future<void> refresh({required String userID}) async {
    var parameter = <String, String>{
      'manager': userID,
      'participant': userID,
    };

    var io = IO();
    _polls = await io.getPoll(parameter);
  }
}

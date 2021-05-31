import '../models/tasks.dart';
import '../utils/io.dart';

///Szavazás funkció logikai működését megvalósító singleton háttérosztály.
class Poll {
  ///Szavazások listája
  late List<PollTask> polls;

  ///Singleton osztálypéldány
  static final Poll _instance = Poll._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory Poll() => _instance;

  ///Privát konstruktor
  Poll._privateConstructor();

  ///Új szavazás hozzáadása. A függvény feltölti a szerverre az új szavazást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> addPoll(PollTask poll) async {
    var io = IO();
    await io.postPoll(poll);

    polls.add(poll);

    return true;
  }

  ///Szavazás szerkesztése. A függvény feltölti a szerverre a módosított
  ///szavazást, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editPoll(PollTask poll) async {
    var io = IO();
    var parameter = {'id': poll.uid};
    await io.patchPoll(poll, parameter);

    polls.removeWhere((element) => element.uid == poll.uid);
    polls.add(poll);

    return true;
  }

  ///Szavazás törlése. A függvény törli a szerverről a szavazást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deletePoll(PollTask poll) async {
    if (!polls.contains(poll)) return true;

    var io = IO();
    var parameter = {'id': poll.uid};
    await io.deletePoll(parameter, poll.lastUpdate);

    polls.remove(poll);

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
    for (var poll in polls) {
      for (var vote in poll.answers) {
        if (vote.voterID == userID) results.add(poll);
      }
    }
    return results;
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb szavazáslistát.
  ///A paraméterek megadásával szűkíthető a szinkronizálandó adatok köre.
  Future<void> refresh({String? issuer, String? involved}) async {
    var parameter = <String, String>{};
    if (issuer != null) parameter['issuer'] = issuer;
    if (involved != null) parameter['involved'] = involved;

    var io = IO();
    polls = await io.getPoll(parameter);
  }
}

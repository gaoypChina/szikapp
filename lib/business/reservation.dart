import '../models/tasks.dart';
import '../utils/io.dart';

class Reservation {
  //foglalások a létrehozást követő 48 órára
  late List<TimetableTask> reservations;

  Reservation() {
    refresh();
  }

  Future<bool> addReservation(TimetableTask task) async {
    reservations.add(task);

    var io = IO();
    await io.postReservation(task);

    return true;
  }

  Future<bool> deleteReservation(int taskIndex) async {
    if (taskIndex >= reservations.length || taskIndex < 0) return false;

    var io = IO();
    var parameter = <String, String>{'uuid': reservations[taskIndex].uid};
    await io.deleteReservation(parameter, reservations[taskIndex].lastUpdate);

    reservations.removeAt(taskIndex);

    return true;
  }

  Future<void> refresh() async {
    var io = IO();
    reservations = await io.getReservation();
  }

  List<TimetableTask> filter(
      DateTime startTime, DateTime endTime, List<String> rooms) {
    var filteredTimeTableTasks = <TimetableTask>[];

    if (rooms.isEmpty) {
      //csak időpontra szűrünk
      for (var res in reservations) {
        if (res.start.isAfter(startTime) && res.start.isBefore(endTime) ||
            res.end.isAfter(startTime) && res.end.isBefore(endTime))
          filteredTimeTableTasks.add(res);
      }
    } else {
      //szobára és időpontra is szűrünk
      for (var res in reservations) {
        for (var i in res.resourceIDs!) {
          //ha van szűrési feltétel az adott foglalás szobájára
          //és az intervallumba is beleesik:
          if (i.startsWith('p') &&
              rooms.contains(i) &&
              (res.start.isAfter(startTime) && res.start.isBefore(endTime) ||
                  res.end.isAfter(startTime) && res.end.isBefore(endTime)))
            filteredTimeTableTasks.add(res);
        }
      }
    }
    return filteredTimeTableTasks;
  }
}

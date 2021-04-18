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
    await io.postReservation(null, task);

    return true;
  }

  Future<bool> deleteReservation(int taskIndex) async {
    if (taskIndex >= reservations.length || taskIndex < 0) return false;

    reservations.removeAt(taskIndex);

    var io = IO();
    var parameter = <String, String>{'uuid': reservations[taskIndex].uid};
    await io.deleteReservation(parameter);

    return true;
  }

  Future<void> refresh() async {
    var io = IO();
    reservations = await io.getReservation(null);
  }

  List<TimetableTask> filter(
      List<DateTime> startTimes, List<DateTime> endTimes, List<String> rooms) {
    var filteredTimeTableTasks = <TimetableTask>[];

    for (var res in reservations) {
      if (startTimes.contains(res.start) || endTimes.contains(res.end))
        filteredTimeTableTasks.add(res);
      else {
        for (var i in res.resourceIDs!) {
          if (i.startsWith('p') && rooms.contains(i))
            filteredTimeTableTasks.add(res);
        }
      }
    }

    return filteredTimeTableTasks;
  }
}

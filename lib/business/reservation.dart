import '../models/tasks.dart';
import '../utils/io.dart';

class Reservation {
  late List<TimetableTask> reservations;

  static final Reservation _instance = Reservation._privateConstructor();
  factory Reservation() => _instance;
  Reservation._privateConstructor() {
    refresh();
  }

  Future<bool> addReservation(TimetableTask task) async {
    reservations.add(task);

    var io = IO();
    await io.postReservation(task);

    return true;
  }

  Future<bool> editReservation(TimetableTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.putReservation(task, parameter);

    reservations.removeWhere((element) => element.uid == task.uid);
    reservations.add(task);

    return true;
  }

  Future<bool> deleteReservation(int taskIndex) async {
    if (taskIndex >= reservations.length || taskIndex < 0) return false;

    var io = IO();
    var parameter = {'id': reservations[taskIndex].uid};
    await io.deleteReservation(parameter, reservations[taskIndex].lastUpdate);

    reservations.removeAt(taskIndex);

    return true;
  }

  Future<void> refresh({DateTime? start, DateTime? end}) async {
    start ??= DateTime.now();
    end ??= DateTime.now().add(const Duration(days: 7));

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String()
    };

    var io = IO();
    reservations = await io.getReservation(parameter);
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
        for (var i in res.resourceIDs) {
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

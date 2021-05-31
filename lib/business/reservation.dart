import '../models/tasks.dart';
import '../utils/io.dart';

///Foglalás funkció logikai működését megvalósító singleton háttérosztály.
class Reservation {
  ///Foglalások listája
  late List<TimetableTask> reservations;

  ///Singleton osztálypéldány
  static final Reservation _instance = Reservation._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory Reservation() => _instance;

  ///Privát konstruktor, ami inicializálja a [reservations] változót.
  Reservation._privateConstructor() {
    refresh();
  }

  ///Új foglalás hozzáadása. A függvény feltölti a szerverre az új foglalást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> addReservation(TimetableTask task) async {
    var io = IO();
    await io.postReservation(task);

    reservations.add(task);

    return true;
  }

  ///Foglalás szerkesztése. A függvény feltölti a szerverre a módosított
  ///foglalást, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editReservation(TimetableTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.putReservation(task, parameter);

    reservations.removeWhere((element) => element.uid == task.uid);
    reservations.add(task);

    return true;
  }

  ///Foglalás törlése. A függvény törli a szerverről a foglalást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deleteReservation(TimetableTask task) async {
    if (!reservations.contains(task)) return true;

    var io = IO();
    var parameter = {'id': task.uid};
    await io.deleteReservation(parameter, task.lastUpdate);

    reservations.remove(task);

    return true;
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb foglaláslistát.
  ///Alapértelmezetten az elkövetkező egy hét foglalásait szinkronizálja.
  ///Azonban a [start] és az [end] paraméterek megadásával ez a periódus
  ///módosítható.
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

  ///Szűrés. A függvény a megadott paraméterek alapján szűri a foglaláslistát.
  ///Ha minden paraméter üres, a teljes listát adja vissza.
  List<TimetableTask> filter(
      DateTime startTime, DateTime endTime, List<String> placeIDs) {
    var results = <TimetableTask>[];

    if (placeIDs.isEmpty) {
      //csak időpontra szűrünk
      for (var res in reservations) {
        if (res.start.isAfter(startTime) && res.start.isBefore(endTime) ||
            res.end.isAfter(startTime) && res.end.isBefore(endTime))
          results.add(res);
      }
    } else {
      //szobára és időpontra is szűrünk
      for (var res in reservations) {
        for (var i in res.resourceIDs) {
          //ha van szűrési feltétel az adott foglalás szobájára
          //és az intervallumba is beleesik:
          if (i.startsWith('p') &&
              placeIDs.contains(i) &&
              (res.start.isAfter(startTime) && res.start.isBefore(endTime) ||
                  res.end.isAfter(startTime) && res.end.isBefore(endTime)))
            results.add(res);
        }
      }
    }
    return results;
  }
}

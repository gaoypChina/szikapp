import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/tasks.dart';
import '../utils/io.dart';

///Konyhatakarítás funkció logikai működését megvalósító singleton
///háttérosztály.
class KitchenCleaning {
  ///Konyhatakarítási feladatok listája
  late List<CleaningTask> cleaningTasks;

  ///Konyhatakarítás-cserék listája
  late List<CleaningExchange> cleaningExchanges;

  ///Konyhatakarítási periódusok listája
  late List<CleaningPeriod> cleaningPeriods;

  ///Singleton osztálypéldány
  static final KitchenCleaning _instance =
      KitchenCleaning._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory KitchenCleaning() => _instance;

  ///Privát kontruktor, ami inicializálja a [cleaningPeriods] paramétert.
  KitchenCleaning._privateConstructor() {
    cleaningPeriods = [];
  }

  ///Konyhatakarítási feladatok frissítése. A függvény lekéri a szerverről a
  ///legfrissebb feladatlistát. Alapértelmezetten az aktuális napot megelőző
  ///naptól a folyó konhatakarítási periódus végéig szinkronizál.
  void refreshTasks({DateTime? start, DateTime? end}) async {
    if (cleaningPeriods.isEmpty) refreshPeriods();

    start ??= DateTime.now().subtract(const Duration(days: 1));
    end ??= cleaningPeriods.last.end;

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };

    var io = IO();
    cleaningTasks = await io.getCleaning(parameter);
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb
  ///konyhatakarítás-csere listát. Alapértelmezetten csak a nyitott cseréket
  ///szinkronizálja.
  void refreshExchanges({bool approved = false}) async {
    var io = IO();
    var parameter = {'approved': approved.toString()};
    cleaningExchanges = await io.getCleaningExchange(parameter);
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb konyhatakarítási
  ///periódus listát. Alapértelmezetten csak a jelenleg aktív periódust
  ///szinkronizálja.
  void refreshPeriods({DateTime? start, DateTime? end}) async {
    start ??= DateTime.now();
    end ??= DateTime.now();

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String()
    };

    var io = IO();
    cleaningPeriods = await io.getCleaningPeriod(parameter);
  }

  ///Elmaradt konyhatakarítás jelentése.
  Future<bool> reportInsufficiency(CleaningTask task) async {
    var io = IO();
    task.status = TaskStatus.refused;
    var parameter = {'id': task.uid};
    await io.putCleaning(task, parameter);
    cleaningTasks.removeWhere((element) => element.uid == task.uid);
    cleaningTasks.add(task);
    return true;
  }

  ///Új konyhatakarítási periódus hozzáadása. A függvény feltölti a szerverre az
  ///új periódust, ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja
  ///a listához.
  Future<bool> createCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    await io.postCleaningPeriod(period);
    cleaningPeriods.add(period);
    return true;
  }

  ///Periódus szerkesztése. A függvény feltölti a szerverre a módosított
  ///periódust, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    var parameter = {'id': period.uid};
    await io.patchCleaningPeriod(period, parameter);
    cleaningPeriods.removeWhere((element) => element.uid == period.uid);
    cleaningPeriods.add(period);
    return true;
  }

  ///Feladat szerkesztése. A függvény feltölti a szerverre a módosított
  ///feladatot, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> editCleaningTask(CleaningTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.putCleaning(task, parameter);
    cleaningTasks.removeWhere((element) => element.uid == task.uid);
    cleaningTasks.add(task);
    return true;
  }

  ///Új csere hozzáadása. A függvény feltölti a szerverre az új cserét,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> createCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    await io.postCleaningExchange(exchange);
    cleaningExchanges.add(exchange);
    return true;
  }

  ///Cserealkalom felajánlása.
  Future<bool> offerCleaningExchangeOccasion(
      CleaningExchange exchange, String replaceUid) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.patchCleaningExchange(parameter, exchange.lastUpdate, replaceUid);
    return true;
  }

  ///Cserealkalom elfogadása.
  Future<bool> acceptCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.patchCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }

  ///Cserealkalom visszavonása.
  Future<bool> withdrawCleaningExchangeOccasion(
      CleaningExchange exchange, String replaceUid) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.putCleaningExchange(parameter, exchange.lastUpdate, replaceUid);
    return true;
  }

  ///Cserealkalom visszautasítása.
  Future<bool> rejectCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.putCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }
}

import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/tasks.dart';
import '../utils/io.dart';

class KitchenCleaning {
  late List<CleaningTask> cleaningTasks;
  late List<CleaningExchange> cleaningExchanges;
  late List<CleaningPeriod> cleaningPeriods;

  static final KitchenCleaning _instance =
      KitchenCleaning._privateConstructor();

  factory KitchenCleaning() => _instance;

  KitchenCleaning._privateConstructor() {
    cleaningPeriods = [];
  }

  void refreshTasks({DateTime? start, DateTime? end}) async {
    if (cleaningPeriods.isEmpty) refreshPeriods();

    start ??= DateTime.now().subtract(const Duration(days: 1));
    end ??= cleaningPeriods.last.end;

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String()
    };

    var io = IO();
    cleaningTasks = await io.getCleaning(parameter);
  }

  void refreshExchanges({bool approved = false}) async {
    var io = IO();
    var parameter = {'approved': approved.toString()};
    cleaningExchanges = await io.getCleaningExchange(parameter);
  }

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

  Future<bool> reportInsufficiency() async {
    var io = IO();
    cleaningTasks[0].status = TaskStatus.refused;
    var parameter = {'id': cleaningTasks[0].uid};
    await io.putCleaning(cleaningTasks[0], parameter);
    return true;
  }

  Future<bool> createCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    await io.postCleaning(period);
    cleaningPeriods.add(period);
    return true;
  }

  Future<bool> editCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    var parameter = {'id': period.uid};
    await io.patchCleaning(period, parameter);
    cleaningPeriods.removeWhere((element) => element.uid == period.uid);
    cleaningPeriods.add(period);
    return true;
  }

  Future<bool> editCleaningTask(CleaningTask task) async {
    var io = IO();
    var parameter = {'id': task.uid};
    await io.putCleaning(task, parameter);
    cleaningTasks.removeWhere((element) => element.uid == task.uid);
    cleaningTasks.add(task);
    return true;
  }

  Future<bool> createCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    await io.postCleaningExchange(exchange);
    cleaningExchanges.add(exchange);
    return true;
  }

  Future<bool> offerCleaningExchangeOccasion(
      CleaningExchange exchange, String replaceUid) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.patchCleaningExchange(parameter, exchange.lastUpdate, replaceUid);
    return true;
  }

  Future<bool> acceptCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.patchCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }

  Future<bool> withdrawCleaningExchangeOccasion(
      CleaningExchange exchange, String replaceUid) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.putCleaningExchange(parameter, exchange.lastUpdate, replaceUid);
    return true;
  }

  Future<bool> rejectCleaningExchangeOccasion(CleaningExchange exchange) async {
    var io = IO();
    var parameter = {'id': exchange.uid};
    await io.putCleaningExchange(parameter, exchange.lastUpdate);
    return true;
  }
}

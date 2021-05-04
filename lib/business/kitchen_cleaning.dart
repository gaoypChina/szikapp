import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/tasks.dart';
import '../utils/io.dart';

class KitchenCleaning {
  late List<CleaningTask> cleaningTasks;
  late List<CleaningExchange> cleaningExchanges;
  late List<CleaningPeriod> cleaningPeriods;

  void refreshTasks() async {
    var io = IO();
    cleaningTasks = await io.getCleaning(null);
  }

  void refreshExchanges() async {
    var io = IO();
    cleaningExchanges = await io.getCleaningExchange(null);
  }

  void refreshPeriods() async {
    var io = IO();
    var parameter = {'period': 'true'};
    cleaningPeriods = await io.getCleaningPeriod(parameter);
  }

  Future<bool> reportInsufficiency() async {
    var io = IO();
    cleaningTasks[0].status = TaskStatus.refused;
    var parameter = {'TaskStatus': 'refused'};
    await io.putCleaning(cleaningTasks[0], parameter);

    return true;
  }

  Future<bool>  createCleaningPeriod(CleaningPeriod period)  async {
    var io = IO();
    cleaningPeriods.add(period);
    await io.postCleaning(period);
    refreshTasks();
    return true;
  }

  Future<bool> editCleaningPeriod(CleaningPeriod period) async {
    var io = IO();
    var parameter = {'id': period.uid};
    cleaningPeriods.removeWhere((element) => element.uid == period.uid);
    cleaningPeriods.add(period);
    await io.patchCleaning(period, parameter);
    refreshPeriods();
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
    return true;
  }

  Future<bool> offerCleaningExchangeOccasion
  (CleaningExchange exchange, String replaceUid) async {  
    var io = IO();
    var parameter = {'replace_id': replaceUid};
    await io.patchCleaningExchange
      (exchange.taskID, parameter, exchange.lastUpdate);
    return true;
  }

  Future<bool> acceptCleaningExchangeOccasion
  (CleaningExchange exchange) async {  
    
    //kód

    return true;
  }
  
  Future<bool> withdrawCleaningExchangeOccasion(CleaningExchange exchange, 
  String replace) async {  
    var io = IO();
    var parameter = {'data': replace};
    await io.putCleaningExchange
      (exchange.taskID, parameter, exchange.lastUpdate);
    return true;
  }

  Future<bool> rejectCleaningExchangeOccasion
  (CleaningExchange exchange) async {  
    
    //kód

    return true;
  }
  
}
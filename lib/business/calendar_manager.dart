import 'package:flutter/material.dart';

///Naptár funkció logikai működését megvalósító singleton háttérosztály.
class CalendarManager extends ChangeNotifier {
  ///Singleton osztálypéldány
  static final CalendarManager _instance =
      CalendarManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory CalendarManager() => _instance;

  ///Privát konstruktor
  CalendarManager._privateConstructor() {
    refresh();
  }

  Future<void> refresh() async {}
}

import 'package:flutter/material.dart';
import '../models/tasks.dart';

///Naptár funkció logikai működését megvalósító singleton háttérosztály.
class CalendarManager extends ChangeNotifier {
  List<TimetableTask> _events = [];
  int _selectedIndex = -1;
  bool _createNewEvent = false;
  bool _editEvent = false;

  ///Singleton osztálypéldány
  static final CalendarManager _instance =
      CalendarManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory CalendarManager() => _instance;

  ///Privát konstruktor
  CalendarManager._privateConstructor();

  List<TimetableTask> get events => List.unmodifiable(_events);
  int get selectedIndex => _selectedIndex;
  TimetableTask? get selectedEvent =>
      _selectedIndex != -1 ? _events[_selectedIndex] : null;
  bool get isCreatingNewEvent => _createNewEvent;
  bool get isEditingEvent => _editEvent;

  void createNewItem() {
    _createNewEvent = true;
    _editEvent = false;
    notifyListeners();
  }

  void editItem() {
    _createNewEvent = false;
    _editEvent = true;
    notifyListeners();
  }

  void setSelectedGoodToKnowItem(String uid) {
    final index = _events.indexWhere((element) => element.uid == uid);
    _selectedIndex = index;
    _createNewEvent = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _events = [];
    return;
  }
}

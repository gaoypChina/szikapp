import 'package:flutter/material.dart';
import '../models/resource.dart';

import '../models/tasks.dart';
import '../utils/io.dart';

class ReservationMode {
  static const int none = -1;
  static const int place = 0;
  static const int zoom = 1;
  static const int boardgame = 2;
}

///Foglalás funkció logikai működését megvalósító singleton háttérosztály.
class ReservationManager extends ChangeNotifier {
  ///Foglalások listája
  List<TimetableTask> _reservations = [];
  List<Boardgame> _games = [];
  int _selectedIndex = -1;
  int _selectedGame = -1;
  int _selectedPlace = -1;
  int _selectedMode = ReservationMode.none;
  bool _createNewReservation = false;
  bool _editReservation = false;

  ///Singleton osztálypéldány
  static final ReservationManager _instance =
      ReservationManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory ReservationManager() => _instance;

  ///Privát konstruktor, ami inicializálja a [reservations] változót.
  ReservationManager._privateConstructor();

  List<TimetableTask> get reservations => List.unmodifiable(_reservations);
  List<Boardgame> get games => List.unmodifiable(_games);
  int get selectedIndex => _selectedIndex;
  int get selectedGameIndex => _selectedGame;
  int get selectedPlaceIndex => _selectedPlace;
  int get selectedMode => _selectedMode;
  TimetableTask? get selectedTask =>
      selectedIndex != -1 ? _reservations[selectedIndex] : null;
  Boardgame? get selectedGame =>
      selectedIndex != -1 ? _games[selectedGameIndex] : null;
  bool get isCreatingNewReservation => _createNewReservation;
  bool get isEditingReservation => _editReservation;

  void createNewReservation({
    int gameIndex = -1,
    int placeIndex = -1,
  }) {
    _createNewReservation = true;
    _editReservation = false;
    _selectedPlace = placeIndex;
    _selectedGame = gameIndex;
    notifyListeners();
  }

  void createNewPlaceReservation(int placeIndex) {
    createNewReservation(placeIndex: placeIndex);
  }

  void createNewGameReservation(int gameIndex) {
    createNewReservation(gameIndex: gameIndex);
  }

  void selectGame(int index) {
    _selectedGame = index;
    notifyListeners();
  }

  void selectPlace(int index) {
    _selectedPlace = index;
    notifyListeners();
  }

  void editReservation(
    int index, {
    int gameIndex = -1,
    int placeIndex = -1,
  }) {
    _createNewReservation = false;
    _editReservation = true;
    _selectedIndex = index;
    _selectedPlace = placeIndex;
    _selectedGame = gameIndex;
    notifyListeners();
  }

  void editPlaceReservation(int index, int placeIndex) {
    editReservation(index, placeIndex: placeIndex);
  }

  void editGameReservation(int index, int gameIndex) {
    editReservation(index, gameIndex: gameIndex);
  }

  void selectMode(int mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  void unselectMode() {
    _selectedMode = ReservationMode.none;
    notifyListeners();
  }

  void setSelectedReservationTask(String id) {
    final index = _reservations.indexWhere((element) => element.id == id);
    _selectedIndex = index;
    _createNewReservation = false;
    _editReservation = true;
    notifyListeners();
  }

  void performBackButtonPressed() {
    _selectedIndex = -1;
    _selectedPlace = -1;
    _selectedGame = -1;
    _createNewReservation = false;
    _editReservation = false;
    notifyListeners();
  }

  ///Új foglalás hozzáadása. A függvény feltölti a szerverre az új foglalást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is hozzáadja a listához.
  Future<bool> addReservation(TimetableTask task) async {
    var io = IO();
    await io.postReservation(task);

    _reservations.add(task);
    _createNewReservation = false;
    _editReservation = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Foglalás szerkesztése. A függvény feltölti a szerverre a módosított
  ///foglalást, ha a művelet hiba nélkül befejeződik, lokálisan is módosítja
  ///a listán.
  Future<bool> updateReservation(TimetableTask task) async {
    var io = IO();
    var parameter = {'id': task.id};
    await io.putReservation(task, parameter);

    _reservations.removeWhere((element) => element.id == task.id);
    _reservations.add(task);
    _createNewReservation = false;
    _editReservation = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Foglalás törlése. A függvény törli a szerverről a foglalást,
  ///ha a művelet hiba nélkül befejeződik, lokálisan is eltávolítja a listából.
  Future<bool> deleteReservation(TimetableTask task) async {
    if (!_reservations.any((element) => element.uid == task.uid)) return false;

    var io = IO();
    var parameter = {'id': task.id};
    await io.deleteReservation(parameter, task.lastUpdate);

    _reservations.remove(task);
    _createNewReservation = false;
    _editReservation = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb foglaláslistát.
  ///Alapértelmezetten az elkövetkező egy hét foglalásait szinkronizálja.
  ///Azonban a [start] és az [end] paraméterek megadásával ez a periódus
  ///módosítható.
  Future<void> refresh({DateTime? start, DateTime? end}) async {
    start ??= DateTime.now().subtract(const Duration(days: 1));
    end ??= DateTime.now().add(const Duration(days: 7));

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String()
    };

    var io = IO();
    _reservations = await io.getReservation(parameter);
  }

  Future<void> refreshGames() async {
    var io = IO();
    _games = await io.getBoardgame();
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
            res.end.isAfter(startTime) && res.end.isBefore(endTime)) {
          results.add(res);
        }
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
                  res.end.isAfter(startTime) && res.end.isBefore(endTime))) {
            results.add(res);
          }
        }
      }
    }
    return List.unmodifiable(results);
  }
}

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../utils/utils.dart';

class ReservationMode {
  static const int none = -1;
  static const int place = 0;
  static const int account = 1;
  static const int boardgame = 2;
}

///Foglalás funkció logikai működését megvalósító singleton háttérosztály.
class ReservationManager extends ChangeNotifier {
  ///Foglalások listája
  List<TimetableTask> _reservations = [];
  List<Boardgame> _games = [];
  List<Account> _accounts = [];
  int _selectedIndex = -1;
  int _selectedGame = -1;
  int _selectedPlace = -1;
  int _selectedAccount = -1;
  int _selectedMode = ReservationMode.none;
  bool _createNewReservation = false;
  bool _editReservation = false;
  DateTime? _selectedDate;

  ///Singleton osztálypéldány
  static final ReservationManager _instance =
      ReservationManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory ReservationManager() => _instance;

  ///Privát konstruktor, ami inicializálja a [reservations] változót.
  ReservationManager._privateConstructor();

  List<TimetableTask> get reservations => List.unmodifiable(_reservations);
  List<Boardgame> get games => List.unmodifiable(_games);
  List<Account> get accounts => List.unmodifiable(_accounts);
  int get selectedIndex => _selectedIndex;
  int get selectedGameIndex => _selectedGame;
  int get selectedPlaceIndex => _selectedPlace;
  int get selectedAccountIndex => _selectedAccount;
  int get selectedMode => _selectedMode;
  TimetableTask? get selectedTask =>
      selectedIndex != -1 ? _reservations[_selectedIndex] : null;
  Boardgame? get selectedGame =>
      selectedIndex != -1 ? _games[_selectedGame] : null;
  Account? get selectedAccount =>
      selectedIndex != -1 ? _accounts[_selectedAccount] : null;
  bool get isCreatingNewReservation => _createNewReservation;
  bool get isEditingReservation => _editReservation;
  DateTime? get selectedDate => _selectedDate;

  void createNewReservation({
    int gameIndex = -1,
    int placeIndex = -1,
    int accountIndex = -1,
  }) {
    _createNewReservation = true;
    _editReservation = false;
    _selectedPlace = placeIndex;
    _selectedGame = gameIndex;
    _selectedAccount = accountIndex;
    notifyListeners();
  }

  void createNewPlaceReservation(int placeIndex) {
    createNewReservation(placeIndex: placeIndex);
  }

  void createNewGameReservation(int gameIndex) {
    createNewReservation(gameIndex: gameIndex);
  }

  void createNewAccountReservation(int accountIndex) {
    createNewReservation(accountIndex: accountIndex);
  }

  void selectGame(int index) {
    _selectedGame = index;
    notifyListeners();
  }

  void selectPlace(int index) {
    _selectedPlace = index;
    notifyListeners();
  }

  void selectAccount(int index) {
    _selectedAccount = index;
    notifyListeners();
  }

  void selectDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void editReservation(
    int index, {
    int gameIndex = -1,
    int placeIndex = -1,
    int accountIndex = -1,
  }) {
    _createNewReservation = false;
    _editReservation = true;
    _selectedIndex = index;
    _selectedPlace = placeIndex;
    _selectedGame = gameIndex;
    _selectedAccount = accountIndex;
    notifyListeners();
  }

  void editPlaceReservation(int index, int placeIndex) {
    editReservation(index, placeIndex: placeIndex);
  }

  void editGameReservation(int index, int gameIndex) {
    editReservation(index, gameIndex: gameIndex);
  }

  void editAccountReservation(int index, int accountIndex) {
    editReservation(index, accountIndex: accountIndex);
  }

  void selectMode(int mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  void unselectMode() {
    _selectedDate = null;
    _selectedMode = ReservationMode.none;
    notifyListeners();
  }

  void cancelCreatingOrEditing() {
    _createNewReservation = false;
    _editReservation = false;
    notifyListeners();
  }

  void setSelectedReservationTask(String id) {
    final index = _reservations.indexWhere((element) => element.id == id);
    _selectedIndex = index;
    _createNewReservation = false;
    _editReservation = true;
    notifyListeners();
  }

  ///Visszalépés a foglalások módválasztó képernyőjére.
  void performBackButtonPressed() {
    _selectedIndex = -1;
    _selectedPlace = -1;
    _selectedGame = -1;
    _selectedAccount = -1;
    _createNewReservation = false;
    _editReservation = false;
    _selectedDate = null;
    notifyListeners();
  }

  ///Visszaállítás alapállapotba. Így az összes foglalási képernyő eltűnik.
  void clear() {
    _selectedIndex = -1;
    _selectedPlace = -1;
    _selectedGame = -1;
    _selectedAccount = -1;
    _createNewReservation = false;
    _editReservation = false;
    _selectedDate = null;
    _selectedMode = ReservationMode.none;
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
    if (!_reservations.any((element) => element.id == task.id)) return false;

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
    end ??= DateTime.now().add(const Duration(days: 1));

    var parameter = {
      'start': start.toIso8601String(),
      'end': end.toIso8601String()
    };

    try {
      var io = IO();
      _reservations = await io.getReservation(parameter);
      _reservations.sort((a, b) => a.start.compareTo(b.start));
    } on IONotModifiedException {
      _reservations = [];
    }
  }

  Future<void> refreshGames() async {
    try {
      var io = IO();
      _games = await io.getBoardgame();
    } on IONotModifiedException {
      _games = [];
    }
  }

  Future<void> refreshAccounts() async {
    try {
      var io = IO();
      _accounts = await io.getAccount();
    } on IONotModifiedException {
      _accounts = [];
    }
  }

  bool isReserved(String id) {
    return reservations.any((task) => (task.resourceIDs.contains(id) &&
        DateTime.now().isInInterval(task.start, task.end)));
  }

  ///Szűrés. A függvény a megadott paraméterek alapján szűri a foglaláslistát.
  ///Ha minden paraméter üres, a teljes listát adja vissza.
  List<TimetableTask> filter(
      DateTime startTime, DateTime endTime, List<String> resourceIDs) {
    var results = <TimetableTask>[];
    startTime = startTime.toLocal();
    endTime = endTime.toLocal();

    if (resourceIDs.isEmpty) {
      //csak időpontra szűrünk
      for (var reservation in reservations) {
        if (reservation.start.isInInterval(startTime, endTime) ||
            reservation.end.isInInterval(startTime, endTime)) {
          results.add(reservation);
        }
      }
    } else {
      //szobára és időpontra is szűrünk
      for (var reservation in reservations) {
        for (var resourceID in reservation.resourceIDs) {
          if (resourceIDs.contains(resourceID) &&
              (reservation.start.isInInterval(startTime, endTime) ||
                  reservation.end.isInInterval(startTime, endTime))) {
            results.add(reservation);
          }
        }
      }
    }
    return List.unmodifiable(results);
  }
}

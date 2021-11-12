import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/resource.dart';
import '../utils/io.dart';

class SzikAppTab {
  static const int feed = 0;
  static const int menu = 1;
  static const int settings = 2;
}

class SzikAppStateManager extends ChangeNotifier {
  bool _firebaseInitialized = false;
  bool _hasError = false;
  Object? _error;
  int _selectedTab = SzikAppTab.feed;

  ///A kollégiumban megtalálható helyek [Place] listája
  List<Place> _places = [];

  ///A felhasználói csoportok [Group] listája, melyek meghatározzák a tagjaik
  ///jogosultságait.
  List<Group> _groups = [];

  bool get isFirebaseInitialized => _firebaseInitialized;
  bool get hasError => _hasError;
  Object? get error => _error;
  int get selectedTab => _selectedTab;

  List<Place> get places => _places;
  List<Group> get groups => _groups;

  void initializeFirebase() {
    _firebaseInitialized = true;
    notifyListeners();
  }

  ///A háttérben letölti azokat az adatokat, melyekre bármelyik funkciónak
  ///szüksége lehet.
  void loadEarlyData() async {
    try {
      var io = IO();
      _places = await io.getPlace();
      _groups = await io.getGroup();
    } on Exception {
      _places = <Place>[];
      _groups = <Group>[];
    }
  }

  void setError(Object error) {
    _hasError = true;
    _error = error;
    notifyListeners();
  }

  void resolveError() {
    _hasError = false;
    _error = null;
    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}

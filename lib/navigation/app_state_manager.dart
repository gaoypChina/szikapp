import 'package:flutter/material.dart';

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

  bool get isFirebaseInitialized => _firebaseInitialized;
  bool get hasError => _hasError;
  Object? get error => _error;
  int get selectedTab => _selectedTab;

  void initializeFirebase() {
    _firebaseInitialized = true;
    notifyListeners();
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

import 'package:flutter/material.dart';

class SzikAppTab {
  static const int feed = 0;
  static const int menu = 1;
  static const int settings = 2;
}

class SzikAppStateManager extends ChangeNotifier {
  bool _loggedIn = false;
  bool _firebaseInitialized = false;
  bool _firebaseError = false;
  int _selectedTab = SzikAppTab.feed;

  bool get isLoggedIn => _loggedIn;
  bool get isFirebaseInitialized => _firebaseInitialized;
  bool get hasFirebaseError => _firebaseError;
  int get selectedTab => _selectedTab;

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _selectedTab = SzikAppTab.feed;
    notifyListeners();
  }

  void initializeFirebase() {
    _firebaseInitialized = true;
    notifyListeners();
  }

  void setFirebaseError() {
    _firebaseError = true;
    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}

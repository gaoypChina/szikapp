import 'package:flutter/material.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import 'navigation.dart';

class SzikAppTab {
  static const int feed = 0;
  static const int menu = 1;
  static const int settings = 2;
}

class SzikAppSubMenu {
  static const int none = -1;
  static const int data = 0;
  static const int community = 1;
  static const int everyday = 2;
}

class SzikAppFeature {
  static const int none = -1;
  static const int calendar = 0;
  static const int cleaning = 1;
  static const int contacts = 2;
  static const int documents = 3;
  static const int janitor = 4;
  static const int poll = 5;
  static const int profile = 6;
  static const int reservation = 7;
  static const int settings = 8;
  static const int bookrental = 9;
  static const int passwords = 10;
  static const int invitation = 97;
  static const int article = 98;
  static const int error = 99;
}

const Map<int, Permission> featurePermissions = {
  SzikAppFeature.calendar: Permission.calendarView,
  SzikAppFeature.cleaning: Permission.cleaningView,
  SzikAppFeature.contacts: Permission.contactsView,
  SzikAppFeature.documents: Permission.documentsView,
  SzikAppFeature.janitor: Permission.janitorView,
  SzikAppFeature.passwords: Permission.passwordsView,
  SzikAppFeature.poll: Permission.pollView,
  SzikAppFeature.profile: Permission.profileView,
  SzikAppFeature.reservation: Permission.reservationView,
  SzikAppFeature.bookrental: Permission.bookLoanView,
};

class SzikAppStateManager extends ChangeNotifier {
  bool _isStarting = true;
  bool _firebaseInitialized = false;
  bool _hasError = false;
  BaseException? _error;
  int _selectedTab = SzikAppTab.feed;
  int _selectedFeature = SzikAppFeature.none;
  int _selectedSubMenu = SzikAppSubMenu.none;

  SzikAppLink? _lastMenuLink;

  ///A kollégiumban megtalálható helyek [Place] listája
  List<Place> _places = [];

  ///A felhasználói csoportok [Group] listája, melyek meghatározzák a tagjaik
  ///jogosultságait.
  List<Group> _groups = [];

  List<User> _users = [];

  bool get isFirebaseInitialized => _firebaseInitialized;
  bool get isStarting => _isStarting;
  bool get hasError => _hasError;
  BaseException? get error => _error;
  int get selectedTab => _selectedTab;
  int get selectedSubMenu => _selectedSubMenu;
  int get selectedFeature => _selectedFeature;

  List<Place> get places => _places;
  List<Group> get groups => _groups;
  List<User> get users => _users;

  void initializeFirebase() {
    _firebaseInitialized = true;
    notifyListeners();
  }

  void initStarting() {
    _isStarting = true;
    notifyListeners();
  }

  void finishStarting() {
    _isStarting = false;
    notifyListeners();
  }

  ///A háttérben letölti azokat az adatokat, melyekre bármelyik funkciónak
  ///szüksége lehet.
  Future<void> loadEarlyData() async {
    try {
      var io = IO();
      _places = await io.getPlace();
      _groups = await io.getGroup();
      _users = await io.getContacts();
    } on Exception {
      _places = <Place>[];
      _groups = <Group>[];
      _users = <User>[];
    }
  }

  void setError(BaseException error) {
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
    if (_selectedTab != SzikAppTab.menu && index == SzikAppTab.menu) {
      _selectedTab = SzikAppTab.menu;
      _selectedSubMenu = _lastMenuLink?.currentSubMenu ?? SzikAppSubMenu.none;
      _selectedFeature = _lastMenuLink?.currentFeature ?? SzikAppFeature.none;
    } else {
      if (_selectedTab == SzikAppTab.menu && index != SzikAppTab.menu) {
        _lastMenuLink = SzikAppLink(
          currentTab: _selectedTab,
          currentSubMenu: _selectedSubMenu,
          currentFeature: _selectedFeature,
        );
      }
      _selectedTab = index;
      _selectedSubMenu = SzikAppSubMenu.none;
      _selectedFeature = SzikAppFeature.none;
    }
    notifyListeners();
  }

  void selectSubMenu(int index) {
    _selectedSubMenu = index;
    notifyListeners();
  }

  void unselectSubMenu() {
    _selectedSubMenu = SzikAppSubMenu.none;
    notifyListeners();
  }

  void selectFeature(int feature) {
    /*if (feature == SzikAppFeature.settings) {
      _selectedTab = SzikAppTab.settings;
    } else*/
    if (feature == SzikAppFeature.profile) {
      _selectedTab = SzikAppTab.feed;
    } else {
      _selectedTab = SzikAppTab.menu;
    }
    _selectedFeature = feature;
    notifyListeners();
  }

  void unselectFeature() {
    _selectedFeature = SzikAppFeature.none;
    notifyListeners();
  }
}

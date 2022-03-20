import 'package:easy_localization/easy_localization.dart';

import '../navigation/app_link.dart';
import '../utils/utils.dart';
import 'models.dart';

///Az applikáció aktuális felhasználóját megtestesítő osztály.
///Az autentikáció során jön létre és a kijelentkezésig megőrzi a felhasználó
///adatait a programban. Nem hozható létre önállóan, életciklusát az [Auth]
///menedzser osztály kezeli.
class User {
  late final String id;
  late String name;
  late final String email;
  late final Uri profilePicture;
  String? nick;
  DateTime? _birthday;
  String? _phone;
  String? _secondaryPhone;
  List<String>? groupIDs;
  List<Permission> _permissions;
  late final DateTime lastUpdate;

  DateTime? get birthday => _birthday;
  set birthday(DateTime? date) {
    if (date == null) {
      _birthday = null;
    } else if (date.isBefore(DateTime(1930, 1, 1)) ||
        date.isAfter(DateTime.now().subtract((const Duration(days: 6400))))) {
      throw NotValidBirthdayException(
          'ERROR_INVALID_VALUE'.tr(args: ['birthday', date.toIso8601String()]));
    } else {
      _birthday = date;
    }
  }

  String? get phone => _phone;
  set phone(String? value) {
    var validationPhone = RegExp(r'^((\+|00)\d{10,12})$');
    var validationHU = RegExp(r'^(\+36(20|30|70)\d{7})$');
    if (value == null) {
      _phone = null;
    } else if (validationPhone.hasMatch(value)) {
      _phone = value;
      if (!validationHU.hasMatch(value)) {
        throw NonHungarianPhoneException('ERROR_NON_HUNGARIAN_PHONE'.tr());
      }
    } else {
      throw NotValidPhoneException(
        'ERROR_INVALID_VALUE'.tr(args: ['phone', value]),
      );
    }
  }

  String? get secondaryPhone => _secondaryPhone;
  set secondaryPhone(String? value) {
    var validationPhone = RegExp(r'^((\+|00)\d{10,12})$');
    var validationHU = RegExp(r'^(\+36(20|30|70)\d{7})$');
    if (value == null) {
      _secondaryPhone = null;
    } else if (validationPhone.hasMatch(value)) {
      _secondaryPhone = value;
      if (!validationHU.hasMatch(value)) {
        throw NonHungarianPhoneException('ERROR_NON_HUNGARIAN_PHONE'.tr());
      }
    } else {
      throw NotValidPhoneException(
        'ERROR_INVALID_VALUE'.tr(args: ['phone', value]),
      );
    }
  }

  String get showableName => nick ?? name.split(' ')[1];
  String get initials {
    var splitted = name.split(' ');
    return '${splitted[0][0]}${splitted[1][0]}';
  }

  ///Konstruktor, ami a szerverről érkező [UserData] és a Firebase által
  ///biztosított [profilePicture] alapján létrehozza a felhasználót.
  User(this.profilePicture, UserData userData) : _permissions = [] {
    id = userData.id;
    name = userData.name;
    email = userData.email;
    nick = userData.nick;
    birthday = userData.birthday;
    phone = userData.phone;
    secondaryPhone = userData.secondaryPhone;
    groupIDs = userData.groupIDs;
    lastUpdate = userData.lastUpdate;
  }

  Map<int, Permission> featurePermissions = {
    0: Permission.calendarView,
    1: Permission.contactsView,
    2: Permission.documentsView,
    3: Permission.janitorView,
    4: Permission.cleaningView,
    5: Permission.pollView,
    6: Permission.profileView,
    7: Permission.reservationView,
  };

  Future<void> refreshPermissions() async {
    var io = IO();
    _permissions = await io.getUserPermissions();
  }

  //Future<bool> hasPermissionToAccess(SzikAppLink link) async {
  bool hasPermissionToAccess(SzikAppLink link) {
    if (_permissions.any((element) => element.index == 53)) return true;

    return _permissions.any((element) =>
        element.index == featurePermissions[link.currentFeature]!.index);
  }
}

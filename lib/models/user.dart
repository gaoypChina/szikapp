import 'package:easy_localization/easy_localization.dart';

import '../utils/exceptions.dart';
import '../utils/io.dart';
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
  List<Permission>? _permissions;
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

  ///Konstruktor, ami a szerverről érkező [UserData] és a Firebase által
  ///biztosított [profilePicture] alapján létrehozza a felhasználót.
  User(this.profilePicture, UserData userData) {
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

  ///Eldönti, hogy a felhasználónak van-e jogosultsága egy adott művelet
  ///végrehajtására egy adott adaton.
  Future<bool> hasPermission(Permission type, dynamic subject) async {
    var io = IO();
    _permissions ??= await io.getUserPermissions(null);

    if (type == Permission.pollEdit ||
        type == Permission.pollResultsView ||
        type == Permission.pollResultsExport) {
      if (subject.runtimeType != PollTask) throw TypeError();
      var poll = subject as PollTask;
      return poll.issuerIDs.contains(id) && _permissions!.contains(type);
    }

    if (type == Permission.cleaningExchangeOffer ||
        type == Permission.cleaningExchangeAccept ||
        type == Permission.cleaningExchangeReject) {
      if (subject.runtimeType != CleaningExchange) throw TypeError();
      var cleaningex = subject as CleaningExchange;
      return cleaningex.initiatorID.contains(id) &&
          _permissions!.contains(type);
    }

    if (type == Permission.janitorTaskEdit ||
        type == Permission.janitorTaskSolutionAccept) {
      if (subject.runtimeType != JanitorTask) throw TypeError();
      var janitor = subject as JanitorTask;
      return janitor.involvedIDs!.contains(id) && _permissions!.contains(type);
    }

    if (type == Permission.reservationEdit) {
      if (subject.runtimeType != TimetableTask) throw TypeError();
      var task = subject as TimetableTask;
      return task.organizerIDs.contains(id) && _permissions!.contains(type);
    }

    return _permissions!.contains(type);
  }
}

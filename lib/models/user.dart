import 'package:easy_localization/easy_localization.dart';

import '../navigation/navigation.dart';
import '../utils/utils.dart';
import 'models.dart';

///Az applikáció aktuális felhasználóját megtestesítő osztály.
///Az autentikáció során jön létre és a kijelentkezésig megőrzi a felhasználó
///adatait a programban. Nem hozható létre önállóan, életciklusát az [Auth]
///menedzser osztály kezeli.
class User {
  final String id;
  final String name;
  final String email;
  final Uri profilePicture;
  String? nick;
  DateTime? _birthday;
  String? _phone;
  String? _secondaryPhone;
  List<String> groupIDs;
  List<Permission> _permissions;
  final DateTime lastUpdate;

  User(this.profilePicture, UserData userData)
      : id = userData.id,
        name = userData.name,
        email = userData.email,
        nick = userData.nick,
        _birthday = userData.birthday,
        _phone = userData.phone,
        _secondaryPhone = userData.secondaryPhone,
        groupIDs = userData.groupIDs,
        _permissions = userData.permissions,
        lastUpdate = userData.lastUpdate;

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

  Future<void> refreshPermissions() async {
    var io = IO();
    _permissions = await io.getUserPermissions();
  }

  bool hasPermissionToAccess(SzikAppLink link) {
    if (_permissions.any((element) => element.toShortString() == 'admin')) {
      return true;
    }
    return _permissions.any((element) =>
        element.index == featurePermissions[link.currentFeature]?.index);
  }

  bool hasPermissionToCreate(Type type) {
    if (type == PollTask) {
      return _permissions.contains(Permission.pollCreate);
    } else {
      return true;
    }
  }

  bool hasPermissionToRead(Task task) {
    if (task.runtimeType == PollTask) {
      return task.participantIDs.contains(id);
    } else {
      return true;
    }
  }

  bool hasPermissionToModify(Task task) {
    return task.managerIDs.contains(id);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';

import '../navigation/navigation.dart';
import '../utils/utils.dart';
import 'interfaces.dart';
import 'models.dart';

part 'user.g.dart';

///Az applikáció aktuális felhasználóját megtestesítő osztály.
///Az autentikáció során jön létre és a kijelentkezésig megőrzi a felhasználó
///adatait a programban. Nem hozható létre önállóan, életciklusát az [Auth]
///menedzser osztály kezeli.
@JsonSerializable(explicitToJson: true)
class User implements Identifiable, Cachable {
  @override
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'profile_picture')
  String? profilePicture;
  String? nick;
  DateTime? _birthday;
  String? _phone;
  Preferences? preferences;
  @JsonKey(name: 'secondary_phone')
  String? _secondaryPhone;
  @JsonKey(name: 'group_ids')
  List<String> groupIDs;
  List<Permission> permissions;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  User({
    required this.id,
    required this.name,
    this.nick,
    required this.email,
    String? phone,
    String? secondaryPhone,
    this.preferences,
    DateTime? birthday,
    this.permissions = const [],
    this.groupIDs = const [],
    this.profilePicture,
    required this.lastUpdate,
  }) {
    this.birthday = birthday;
    this.phone = phone;
    this.secondaryPhone = secondaryPhone;
  }

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

  String get showableName {
    if (name.isEmpty) return '';
    return nick ?? name.split(' ')[1];
  }

  String get initials {
    var splitted = name.split(' ');
    return '${splitted[0][0]}${splitted[1][0]}';
  }

  Future<void> refreshPermissions() async {
    var io = IO();
    permissions = await io.getUserPermissions();
  }

  bool hasPermission(Permission permission) {
    return permissions.any((element) => element == permission);
  }

  bool hasPermissionToAccess(SzikAppLink link) {
    if (permissions.any((element) => element == Permission.admin)) {
      return true;
    }
    return permissions.any((element) =>
        element.index == featurePermissions[link.currentFeature]?.index);
  }

  bool hasPermissionToCreate(Type type) {
    if (permissions.any((element) => element == Permission.admin)) {
      return true;
    }
    if (type == PollTask) {
      return permissions.contains(Permission.pollCreate);
    } else {
      return true;
    }
  }

  bool hasPermissionToRead(Task task) {
    if (permissions.any((element) => element == Permission.admin)) {
      return true;
    }
    if (task.runtimeType == PollTask) {
      return permissions.contains(Permission.pollView) &&
          task.participantIDs.contains(id);
    } else {
      return true;
    }
  }

  bool hasPermissionToModify(Task task) {
    if (permissions.any((element) => element == Permission.admin)) {
      return true;
    }
    return task.managerIDs.contains(id);
  }

  Json toJson() => _$UserToJson(this);

  factory User.fromJson(Json json) => _$UserFromJson(json);

  String userAsString() {
    return '#$id $name';
  }

  bool isEqual(User other) {
    return id == other.id;
  }

  @override
  String toString() => name;
}

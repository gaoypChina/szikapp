import '../models/permission.dart';
import '../models/user_data.dart';
import 'exceptions.dart';
import 'io.dart';

class User {
  //Tagváltozók
  late String name;
  late String email;
  late Uri profilePicture;
  String? nick;
  DateTime? _birthday;
  String? _phone;
  String? _secondaryPhone;
  List<String>? groupIDs;
  List<Permission>? _permissions;

  //Setterek és getterek
  DateTime? get birthday => _birthday;
  set birthday(DateTime? date) {
    if (date!.isBefore(DateTime(1960, 1, 1))) {
      throw ArgumentError();
    } else {
      _birthday = date;
    }
  }

  String? get phone => _phone;
  set phone(String? value) {
    var validationPhone = RegExp(r'^((\+|00)\d{10,12})$');
    var validationHU = RegExp(r'^(\+36(20|30|70)\d{7})$');
    if (validationPhone.hasMatch(value!)) {
      _phone = value;
      if (!validationHU.hasMatch(value)) {
        throw NonHungarianPhoneException('');
      }
    } else {
      throw ArgumentError();
    }
  }

  String? get secondaryPhone => _secondaryPhone;
  set secondaryPhone(String? value) {
    var validationPhone = RegExp(r'^((\+|00)\d{10,12})$');
    var validationHU = RegExp(r'^(\+36(20|30|70)\d{7})$');
    if (validationPhone.hasMatch(value!)) {
      _secondaryPhone = value;
      if (!validationHU.hasMatch(value)) {
        throw NonHungarianPhoneException('');
      }
    } else {
      throw ArgumentError();
    }
  }

  //Publikus függvények aka Interface
  User.guest({required this.email, this.name = 'guest'}) {
    profilePicture = Uri.parse('../assets/default.png'); //TODO csere
    groupIDs = <String>[];
  }
  User(this.profilePicture, UserData userData) {
    name = userData.name;
    email = userData.email;
    nick = userData.nick;
    birthday = userData.birthday;
    phone = userData.phone;
    secondaryPhone = userData.secondaryPhone;
    groupIDs = userData.groupIDs;
  }

  Future<bool> hasPermission(Permission type, Object subject) async {
    //TODO kezdeni valamit a subjecttel
    if (_permissions != null) {
      return _permissions!.contains(type) ? true : false;
    }
    var io = IO();
    _permissions ??= await io.getUserPermissions(null);
    return _permissions!.contains(type) ? true : false;
  }
}

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
    var expression = RegExp(
        r'^[\+36|\+421][0-9]{8,9}$'); //TODO telefonszámok különböző országból
    if (expression.hasMatch(value!)) {
      _phone = value;
    } else {
      throw ArgumentError();
    }
  }

  String? get secondaryPhone => _phone;
  set secondaryPhone(String? value) {
    var expression = RegExp(
        r'^[\+36|\+421][0-9]{8,9}$'); //TODO telefonszámok különböző országból
    if (expression.hasMatch(value!)) {
      _phone = value;
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
    _permissions ??= await io.getUserPermissions();
    return _permissions!.contains(type) ? true : false;
  }
}

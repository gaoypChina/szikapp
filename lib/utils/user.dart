import '../models/cleaning_exchange.dart';
import '../models/permission.dart';
import '../models/tasks.dart';
import '../models/user_data.dart';
import 'exceptions.dart';
import 'io.dart';

class User {
  //Tagváltozók
  late final String id;
  late String name;
  late String email;
  late Uri profilePicture;
  String? nick;
  DateTime? _birthday;
  String? _phone;
  String? _secondaryPhone;
  List<String>? groupIDs;
  List<Permission>? _permissions;
  late final DateTime lastUpdate;

  //Setterek és getterek
  DateTime? get birthday => _birthday;
  set birthday(DateTime? date) {
    if (date == null)
      _birthday = null;
    else if (date.isBefore(DateTime(1960, 1, 1))) {
      throw ArgumentError();
    } else {
      _birthday = date;
    }
  }

  String? get phone => _phone;
  set phone(String? value) {
    var validationPhone = RegExp(r'^((\+|00)\d{10,12})$');
    var validationHU = RegExp(r'^(\+36(20|30|70)\d{7})$');
    if (value == null)
      _phone = null;
    else if (validationPhone.hasMatch(value)) {
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
    if (value == null)
      _secondaryPhone = null;
    else if (validationPhone.hasMatch(value)) {
      _secondaryPhone = value;
      if (!validationHU.hasMatch(value)) {
        throw NonHungarianPhoneException('');
      }
    } else {
      throw ArgumentError();
    }
  }

  //Publikus függvények aka Interface
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

  Future<bool> hasPermission(Permission type, dynamic subject) async {
    var io = IO();
    _permissions ??= await io.getUserPermissions(null);

    if (type == Permission.pollEdit ||
        type == Permission.pollResultsView ||
        type == Permission.pollResultsExport) {
      if (subject.runtimeType != PollTask) throw TypeError();
      var poll = subject as PollTask;
      return poll.issuerIDs.contains(id) && _permissions!.contains(type)
          ? true
          : false;
    }

    if (type == Permission.cleaningExchangeOffer ||
        type == Permission.cleaningExchangeAccept ||
        type == Permission.cleaningExchangeReject) {
      if (subject.runtimeType != CleaningExchange) throw TypeError();
      var cleaningex = subject as CleaningExchange;
      return cleaningex.initiatorID.contains(id) && _permissions!.contains(type)
          ? true
          : false;
    }

    if (type == Permission.janitorTaskEdit ||
        type == Permission.janitorTaskSolutionAccept) {
      if (subject.runtimeType != JanitorTask) throw TypeError();
      var janitor = subject as JanitorTask;
      return janitor.involvedIDs!.contains(id) && _permissions!.contains(type)
          ? true
          : false;
    }

    if (type == Permission.reservationEdit) {
      if (subject.runtimeType != TimetableTask) throw TypeError();
      var tttask = subject as TimetableTask;
      return tttask.organizerIDs.contains(type) && _permissions!.contains(type)
          ? true
          : false;
    }

    return _permissions!.contains(type) ? true : false;
  }
}

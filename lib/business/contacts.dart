import 'dart:core';

import 'package:url_launcher/url_launcher.dart';

import '../models/user_data.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

class Contacts {
  late List<UserData> contacts;

  static final Contacts _instance = Contacts._privateConstructor();
  factory Contacts() => _instance;
  Contacts._privateConstructor();

  List<UserData> search(String text) {
    if (text == '') {
      return contacts;
    } else {
      var results = <UserData>[];
      for (var item in contacts) {
        if (item.name.contains(text)) results.add(item);
      }
      return results;
    }
  }

  List<UserData> filter(String groupID) {
    if (groupID == '') {
      return contacts;
    } else {
      var results = <UserData>[];
      for (var item in contacts) {
        if (item.name.contains(groupID)) results.add(item);
      }
      return results;
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw NotSupportedCallFunctionalityException(url);
    }
  }

  Future<void> makeEmail(String emailAddress) async {
    var url = 'mailto:$emailAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw NotSupportedEmailFunctionalityException(url);
    }
  }

  Future<void> refresh() async {
    var io = IO();
    contacts = await io.getContacts();
  }
}

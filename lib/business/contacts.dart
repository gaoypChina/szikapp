import 'dart:core';

import 'package:url_launcher/url_launcher.dart';

import '../models/user_data.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

class Contacts {
  late List<UserData> contacts;

  static final Contacts _instance = Contacts._privateConstructor();
  factory Contacts() => _instance;
  Contacts._privateConstructor() {
    contacts = <UserData>[];
  }

  List<UserData> search(String text) {
    if (text == '') {
      return contacts!;
    } else {
      var results = <UserData>[];
      for (var item in contacts!) {
        if (item.name.contains(text))
          results.add(item);
        else if (item.email.contains(text))
          results.add(item);
        else if (item.birthday != null) {
          var intInString = RegExp(r'\d{1,2}');
          var matches = intInString.allMatches(text);
          if (matches.length == 2 &&
              item.birthday!.month.toString() == matches.first.toString() &&
              item.birthday!.day.toString() == matches.last.toString()) {
            results.add(item);
          }
        }
      }
      return results;
    }
  }

  List<UserData> filter(String groupID) {
    if (groupID == '') {
      return contacts!;
    } else {
      var results = <UserData>[];
      for (var item in contacts!) {
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

  Future<void> refresh({bool forceRefresh = false}) async {
    var io = IO();

    if (contacts.isEmpty || forceRefresh) {
      contacts = await io.getContacts();
    }
  }
}

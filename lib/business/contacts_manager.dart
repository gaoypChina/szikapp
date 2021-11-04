import 'dart:core';

import 'package:url_launcher/url_launcher.dart';

import '../models/user_data.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

///Telefonkönyv funkció logikai működését megvalósító singleton háttérosztály.
class ContactsManager {
  ///Kontaktok listája
  List<UserData> _contacts = [];

  ///Singleton osztálypéldány
  static final ContactsManager _instance =
      ContactsManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory ContactsManager() => _instance;

  ///Privát konstruktor, ami inicializálja a [contacts] változót.
  ContactsManager._privateConstructor();

  List<UserData> get contacts => List.unmodifiable(_contacts);

  ///Keresés. A függvény a megadott szöveg alapján keres egyezéseket a
  ///kontaktlista név, ímélcím, telefonszám, születésnap mezőiben. Ha a
  ///megadott keresőkifejezés üres, a teljes listával tér vissza.
  List<UserData> search(String text) {
    if (text == '') {
      return contacts;
    } else {
      var results = <UserData>[];
      for (var item in contacts) {
        if (item.name.toLowerCase().contains(text.toLowerCase())) {
          results.add(item);
        } else if (item.email.contains(text.toLowerCase())) {
          results.add(item);
        } else if (item.phone != null) {
          if (item.phone!.contains(text)) results.add(item);
        } else if (item.birthday != null) {
          var intInString = RegExp(r'\d{1,2}');
          var matches = intInString.allMatches(text);
          if (matches.length == 2 &&
              item.birthday!.month.toString() ==
                  matches.first.group(0).toString() &&
              item.birthday!.day.toString() ==
                  matches.last.group(0).toString()) {
            results.add(item);
          }
        }
      }
      return results;
    }
  }

  ///Szűrés. A függvény a megadott csoport azonosító alapján visszaadja a
  ///csoport tagjait. Ha az azonosító üres, a teljes listával tér vissza.
  List<UserData> filter(String groupID) {
    if (groupID == '') {
      return contacts;
    } else {
      var results = <UserData>[];
      for (var item in contacts) {
        if (item.groupIDs != null) {
          if (item.groupIDs!.contains(groupID)) results.add(item);
        }
      }
      return results;
    }
  }

  ///Hívásindítás. A függvény a megadott számot átviszi a telefon tárcsázójába,
  ///ahonnan a szám már gombnyomásra hívható.
  Future<void> makePhoneCall(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw NotSupportedCallFunctionalityException(url);
    }
  }

  ///Ímél írása. A függvény a megadott címmel elindítja a telefonon
  ///alapértelmezett levelező klienst.
  Future<void> makeEmail(String emailAddress) async {
    var url = 'mailto:$emailAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw NotSupportedEmailFunctionalityException(url);
    }
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb kontaktlistát. Ha
  ///a [forceRefresh] paraméter Igaz értékű vagy a kontaklista üres, a frissítés
  ///mindenképp megtörténik.
  Future<void> refresh({bool forceRefresh = false}) async {
    var io = IO();

    if (contacts.isEmpty || forceRefresh) {
      _contacts = await io.getContacts();
    }
  }
}

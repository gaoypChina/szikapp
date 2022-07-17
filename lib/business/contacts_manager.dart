import 'dart:core';

import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../utils/exceptions.dart';
import '../utils/io.dart';

///Telefonkönyv funkció logikai működését megvalósító singleton háttérosztály.
class ContactsManager {
  ///Kontaktok listája
  List<User> _contacts = [];
  List<Group> _groups = [];

  ///Singleton osztálypéldány
  static final ContactsManager _instance =
      ContactsManager._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory ContactsManager() => _instance;

  ///Privát konstruktor, ami inicializálja a [contacts] változót.
  ContactsManager._privateConstructor();

  ///A felhasználó kontaktjainak listája.
  List<User> get contacts => List.unmodifiable(_contacts);

  ///A szervezetbeli csoportok listája. Tartalmazza azokat a csoportokat
  ///is, melyeknek a felhasználó egyébként nem tagja.
  List<Group> get groups => List.unmodifiable(_groups);

  set groups(List<Group> groups) => _groups = groups;

  ///Keresés. A függvény a megadott szöveg alapján keres egyezéseket a
  ///kontaktlista név, ímélcím, telefonszám, születésnap mezőiben. Ha a
  ///megadott keresőkifejezés üres, a teljes listával tér vissza.
  List<User> search(String text) {
    if (text == '') {
      return contacts;
    } else {
      var results = <User>[];
      for (var item in contacts) {
        var emailUserName = item.email.substring(0, item.email.indexOf('@'));
        if (item.name.toLowerCase().contains(text.toLowerCase())) {
          results.add(item);
        } else if (emailUserName.contains(text.toLowerCase())) {
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

  ///Keresés a csoportok között. A függvény a megadott szöveg alapján keres
  ///egyezéseket a csoportlista név és ímélcím mezőiben.
  ///Ha a megadott keresőkifejezés üres, a teljes listával tér vissza.
  List<Group> findGroup(String text) {
    if (text == '') {
      return groups;
    } else {
      var results = <Group>[];
      for (var item in groups) {
        if (item.name.toLowerCase().contains(text.toLowerCase())) {
          results.add(item);
        } else if (item.email != null &&
            item.email!.contains(text.toLowerCase())) {
          results.add(item);
        }
      }
      return results;
    }
  }

  ///Szűrés. A függvény a megadott csoport azonosító alapján visszaadja a
  ///csoport tagjait. Ha az azonosító üres, a teljes listával tér vissza.
  List<User> findMembers(String groupID) {
    if (groupID == '') {
      return contacts;
    } else {
      var results = <User>[];
      for (var item in contacts) {
        if (item.groupIDs.contains(groupID)) results.add(item);
      }
      return results;
    }
  }

  ///Hívásindítás. A függvény a megadott számot átviszi a telefon tárcsázójába,
  ///ahonnan a szám már gombnyomásra hívható.
  Future<void> makePhoneCall(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw NotSupportedCallFunctionalityException(url);
    }
  }

  ///Ímél írása. A függvény a megadott címmel elindítja a telefonon
  ///alapértelmezett levelező klienst.
  Future<void> makeEmail(String emailAddress) async {
    var url = 'mailto:$emailAddress';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw NotSupportedEmailFunctionalityException(url);
    }
  }

  ///Frissítés. A függvény lekéri a szerverről a legfrissebb kontakt- és
  ///csoportlistát. Ha a [forceRefresh] paraméter Igaz értékű vagy a
  ///kontakt- vagy a csoportlista üres, a frissítés mindenképp megtörténik.
  Future<void> refresh({bool forceRefresh = false}) async {
    var io = IO();

    if (_contacts.isEmpty || forceRefresh) {
      try {
        _contacts = await io.getContacts();
      } on IONotModifiedException {
        _contacts = [];
      }
    }
    if (_groups.isEmpty || forceRefresh) {
      try {
        _groups = await io.getGroup();
      } on IONotModifiedException {
        _groups = [];
      }
    }
  }
}

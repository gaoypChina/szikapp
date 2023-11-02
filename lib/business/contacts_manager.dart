import 'dart:core';

import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../utils/utils.dart';

///Telefonkönyv funkció logikai működését megvalósító singleton háttérosztály.
class ContactsManager {
  ///Kontaktok listája
  List<User> _contacts = [];
  List<Group> _groups = [];

  static const String collegeMembersGroupID = 'g100';
  static const String tenantsGroupID = 'g106';

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
  List<User> search({required String text}) {
    if (text == '') {
      return contacts;
    } else {
      var results = <User>[];
      for (var contact in contacts) {
        var emailUserName =
            contact.email.substring(0, contact.email.indexOf('@'));
        if (contact.name.toLowerCase().contains(text.toLowerCase())) {
          results.add(contact);
        } else if (emailUserName.contains(text.toLowerCase())) {
          results.add(contact);
        } else if (contact.phone != null) {
          if (contact.phone!.contains(text)) results.add(contact);
        } else if (contact.birthday != null) {
          var intInString = RegExp(r'\d{1,2}');
          var matches = intInString.allMatches(text);
          if (matches.length == 2 &&
              contact.birthday!.month.toString() ==
                  matches.first.group(0).toString() &&
              contact.birthday!.day.toString() ==
                  matches.last.group(0).toString()) {
            results.add(contact);
          }
        }
      }
      return results;
    }
  }

  ///Keresés a csoportok között. A függvény a megadott szöveg alapján keres
  ///egyezéseket a csoportlista név és ímélcím mezőiben.
  ///Ha a megadott keresőkifejezés üres, a teljes listával tér vissza.
  List<Group> findGroup({required String text}) {
    if (text == '') {
      return groups;
    } else {
      var results = <Group>[];
      for (var group in groups) {
        if (group.name.toLowerCase().contains(text.toLowerCase())) {
          results.add(group);
        } else if (group.email != null &&
            group.email!.contains(text.toLowerCase())) {
          results.add(group);
        }
      }
      return results;
    }
  }

  ///Szűrés. A függvény a megadott csoport azonosító alapján visszaadja a
  ///csoport tagjait. Ha az azonosító üres, a teljes listával tér vissza.
  List<User> findMembers({required List<String?> groupIDs}) {
    if (groupIDs.isEmpty) {
      return contacts;
    } else {
      var results = <User>[];
      for (var contact in contacts) {
        for (var id in groupIDs) {
          if (contact.groupIDs.contains(id)) results.add(contact);
        }
      }
      return results;
    }
  }

  ///Hívásindítás. A függvény a megadott számot átviszi a telefon tárcsázójába,
  ///ahonnan a szám már gombnyomásra hívható.
  Future<void> makePhoneCall({required String phoneNumber}) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw NotSupportedCallFunctionalityException(url);
    }
  }

  ///Ímél írása. A függvény a megadott címmel elindítja a telefonon
  ///alapértelmezett levelező klienst.
  Future<void> makeEmail({required String address}) async {
    var url = 'mailto:$address';
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
      } on IOException {
        _contacts = [];
      }
    }
    if (_groups.isEmpty || forceRefresh) {
      try {
        _groups = await io.getGroup();
      } on IOException {
        _groups = [];
      }
    }
  }
}

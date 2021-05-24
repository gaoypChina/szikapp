import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/group.dart';
import '../models/permission.dart';
import '../models/preferences.dart';
import '../models/resource.dart';
import '../models/tasks.dart';
import '../models/user_data.dart';
import 'exceptions.dart';

///Az alapértelmezett [HttpClient] specifikus implementációja.
///Hozzáad egy callback-et a klienshez, hogy el lehessen fogadni az önaláírt
///TLS/SSL tanusítványokat.
class IOHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

///Saját kliens/szerver adatkapcsolatot megvalósító osztály. Aszinkron
///fügvényekként implementálja az egyes API végpontokat, csak a szükséges
///parametrizációt engedve a hívó félnek. A metódusnevek az következő konvenció
///alapján állnak össze: `httpMetódusNév+VégpontNév` (pl. `getUser`).
class IO {
  ///Szerver cím
  final _vm_1 = 'https://130.61.246.41';

  ///Szerver cím
  final _vm_2 = 'https://130.61.59.166';

  //Végpontok nevei
  final _testEndpoint = '/test';
  final _userEndpoint = '/user';
  final _preferencesEndpoint = '/user/preferences';
  final _permissionsEndpoint = '/user/permissons';
  final _groupEndpoint = '/group';
  final _placeEndpoint = '/place';
  final _contactsEndpoint = '/contacts';
  final _pollEndpoint = '/poll';
  final _cleaningEndpoint = '/cleaning';
  final _cleaningExchangeEndpoint = '/cleaning/exchange';
  final _reservationEndpoint = '/reservation';
  final _janitorEndpoint = '/janitor';
  final _boardgameEndpoint = '/boardgame';

  ///Singleton példány
  static final IO _instance = IO._privateContructor();

  IO._privateContructor();

  ///[http.Client], ami összefogja az appból indított kéréseket
  final http.Client client = http.Client();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory IO() {
    return _instance;
  }

  //Metódusok

  ///Lekéri egy felhasználó adatait.
  Future<UserData> getUser([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      return UserData.fromJson(parsed['results']);
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új felhasználót.
  Future<bool> postUser(UserData data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissít egy létező felhasználót.
  Future<bool> putUser(UserData data, [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Töröl egy felhasználót.
  Future<bool> deleteUser(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri egy felhasználó mentett preferenciáit.
  Future<Preferences> getUserPreferences(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      return Preferences.fromJson(parsed['results']);
    }
    throw _handleErrors(response);
  }

  ///Elmenti egy felhasználó preferenciáit.
  Future<bool> putUserPreferences(Preferences data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli egy felhasználó preferenciáit.
  Future<bool> deleteUserPreferences([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders());

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a kollégiumi helyek (szűrt) listáját vagy egy konkrét helyiséget.
  Future<List<Place>> getPlace([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_placeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <Place>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var places = parsed['results'];
      places.forEach((item) {
        answer.add(Place.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új helyiséget.
  Future<bool> postPlace(Place data, [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_placeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti egy létező helyiség adatait.
  Future<bool> putPlace(Place data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_placeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri egy felhasználóhoz tartozó engedélyeket.
  Future<List<Permission>> getUserPermissions(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <Permission>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var permissions = parsed['results'];
      permissions.forEach((item) {
        answer.add(Permission.values
            .firstWhere((element) => element.toString() == 'Permission.$item'));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Egy csoport engedélyeit kibővíti a megadott jogosultságokkal.
  Future<bool> postGroupPermission(List<Permission> data,
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {
          ...await _commonHeaders(),
          ..._lastUpdateHeader(lastUpdate),
          ..._contentTypeHeader(),
        },
        body: json.encode({
          'data': {'permissions': data.toString()}
        }));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Egy csoport engedélyeit kibővíti a megadott jogosultsággal.
  Future<bool> patchGroupPermissions(Permission data,
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: {
          ...await _commonHeaders(),
          ..._lastUpdateHeader(lastUpdate),
          ..._contentTypeHeader(),
        },
        body: json.encode({
          'data': {'permissions': data.toString()}
        }));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Egy csoport engedélyei közül eltávolítja a megadott jogosultságot.
  Future<bool> putGroupPermissions(Permission data,
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {
          ...await _commonHeaders(),
          ..._lastUpdateHeader(lastUpdate),
          ..._contentTypeHeader(),
        },
        body: json.encode({
          'data': {'permissions': data.toString()}
        }));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Eltávolítja egy csoport összes jogosultságát.
  Future<bool> deleteUserPermission(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a (szűrt) gondnoki kérések listáját vagy egy konkrét kérést.
  Future<List<JanitorTask>> getJanitor(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <JanitorTask>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var tasks = parsed['results'];
      tasks.forEach((item) {
        answer.add(JanitorTask.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új gondnoki kérést.
  Future<bool> postJanitor(JanitorTask data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {
          ...await _commonHeaders(),
          ..._contentTypeHeader(),
        },
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Beállítja a megadott gondnoki kérés státusát.
  Future<bool> patchJanitor(
      TaskStatus data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({
          'data': {'status': data.toShortString()}
        }));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott gondnoki kérést.
  Future<bool> putJanitor(
      JanitorTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli a megadott gondnoki kérést.
  Future<bool> deleteJanitor(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a felhasználói csoportok listáját vagy egy konkrét csoportot.
  Future<List<Group>> getGroup([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <Group>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var groups = parsed['results'];
      groups.forEach((item) {
        answer.add(Group.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új felhasználói csoportot.
  Future<bool> postGroup(Group data, [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott felhasználói csoportot.
  Future<bool> putGroup(Group data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli a megadott felhasználói csoportot.
  Future<bool> deleteGroup(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a többi felhasználó vagy egy másik konkrét felhasználó adatait.
  Future<List<UserData>> getContacts([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_contactsEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <UserData>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var users = parsed['results'];
      users.forEach((item) {
        answer.add(UserData.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a konyhatakarítás cserék vagy egy konkrét csere adatait.
  Future<List<CleaningExchange>> getCleaningExchange(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <CleaningExchange>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var exchanges = parsed['results'];
      exchanges.forEach((item) {
        answer.add(CleaningExchange.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új  kanyhatakarítás-cserét.
  Future<bool> postCleaningExchange(CleaningExchange data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Felajánl vagy elfogad egy konyhatakarítás-csere ajánlatot.
  Future<bool> patchCleaningExchange(
      Map<String, String> parameters, DateTime lastUpdate,
      [String? data]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var body = json.encode({
      'data': {'replace_id': data}
    });
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: {
          ...await _commonHeaders(),
          ..._lastUpdateHeader(lastUpdate),
          ..._contentTypeHeader(),
        },
        body: data == null ? null : body);

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Visszavon vagy elutasít egy felajánlott konyhatakarítás-csere ajánlatot.
  Future<bool> putCleaningExchange(
      Map<String, String> parameters, DateTime lastUpdate,
      [String? data]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var body = json.encode({
      'data': {'replace_id': data}
    });
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {
          ...await _commonHeaders(),
          ..._lastUpdateHeader(lastUpdate),
          ..._contentTypeHeader(),
        },
        body: data == null ? null : body);

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli amegadott konyhatakarítás-cserét.
  Future<bool> deleteCleaningExchange(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a konyhatakarítás feladatok listáját vagy egy konkrét feladat
  ///adatait.
  Future<List<CleaningTask>> getCleaning(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <CleaningTask>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var tasks = parsed['results'];
      tasks.forEach((item) {
        answer.add(CleaningTask.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a konyhatakarítás periódusok vagy egy konkrét periódus adatait.
  Future<List<CleaningPeriod>> getCleaningPeriod(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    uri += 'period=true';
    var response = await client.get(Uri.parse(uri),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <CleaningPeriod>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var tasks = parsed['results'];
      tasks.forEach((item) {
        answer.add(CleaningPeriod.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új konyhatakarítás periódust.
  Future<bool> postCleaningPeriod(CleaningPeriod data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott konyhatakarítás periódust.
  Future<bool> patchCleaningPeriod(
      CleaningPeriod data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott konyhatakarítás feladatot.
  Future<bool> putCleaning(
      CleaningTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a szavazások listáját vagy egy konkrét szavazás adatait.
  Future<List<PollTask>> getPoll([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <PollTask>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var polls = parsed['results'];
      polls.forEach((item) {
        answer.add(PollTask.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új szavazást.
  Future<bool> postPoll(PollTask data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott szavazás adatait.
  Future<bool> patchPoll(PollTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Leadja a felhasználó szavazatát a megadott szavazásra.
  Future<bool> putPoll(Vote data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli a megadott szavazást.
  Future<bool> deletePoll(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a foglalások listáját vagy egy konkrét foglalás adatait.
  Future<List<TimetableTask>> getReservation(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <TimetableTask>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var timetables = parsed['results'];
      timetables.forEach((item) {
        answer.add(TimetableTask.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új foglalást.
  Future<bool> postReservation(TimetableTask data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott foglalás adatait.
  Future<bool> putReservation(
      TimetableTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli a megadott foglalást.
  Future<bool> deleteReservation(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Lekéri a társasjátékok listáját vagy egy konkrét játék adatait.
  Future<List<Boardgame>> getBoardgame(
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader()});

    if (response.statusCode == 200) {
      var answer = <Boardgame>[];
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      var timetables = parsed['results'];
      timetables.forEach((item) {
        answer.add(Boardgame.fromJson(item));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új társast.
  Future<bool> postBoardgame(Boardgame data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Frissíti a megadott társasjáték adatait.
  Future<bool> putBoardgame(
      Boardgame data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._contentTypeHeader()},
        body: json.encode({'data': data.toJson()}));

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Törli a megadott társast.
  Future<bool> deleteBoardgame(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  ///Hibakezelő függvény. A `HTTP` kérés válasz kódja alapján megfelelő kivételt
  ///emel.
  Exception _handleErrors(http.Response response) {
    if (response.statusCode >= 500)
      return IOServerException(
          '${response.statusCode.toString()}; ${utf8.decode(response.bodyBytes)}');
    else if (response.statusCode >= 400)
      return IOClientException(
          '${response.statusCode.toString()}; ${utf8.decode(response.bodyBytes)}');
    else if (response.statusCode == 304)
      return IONotModifiedException(
          '${response.statusCode.toString()}; ${utf8.decode(response.bodyBytes)}');
    else
      return IOUnknownException(
          '${response.statusCode.toString()}; ${utf8.decode(response.bodyBytes)}');
  }

  ///Autentikáció header-ök szerver oldali hitelesítéshez.
  Future<Map<String, String>> _commonHeaders() async {
    return {
      'User': SZIKAppState.authManager.firebaseUser?.email ?? '',
      'AuthToken': await SZIKAppState.authManager.getAuthToken(),
    };
  }

  ///Adatintegritás header. Jelzi a szervernek, hogy a kliens oldali adat
  ///mikor volt utoljára frissítve (vagyis szinkronban a szerverrel).
  Map<String, String> _lastUpdateHeader([DateTime? time]) {
    return time == null
        ? {'LastUpdate': DateTime(1998).toIso8601String()}
        : {'LastUpdate': time.toIso8601String()};
  }

  ///Adattípus header. `JSON` típusú kérés adatoknál kötelező megadni, hogy a
  ///szerver tudja értelmezni a kérést.
  Map<String, String> _contentTypeHeader() {
    return {'Content-Type': 'application/json'};
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../business/business.dart';
import '../models/models.dart';
import 'exceptions.dart';
import 'types.dart';

class ApiResponseCode {
  static const int ok = 200;
  static const int created = 201;
}

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
  ///Használt szerver címe
  ///Dev: https://130.61.246.41
  ///Prod: https://130.61.17.52
  ///Spare: https://130.61.59.166
  final _vmAddress = 'https://130.61.17.52/api/v2';

  //Végpontok nevei
  final _accountEndpoint = '/account';
  final _articleEndpoint = '/article';
  final _birthdayEndpoint = '/birthday';
  final _boardgameEndpoint = '/boardgame';
  final _cleaningTaskEndpoint = '/cleaning/tasks';
  final _cleaningAssignEndpoint = '/cleaning/tasks/assign';
  final _cleaningExchangeEndpoint = '/cleaning/exchange';
  final _cleaningExchangeOfferEndpoint = '/cleaning/exchange/offer';
  final _cleaningExchangeAcceptEndpoint = '/cleaning/exchange/accept';
  final _cleaningExchangeWithdrawEndpoint = '/cleaning/exchange/withdraw';
  final _cleaningExchangeRejectEndpoint = '/cleaning/reject';
  final _cleaningParticipantsEndpoint = '/cleaning/participants';
  final _cleaningPeriodEndpoint = '/cleaning/periods';
  final _contactsEndpoint = '/contacts';
  final _fcmEndpoint = '/fcm';
  final _goodToKnowEndpoint = '/goodtoknow';
  final _groupEndpoint = '/group';
  final _invitationEndpoint = '/invitation';
  final _janitorEndpoint = '/janitor';
  final _placeEndpoint = '/place';
  final _pollEndpoint = '/poll';
  final _userEndpoint = '/user';
  final _permissionEndpoint = '/user/permission';
  final _preferencesEndpoint = '/user/preferences';
  final _reservationEndpoint = '/reservation';

  static AuthManager? authManager;

  ///Singleton példány
  static final IO _instance = IO._privateContructor();

  IO._privateContructor();

  ///Instance getter. Visszaadja a singleton példányt.
  static IO get instance => _instance;

  ///[http.Client], ami összefogja az appból indított kéréseket
  final http.Client client = http.Client();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory IO({AuthManager? manager}) {
    authManager ??= manager;
    return _instance;
  }

  //Metódusok

  ///Lekéri egy felhasználó adatait.
  Future<User> getUser({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(parsed);
    }
    throw _handleErrors(response);
  }

  ///Frissíti egy felhasználó adatait.
  Future<void> putUser({required User data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Lekéri egy felhasználó mentett preferenciáit.
  Future<Preferences> getUserPreferences({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      return Preferences.fromJson(parsed);
    }
    throw _handleErrors(response);
  }

  ///Elmenti egy felhasználó preferenciáit.
  Future<void> postUserPreferences(
      {required Preferences data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Elmenti egy felhasználó tokenjét.
  Future<void> saveFCMToken({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_fcmEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode != ApiResponseCode.created) {
      throw _handleErrors(response);
    }
  }

  ///Törli egy felhasználó preferenciáit.
  Future<void> deleteUserPreferences({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Lekéri a kollégiumi helyek (szűrt) listáját vagy egy konkrét helyiséget.
  Future<List<Place>> getPlace({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_placeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <Place>[];
      var places = json.decode(utf8.decode(response.bodyBytes));
      places.forEach((place) {
        answer.add(Place.fromJson(place));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri egy felhasználóhoz tartozó engedélyeket.
  Future<List<Permission>> getUserPermissions(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_permissionEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <Permission>[];
      var permissions = json.decode(utf8.decode(response.bodyBytes));
      permissions.forEach((permission) {
        answer.add(Permission.values.firstWhere(
            (enumValue) => enumValue.toString() == 'Permission.$permission'));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a (szűrt) gondnoki kérések listáját vagy egy konkrét kérést.
  Future<List<JanitorTask>> getJanitor({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_janitorEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <JanitorTask>[];
      var tasks = json.decode(utf8.decode(response.bodyBytes));
      tasks.forEach((task) {
        answer.add(JanitorTask.fromJson(task));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új gondnoki kérést.
  Future<void> postJanitor(
      {required JanitorTask data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_janitorEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.created) {
      throw _handleErrors(response);
    }
  }

  ///Frissíti a megadott gondnoki kérést.
  Future<void> putJanitor(
      {required JanitorTask data, required KeyValuePairs parameters}) async {
    var uri = '$_vmAddress$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Törli a megadott gondnoki kérést.
  Future<void> deleteJanitor(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)},
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Lekéri a felhasználói csoportok listáját vagy egy konkrét csoportot.
  Future<List<Group>> getGroup({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_groupEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <Group>[];
      var groups = json.decode(utf8.decode(response.bodyBytes));
      groups.forEach((group) {
        answer.add(Group.fromJson(group));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a többi felhasználó vagy egy másik konkrét felhasználó adatait.
  Future<List<User>> getContacts({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_contactsEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <User>[];
      var users = json.decode(utf8.decode(response.bodyBytes));
      users.forEach((user) {
        answer.add(User.fromJson(user));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri az aktuális cikkeket.
  Future<List<Article>> getArticles({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_articleEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1));

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <Article>[];
      var articles = json.decode(utf8.decode(response.bodyBytes));
      articles.forEach((article) {
        answer.add(Article.fromJson(article));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a többi felhasználó vagy egy másik konkrét felhasználó adatait.
  Future<List<TimetableTask>> getInvitations(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_invitationEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: _lastUpdateHeader(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <TimetableTask>[];
      var invitations = json.decode(utf8.decode(response.bodyBytes));
      invitations.forEach((invitation) {
        answer.add(TimetableTask.fromJson(invitation));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a három legközelebbi születésű felhasználó adatait.
  Future<List<User>> getBirthdays({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_birthdayEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    uri += 'localTime=${DateTime.now().toIso8601String()}';
    var response =
        await client.get(Uri.parse(uri), headers: await _commonHeaders());

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <User>[];
      var users = json.decode(utf8.decode(response.bodyBytes));
      users.forEach((user) {
        answer.add(User.fromJson(user));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a konyhatakarítás cserék vagy egy konkrét csere adatait.
  Future<List<CleaningExchange>> getCleaningExchange(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningExchangeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <CleaningExchange>[];
      var exchanges = json.decode(utf8.decode(response.bodyBytes));
      exchanges.forEach((exchange) {
        answer.add(CleaningExchange.fromJson(exchange));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új  kanyhatakarítás-cserét.
  Future<void> postCleaningExchange(
      {required CleaningExchange data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningExchangeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.created) {
      throw _handleErrors(response);
    }
  }

  ///Felajánl egy konyhatakarítás-csere ajánlatot.
  Future<void> getCleaningExchangeOffer(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_cleaningExchangeOfferEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {
        ...await _commonHeaders(),
        ..._lastUpdateHeader(lastUpdate),
        ..._contentTypeHeader(),
      },
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Elfogad egy felajánlott konyhatakarítás-csere ajánlatot.
  Future<void> getCleaningExchangeAccept(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_cleaningExchangeAcceptEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {
        ...await _commonHeaders(),
        ..._lastUpdateHeader(lastUpdate),
        ..._contentTypeHeader(),
      },
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Visszavon egy felajánlott konyhatakarítás-csere ajánlatot.
  Future<void> getCleaningExchangeWithdraw(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_cleaningExchangeWithdrawEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {
        ...await _commonHeaders(),
        ..._lastUpdateHeader(lastUpdate),
        ..._contentTypeHeader(),
      },
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Elutasít egy felajánlott konyhatakarítás-csere ajánlatot.
  Future<void> getCleaningExchangeReject(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_cleaningExchangeRejectEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {
        ...await _commonHeaders(),
        ..._lastUpdateHeader(lastUpdate),
        ..._contentTypeHeader(),
      },
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Törli amegadott konyhatakarítás-cserét.
  Future<void> deleteCleaningExchange(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)},
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Lekéri a konyhatakarítás feladatok listáját vagy egy konkrét feladat
  ///adatait.
  Future<List<CleaningTask>> getCleaningTask(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningTaskEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <CleaningTask>[];
      var tasks = json.decode(utf8.decode(response.bodyBytes));
      tasks.forEach((task) {
        answer.add(CleaningTask.fromJson(task));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a konyhatakarítás periódusok vagy egy konkrét periódus adatait.
  Future<List<CleaningPeriod>> getCleaningPeriod(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningPeriodEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <CleaningPeriod>[];
      var periods = json.decode(utf8.decode(response.bodyBytes));
      periods.forEach((period) {
        answer.add(CleaningPeriod.fromJson(period));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új konyhatakarítás periódust.
  Future<void> postCleaningPeriod(
      {required CleaningPeriod data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningPeriodEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.created) {
      throw _handleErrors(response);
    }
  }

  ///Frissíti a megadott konyhatakarítás periódust.
  Future<void> putCleaningPeriod(
      {required CleaningPeriod data, required KeyValuePairs parameters}) async {
    var uri = '$_vmAddress$_cleaningPeriodEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Frissíti a megadott konyhatakarítás feladatot.
  Future<void> putCleaningTask(
      {required CleaningTask data, required KeyValuePairs parameters}) async {
    var uri = '$_vmAddress$_cleaningTaskEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  Future<CleaningParticipants> getCleaningParticipants(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningParticipantsEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      return CleaningParticipants.fromJson(parsed);
    }
    throw _handleErrors(response);
  }

  Future<void> putCleaningParticipants(
      {required CleaningParticipants data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_cleaningParticipantsEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Automatikusan beosztja a takarítókat a következő periódusra.
  Future<void> getCleaningAutoAssign() async {
    var uri = '$_vmAddress$_cleaningAssignEndpoint';
    var response =
        await client.get(Uri.parse(uri), headers: await _commonHeaders());

    if (response.statusCode == ApiResponseCode.ok) {
      var results = json.decode(utf8.decode(response.bodyBytes));
      switch (results) {
        case cleaningAssignPeriodShrink:
          throw InformationException(cleaningAssignPeriodShrink, '');
        case cleaningAssignPeriodExtended:
          throw InformationException(cleaningAssignPeriodExtended, '');
        case cleaningAssignPeriodExtendedWithEmptyEnd:
          throw InformationException(
              cleaningAssignPeriodExtendedWithEmptyEnd, '');
        case cleaningAssigned:
          throw InformationException(cleaningAssigned, '');
        case cleaningAssignedWithEmptyEnd:
          throw InformationException(cleaningAssignedWithEmptyEnd, '');
        default:
          return;
      }
    }
    throw _handleErrors(response);
  }

  ///Lekéri a szavazások listáját vagy egy konkrét szavazás adatait.
  Future<List<PollTask>> getPoll({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_pollEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <PollTask>[];
      var polls = json.decode(utf8.decode(response.bodyBytes));
      polls.forEach((poll) => answer.add(PollTask.fromJson(poll)));
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új szavazást.
  Future<void> postPoll(
      {required PollTask data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_pollEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.created) {
      throw _handleErrors(response);
    }
  }

  ///Frissíti a megadott szavazás adatait.
  Future<void> putPoll(
      {required PollTask data, required KeyValuePairs parameters}) async {
    var uri = '$_vmAddress$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Leadja a felhasználó szavazatát a megadott szavazásra.
  Future<void> patchPoll(
      {required Vote data, required KeyValuePairs parameters}) async {
    var uri = '$_vmAddress$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Törli a megadott szavazást.
  Future<void> deletePoll(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)},
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Lekéri a foglalások listáját vagy egy konkrét foglalás adatait.
  Future<List<TimetableTask>> getReservation(
      {KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_reservationEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <TimetableTask>[];
      var timetables = json.decode(utf8.decode(response.bodyBytes));
      timetables.forEach((task) {
        answer.add(TimetableTask.fromJson(task));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Létrehoz egy új foglalást.
  Future<void> postReservation(
      {required TimetableTask data, KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_reservationEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.created) {
      throw _handleErrors(response);
    }
  }

  ///Frissíti a megadott foglalás adatait.
  Future<void> putReservation(
      {required TimetableTask data, required KeyValuePairs parameters}) async {
    var uri = '$_vmAddress$_reservationEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._contentTypeHeader()},
      body: json.encode(data.toJson()),
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Törli a megadott foglalást.
  Future<void> deleteReservation(
      {required KeyValuePairs parameters, required DateTime lastUpdate}) async {
    var uri = '$_vmAddress$_reservationEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(
      Uri.parse(uri, 0, uri.length - 1),
      headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)},
    );

    if (response.statusCode != ApiResponseCode.ok) {
      throw _handleErrors(response);
    }
  }

  ///Lekéri a társasjátékok listáját vagy egy konkrét játék adatait.
  Future<List<Boardgame>> getBoardgame({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_boardgameEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <Boardgame>[];
      var games = json.decode(utf8.decode(response.bodyBytes));
      games.forEach((game) {
        answer.add(Boardgame.fromJson(game));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri az elérhető közösségi média és egyéb online fiókok listáját.
  Future<List<Account>> getAccount({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_accountEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <Account>[];
      var accounts = json.decode(utf8.decode(response.bodyBytes));
      accounts.forEach((account) {
        answer.add(Account.fromJson(account));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Lekéri a jótudni infók listáját vagy egy konkrét infó szekció adatait.
  Future<List<GoodToKnow>> getGoodToKnow({KeyValuePairs? parameters}) async {
    var uri = '$_vmAddress$_goodToKnowEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(
      Uri.parse(uri, 0, uri.length - 1),
      headers: await _commonHeaders(),
    );

    if (response.statusCode == ApiResponseCode.ok) {
      var answer = <GoodToKnow>[];
      var goodtoknows = json.decode(utf8.decode(response.bodyBytes));
      goodtoknows.forEach((goodtoknow) {
        answer.add(GoodToKnow.fromJson(goodtoknow));
      });
      return answer;
    }
    throw _handleErrors(response);
  }

  ///Hibakezelő függvény. A `HTTP` kérés válasz kódja alapján megfelelő kivételt
  ///emel.
  Exception _handleErrors(http.Response response) {
    if (response.statusCode >= 500) {
      return IOServerException(response.statusCode,
          '${response.statusCode}; ${utf8.decode(response.bodyBytes)}');
    } else if (response.statusCode == 409) {
      return IOConflictException(
          '${response.statusCode}; ${utf8.decode(response.bodyBytes)}');
    } else if (response.statusCode >= 400) {
      return IOClientException(response.statusCode,
          '${response.statusCode}; ${utf8.decode(response.bodyBytes)}');
    } else if (response.statusCode == 304) {
      return IONotModifiedException(
          '${response.statusCode}; ${utf8.decode(response.bodyBytes)}');
    } else {
      return IOUnknownException(response.statusCode,
          '${response.statusCode}; ${utf8.decode(response.bodyBytes)}');
    }
  }

  ///Autentikáció header-ök szerver oldali hitelesítéshez.
  Future<KeyValuePairs> _commonHeaders() async {
    if (authManager == null) {
      throw IOClientException(900, 'Authorized user not found.');
    }
    return {
      'User': authManager!.firebaseUser?.email ?? '',
      'AuthToken': await authManager!.getAuthToken(),
    };
  }

  ///Adatintegritás header. Jelzi a szervernek, hogy a kliens oldali adat
  ///mikor volt utoljára frissítve (vagyis szinkronban a szerverrel).
  KeyValuePairs _lastUpdateHeader([DateTime? time]) {
    return time == null
        ? {'LastUpdate': DateTime(1998).toIso8601String()}
        : {'LastUpdate': time.toIso8601String()};
  }

  ///Adattípus header. `JSON` típusú kérés adatoknál kötelező megadni, hogy a
  ///szerver tudja értelmezni a kérést.
  KeyValuePairs _contentTypeHeader() {
    return {'Content-Type': 'application/json'};
  }
}

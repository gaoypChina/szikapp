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

class IOHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class IO {
  //Publikus változók

  //Privát változók
  final _vm_1 = 'https://130.61.246.41';
  final _vm_2 = 'https://130.61.59.166';

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

  static final IO _instance = IO._privateContructor();
  final http.Client client = http.Client();

  //Setterek és getterek

  //Publikus függvények aka Interface
  factory IO() {
    return _instance;
  }

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

  Future<bool> postUser(UserData data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putUser(UserData data, [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteUser(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_userEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> putUserPreferences(Preferences data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteUserPreferences([Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_preferencesEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders());

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postPlace(Place data, [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_placeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putPlace(Place data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_placeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postUserPermission(List<Permission> data,
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response =
        await client.post(Uri.parse(uri, 0, uri.length - 1), headers: {
      ...await _commonHeaders(),
      ..._lastUpdateHeader(lastUpdate)
    }, body: {
      'data': {'permissions': data.toString()}
    });

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> patchUserPermissions(Permission data,
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response =
        await client.patch(Uri.parse(uri, 0, uri.length - 1), headers: {
      ...await _commonHeaders(),
      ..._lastUpdateHeader(lastUpdate)
    }, body: {
      'data': {'permissions': data.toString()}
    });

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putUserPermissions(Permission data,
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response =
        await client.put(Uri.parse(uri, 0, uri.length - 1), headers: {
      ...await _commonHeaders(),
      ..._lastUpdateHeader(lastUpdate)
    }, body: {
      'data': {'permissions': data.toString()}
    });

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteUserPermission(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_permissionsEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postJanitor(JanitorTask data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> patchJanitor(
      TaskStatus data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(),
        body: {
          'data': {'status': data.toString()}
        });

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putJanitor(
      JanitorTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteJanitor(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_janitorEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postGroup(Group data, [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putGroup(Group data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteGroup(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_groupEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postCleaningExchange(CleaningExchange data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> patchCleaningExchange(
      Map<String, String> parameters, DateTime lastUpdate,
      [String? data]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)},
        body: {'data': data});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putCleaningExchange(
      Map<String, String> parameters, DateTime lastUpdate,
      [String? data]) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)},
        body: {'data': data});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteCleaningExchange(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postCleaning(CleaningPeriod data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> patchCleaning(
      CleaningPeriod data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putCleaning(
      CleaningTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_cleaningEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postPoll(PollTask data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> patchPoll(PollTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putPoll(Vote data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deletePoll(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_pollEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postReservation(TimetableTask data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putReservation(
      TimetableTask data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteReservation(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_reservationEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

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

  Future<bool> postBoardgame(Boardgame data,
      [Map<String, String>? parameters]) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters?.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> putBoardgame(
      Boardgame data, Map<String, String> parameters) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: await _commonHeaders(), body: {'data': data.toJson()});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  Future<bool> deleteBoardgame(
      Map<String, String> parameters, DateTime lastUpdate) async {
    var uri = '$_vm_1$_boardgameEndpoint?';
    parameters.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: {...await _commonHeaders(), ..._lastUpdateHeader(lastUpdate)});

    if (response.statusCode == 200) return true;
    throw _handleErrors(response);
  }

  //Privát függvények
  IO._privateContructor();

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

  Future<Map<String, String>> _commonHeaders() async {
    return {
      'User': SZIKAppState.authManager.firebaseUser?.email ?? '',
      'AuthToken': await SZIKAppState.authManager.getAuthToken(),
    };
  }

  Map<String, String> _lastUpdateHeader([DateTime? time]) {
    return time == null
        ? {'LastUpdate': DateTime(1998).toIso8601String()}
        : {'LastUpdate': time.toIso8601String()};
  }
}

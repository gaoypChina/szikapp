import 'dart:convert';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/cleaning_exchange.dart';
import '../models/cleaning_period.dart';
import '../models/group.dart';
import '../models/place.dart';
import '../models/preferences.dart';
import '../models/tasks.dart';
import '../models/user_data.dart';

class IO<T> {
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
  final _janitorEndpoint = '/janitor';

  static final IO _instance = IO._privateContructor();
  final http.Client client = http.Client();

  //Setterek és getterek

  //Publikus függvények aka Interface
  factory IO() {
    return _instance as IO<T>;
  }

  Future<UserData> getUser(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_userEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      return UserData.fromJson(json.decode(response.body));
    }
    throw handleErrors(response);
  }

  Future<bool> postUser(Map<String, String>? parameters, UserData data) async {
    var uri = '$_vm_1$_userEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putUser(Map<String, String>? parameters, UserData data) async {
    var uri = '$_vm_1$_userEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> deleteUser(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_userEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<Preferences> getUserPreferences(
      Map<String, String>? parameters) async {
    var uri = '$_vm_1$_preferencesEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      return Preferences.fromJson(json.decode(response.body));
    }
    throw handleErrors(response);
  }

  Future<bool> putUserPreferences(
      Map<String, String>? parameters, Preferences data) async {
    var uri = '$_vm_1$_preferencesEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> deleteUserPreferences(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_preferencesEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<Place>> getPlace(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_placeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <Place>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(Place.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> postPlace(Map<String, String>? parameters, Place data) async {
    var uri = '$_vm_1$_placeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putPlace(Map<String, String>? parameters, Place data) async {
    var uri = '$_vm_1$_placeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<String>> getUserPermissions(
      Map<String, String>? parameters) async {
    var uri = '$_vm_1$_permissionsEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <String>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(item);
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> patchUserPermissions(
      Map<String, String>? parameters, String data) async {
    var uri = '$_vm_1$_permissionsEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putUserPermissions(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_permissionsEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<JanitorTask>> getJanitor(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_janitorEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <JanitorTask>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(JanitorTask.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> postJanitor(
      Map<String, String>? parameters, JanitorTask data) async {
    var uri = '$_vm_1$_janitorEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> patchJanitor(
      Map<String, String>? parameters, TaskStatus data) async {
    var uri = '$_vm_1$_janitorEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putJanitor(
      Map<String, String>? parameters, JanitorTask data) async {
    var uri = '$_vm_1$_janitorEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> deleteJanitor(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_janitorEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<Group>> getGroup(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_groupEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <Group>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(Group.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> postGroup(Map<String, String>? parameters, Group data) async {
    var uri = '$_vm_1$_groupEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putGroup(Map<String, String>? parameters, Group data) async {
    var uri = '$_vm_1$_groupEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> deleteGroup(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_groupEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<UserData>> getContacts(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_contactsEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <UserData>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(UserData.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<List<CleaningExchange>> getCleaningExchange(
      Map<String, String>? parameters) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <CleaningExchange>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(CleaningExchange.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> postCleaningExchange(
      Map<String, String>? parameters, CleaningExchange data) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> patchCleaningExchange(
      Map<String, String>? parameters, String data) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putCleaningExchange(
      Map<String, String>? parameters, String data) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> deleteCleaningExchange(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_cleaningExchangeEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<CleaningTask>> getCleaning(
      Map<String, String>? parameters) async {
    var uri = '$_vm_1$_cleaningEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <CleaningTask>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(CleaningTask.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> postCleaning(
      Map<String, String>? parameters, CleaningPeriod data) async {
    var uri = '$_vm_1$_cleaningEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> patchCleaning(
      Map<String, String>? parameters, CleaningPeriod data) async {
    var uri = '$_vm_1$_cleaningEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putCleaning(
      Map<String, String>? parameters, CleaningTask data) async {
    var uri = '$_vm_1$_cleaningEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<List<PollTask>> getPoll(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_pollEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.get(Uri.parse(uri, 0, uri.length - 1),
        headers: {...commonHeaders(), ...cacheHeaders()});

    if (response.statusCode == 200) {
      var answer = <PollTask>[];
      List<dynamic> fullJson = json.decode(response.body);
      fullJson.forEach((item) {
        answer.add(PollTask.fromJson(item));
      });
      return answer;
    }
    throw handleErrors(response);
  }

  Future<bool> postPoll(Map<String, String>? parameters, PollTask data) async {
    var uri = '$_vm_1$_pollEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.post(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> patchPoll(Map<String, String>? parameters, PollTask data) async {
    var uri = '$_vm_1$_pollEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.patch(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> putPoll(
      Map<String, String>? parameters, Map<String, String> data) async {
    var uri = '$_vm_1$_pollEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.put(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders(), body: data);

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  Future<bool> deletePoll(Map<String, String>? parameters) async {
    var uri = '$_vm_1$_pollEndpoint';
    parameters!.forEach((key, value) => uri += '$key=$value&');
    var response = await client.delete(Uri.parse(uri, 0, uri.length - 1),
        headers: commonHeaders());

    if (response.statusCode == 200) return true;
    throw handleErrors(response);
  }

  //Privát függvények
  IO._privateContructor();
  Exception handleErrors(http.Response response) {
    if (response.statusCode >= 500)
      return IOServerException(
          '${response.statusCode.toString()}; ${response.body}');
    if (response.statusCode >= 400)
      return IOClientException(
          '${response.statusCode.toString()}; ${response.body}');
    return IOUnknownException(
        '${response.statusCode.toString()}; ${response.body}');
  }

  Map<String, String> commonHeaders() {
    return {
      'User': SZIKApp.user.email,
      'AuthToken': SZIKApp.authmanager.getAuthToken,
    };
  }

  Map<String, String> cacheHeaders() {
    return {
      'LastUpdate': DateTime(1998).toIso8601String(),
    };
  }
}

import 'package:json_annotation/json_annotation.dart';

import '../utils/types.dart';
import 'interfaces.dart';
import 'preferences.dart';
import 'user.dart';

part 'user_data.g.dart';

///Egy felhasználó adatait reprezentáló adatmodell osztály.
///Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class UserData implements Identifiable, Cachable {
  @override
  final String id;
  String name;
  String? nick;
  String email;
  String? phone;
  @JsonKey(name: 'secondary_phone')
  String? secondaryPhone;
  Preferences? preferences;
  DateTime? birthday;
  @JsonKey(name: 'group_ids')
  List<String> groupIDs;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  UserData({
    required this.id,
    required this.name,
    this.nick,
    required this.email,
    this.phone,
    this.secondaryPhone,
    this.preferences,
    this.birthday,
    this.groupIDs = const [],
    required this.lastUpdate,
  });

  String get showableName => nick ?? name.split(' ')[1];
  String get initials {
    var splitted = name.split(' ');
    return '${splitted[0][0]}${splitted[1][0]}';
  }

  void addGroup(String groupID) {
    if (!groupIDs.contains(groupID)) {
      groupIDs.add(groupID);
    }
  }

  void removeGroup(String groupID) {
    if (groupIDs.contains(groupID)) {
      groupIDs.remove(groupID);
    }
  }

  void removeAllGroups() {
    if (groupIDs.isNotEmpty) {
      groupIDs.clear();
    }
  }

  factory UserData.fromUser(User user) {
    return UserData(
      id: user.id,
      name: user.name,
      nick: user.nick,
      email: user.email,
      phone: user.phone,
      secondaryPhone: user.secondaryPhone,
      birthday: user.birthday,
      groupIDs: user.groupIDs,
      lastUpdate: user.lastUpdate,
    );
  }

  Json toJson() => _$UserDataToJson(this);

  factory UserData.fromJson(Json json) => _$UserDataFromJson(json);

  String userAsString() {
    return '#$id $name';
  }

  bool isEqual(UserData other) {
    return id == other.id;
  }

  @override
  String toString() => name;
}

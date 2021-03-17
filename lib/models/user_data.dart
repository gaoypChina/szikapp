import 'package:json_annotation/json_annotation.dart';
import 'preferences.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  String name;
  String nick;
  String email;
  String phone;
  String secondaryPhone;
  Preferences preferences;
  DateTime birthday;
  List<String> groupIDs;
  DateTime lastUpdate;

  UserData({
    this.id,
    this.name,
    this.nick,
    this.email,
    this.phone,
    this.secondaryPhone,
    this.preferences,
    this.birthday,
    this.groupIDs,
    this.lastUpdate,
  }) {
    groupIDs ??= <String>[];
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

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

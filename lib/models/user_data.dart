import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String userID;
  String name;
  String email;
  String mobile;
  DateTime birthday;
  List<String> groupIDs;

  UserData({
    this.userID,
    this.name,
    this.email,
    this.mobile,
    this.birthday,
    this.groupIDs,
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

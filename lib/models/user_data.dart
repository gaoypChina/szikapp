import 'package:json_annotation/json_annotation.dart';
import 'preferences.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
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
  List<String>? groupIDs;
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
    this.groupIDs,
    required this.lastUpdate,
  }) {
    groupIDs ??= <String>[];
  }

  void addGroup(String groupID) {
    if (!groupIDs!.contains(groupID)) {
      groupIDs!.add(groupID);
    }
  }

  void removeGroup(String groupID) {
    if (groupIDs!.contains(groupID)) {
      groupIDs!.remove(groupID);
    }
  }

  void removeAllGroups() {
    if (groupIDs!.isNotEmpty) {
      groupIDs!.clear();
    }
  }

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

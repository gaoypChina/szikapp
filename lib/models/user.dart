import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String userID;
  String name;
  String email;
  String mobile;
  List<String> groupIDs;
  List<String> taskIDs;

  User(
      {this.userID,
      this.name,
      this.email,
      this.mobile,
      this.groupIDs,
      this.taskIDs}) {
    groupIDs ??= <String>[];
    taskIDs ??= <String>[];
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

  void addTask(String taskID) {
    if (!taskIDs.contains(taskID)) {
      taskIDs.add(taskID);
    }
  }

  void removeTask(String taskID) {
    if (taskIDs.contains(taskID)) {
      taskIDs.remove(taskID);
    }
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

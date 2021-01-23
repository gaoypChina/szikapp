import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String userID;
  String name;
  String email;
  String mobile;
  List<String> groupIDs;

  User({this.userID, this.name, this.email, this.mobile, this.groupIDs}) {
    if (groupIDs == null) {
      this.groupIDs = <String>[];
    }
  }

  void addGroup(String groupID) {
    if (!this.groupIDs.contains(groupID)) {
      this.groupIDs.add(groupID);
    }
  }

  void removeGroup(String groupID) {
    if (this.groupIDs.contains(groupID)) {
      this.groupIDs.remove(groupID);
    }
  }

  void removeAllGroups() {
    if (this.groupIDs.length > 0) {
      this.groupIDs.clear();
    }
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

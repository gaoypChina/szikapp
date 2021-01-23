import 'package:json_annotation/json_annotation.dart';
import 'package:szikapp/models/permissions.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String groupID;
  final String name;
  String description;
  String emailList;
  final int maxMemberCount;
  List<String> memberIDs;
  List<GroupPermission> permissions;

  Group(
      {this.groupID,
      this.name,
      this.description,
      this.emailList,
      this.memberIDs,
      this.maxMemberCount,
      this.permissions}) {
    if (memberIDs == null) {
      this.memberIDs = <String>[];
    }
    if (permissions == null) {
      this.permissions = <GroupPermission>[];
    }
  }

  void addMember(String userID) {
    if (this.memberIDs.length < this.maxMemberCount &&
        !this.memberIDs.contains(userID)) {
      this.memberIDs.add(userID);
    }
  }

  void removeMember(String userID) {
    if (this.memberIDs.contains(userID)) {
      this.memberIDs.remove(userID);
    }
  }

  void removeAllMembers() {
    if (this.memberIDs.length > 0) {
      this.memberIDs.clear();
    }
  }

  void addPermission(GroupPermission permission) {
    if (!this.permissions.contains(permission)) {
      this.permissions.add(permission);
    }
  }

  void removePermission(GroupPermission permission) {
    if (this.permissions.contains(permission)) {
      this.permissions.remove(permission);
    }
  }

  void removeAllPermissions() {
    if (this.permissions.length > 0) {
      this.permissions.clear();
    }
  }

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

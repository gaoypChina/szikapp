import 'package:json_annotation/json_annotation.dart';
import 'permissions.dart';

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
    memberIDs ??= <String>[];
    permissions ??= <GroupPermission>[];
  }

  void addMember(String userID) {
    if (memberIDs.length < maxMemberCount && !memberIDs.contains(userID)) {
      memberIDs.add(userID);
    }
  }

  void removeMember(String userID) {
    if (memberIDs.contains(userID)) {
      memberIDs.remove(userID);
    }
  }

  void removeAllMembers() {
    if (memberIDs.isNotEmpty) {
      memberIDs.clear();
    }
  }

  void addPermission(GroupPermission permission) {
    if (!permissions.contains(permission)) {
      permissions.add(permission);
    }
  }

  void removePermission(GroupPermission permission) {
    if (permissions.contains(permission)) {
      permissions.remove(permission);
    }
  }

  void removeAllPermissions() {
    if (permissions.isNotEmpty) {
      permissions.clear();
    }
  }

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

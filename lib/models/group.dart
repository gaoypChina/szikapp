import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String groupID;
  final String name;
  String description;
  String emailList;
  final int maxMemberCount;
  List<String> memberIDs;

  Group({
    this.groupID,
    this.name,
    this.description,
    this.emailList,
    this.memberIDs,
    this.maxMemberCount,
  }) {
    memberIDs ??= <String>[];
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

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

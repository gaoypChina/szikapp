import 'package:json_annotation/json_annotation.dart';
import 'permission.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String id;
  String name;
  String? description;
  String? email;
  @JsonKey(name: 'member_ids')
  List<String>? memberIDs;
  @JsonKey(name: 'max_member_count')
  int maxMemberCount;
  List<Permission>? permissions;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Group({
    required this.id,
    required this.name,
    this.description,
    this.email,
    this.memberIDs,
    this.maxMemberCount = 999,
    this.permissions,
    required this.lastUpdate,
  }) {
    memberIDs ??= <String>[];
    permissions ??= <Permission>[];
  }

  void addMember(String userID) {
    if (!memberIDs!.contains(userID)) {
      memberIDs!.add(userID);
    }
  }

  void removeMember(String userID) {
    if (memberIDs!.contains(userID)) {
      memberIDs!.remove(userID);
    }
  }

  void removeAllMembers() {
    if (memberIDs!.isNotEmpty) {
      memberIDs!.clear();
    }
  }

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  String groupAsString() {
    return '#$id $name';
  }

  bool isEqual(Group? other) {
    if (other == null) return false;
    return id == other.id;
  }

  @override
  String toString() => name;
}

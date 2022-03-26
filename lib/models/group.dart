import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';
import 'interfaces.dart';
import 'permission.dart';

part 'group.g.dart';

///Felhasználói csoportot megvalósító adatmodell osztály. Tárolja a csoport
///jogosultságait. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable()
class Group implements Identifiable, Cachable {
  @override
  final String id;
  String name;
  String? description;
  String? email;
  @JsonKey(name: 'member_ids')
  List<String> memberIDs;
  @JsonKey(name: 'max_member_count')
  int maxMemberCount;
  List<Permission> permissions;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Group({
    required this.id,
    required this.name,
    this.description,
    this.email,
    this.memberIDs = const [],
    this.maxMemberCount = 999,
    this.permissions = const [],
    required this.lastUpdate,
  });

  String get initials => name.substring(0, 2);

  void addMember(String userID) {
    if (!memberIDs.contains(userID) && memberIDs.length < maxMemberCount) {
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

  Json toJson() => _$GroupToJson(this);

  factory Group.fromJson(Json json) => _$GroupFromJson(json);

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

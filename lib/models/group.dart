import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String groupID;
  final String name;
  final String description;
  final String emailList;
  List<String> memberIDs;

  Group(
      {this.groupID,
      this.name,
      this.description,
      this.emailList,
      this.memberIDs}) {
    if (memberIDs == null) {
      this.memberIDs = <String>[];
    }
  }

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

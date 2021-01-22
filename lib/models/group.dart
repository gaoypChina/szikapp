import 'package:szikapp/models/user.dart';

class Group {
  final String groupID;
  final String name;
  final String description;
  final String emailList;
  List<User> members;

  Group(
      {this.groupID,
      this.name,
      this.description,
      this.emailList,
      this.members}) {
    if (members == null) {
      this.members = <User>[];
    }
  }
}

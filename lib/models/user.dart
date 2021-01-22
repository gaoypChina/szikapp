class User {
  final String userID;
  final String name;
  final String email;

  User({this.userID, this.name, this.email});

  Map<String, Object> toJSON() {
    return {"userID": this.userID, "name": this.name, "email": this.email};
  }

  factory User.fromJSON(Map<String, Object> doc) {
    return User(userID: doc['userID'], name: doc['name'], email: doc['email']);
  }
}

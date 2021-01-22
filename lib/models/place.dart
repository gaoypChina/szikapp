class Place {
  final String name;
  final String number;
  final String description;

  Place({this.name, this.number, this.description});

  Map<String, Object> toJSON() {
    return {
      "name": this.name,
      "number": this.number,
      "description": this.description
    };
  }

  factory Place.fromJSON(Map<String, Object> doc) {
    return Place(
        name: doc['name'],
        number: doc['number'],
        description: doc['description']);
  }
}

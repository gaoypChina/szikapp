import 'package:szikapp/models/place.dart';
import 'package:szikapp/models/user.dart';

enum TaskType { agenda, janitor, reservation, timetable, cleaning, bookloan }
enum TaskStatus { noticed, inprogress, completed }

class Task {
  final String taskID;
  String name;
  DateTime start;
  DateTime end;
  final TaskType type;
  List<User> involved;

  Task(this.taskID, this.name, this.start, this.end, this.type, this.involved) {
    if (involved == null) {
      this.involved = <User>[];
    }
  }
}

class AgendaTask extends Task {
  String description;
  User organizer;

  AgendaTask(
      {taskID,
      name,
      start,
      end,
      type,
      involved,
      this.description,
      this.organizer})
      : super(taskID, name, start, end, type, involved) {
    if (organizer == null) {
      this.organizer = User();
    }
  }

  Map<String, Object> toJSON() {
    var involvedObj = [];
    for (var item in this.involved) {
      involvedObj.add(item.toJSON());
    }
    return {
      "id": this.taskID,
      "name": this.name,
      "start": this.start.toString(),
      "end": this.end.toString(),
      "type": this.type, //TODO string from enum
      "involved": involvedObj,
      "description": this.description,
      "organizer": this.organizer.toJSON()
    };
  }

  factory AgendaTask.fromJSON(Map<String, Object> doc) {
    var involvedObj = <User>[];
    for (var item in doc['involved']) {
      try {
        involvedObj.add(User.fromJSON(item));
      } catch (ex) {}
    }
    var task = AgendaTask(
        taskID: doc['id'],
        name: doc['name'],
        start: DateTime.parse(doc['start']),
        end: DateTime.parse(doc['start']),
        type: doc["type"], //TODO enum from string
        involved: involvedObj,
        description: doc['description'],
        organizer: User.fromJSON(doc['organizer']));
    return task;
  }
}

class TimetableTask extends Task {
  String description;
  User organizer;
  Place room;

  TimetableTask(
      {taskID,
      name,
      start,
      end,
      type,
      involved,
      this.description,
      this.organizer,
      this.room})
      : super(taskID, name, start, end, type, involved) {
    if (organizer == null) {
      this.organizer = User();
    }
  }

  Map<String, Object> toJSON() {
    var involvedObj = [];
    for (var item in this.involved) {
      involvedObj.add(item.toJSON());
    }
    return {
      "id": this.taskID,
      "name": this.name,
      "start": this.start.toString(),
      "end": this.end.toString(),
      "type": this.type, //TODO string from enum
      "involved": involvedObj,
      "description": this.description,
      "organizer": this.organizer.toJSON(),
      "room": this.room.toJSON()
    };
  }

  factory TimetableTask.fromJSON(Map<String, Object> doc) {
    var involvedObj = <User>[];
    for (var item in doc['involved']) {
      try {
        involvedObj.add(User.fromJSON(item));
      } catch (ex) {}
    }
    var task = TimetableTask(
        taskID: doc['id'],
        name: doc['name'],
        start: DateTime.parse(doc['start']),
        end: DateTime.parse(doc['start']),
        type: doc["type"], //TODO enum from string
        involved: involvedObj,
        description: doc['description'],
        organizer: User.fromJSON(doc['organizer']),
        room: Place.fromJSON(doc['room']));
    return task;
  }
}

class JanitorTask extends Task {
  String description;
  Place room;
  TaskStatus status;

  JanitorTask(
      {taskID,
      name,
      start,
      end,
      type,
      involved,
      this.description,
      this.room,
      this.status})
      : super(taskID, name, start, end, type, involved);

  Map<String, Object> toJSON() {
    var involvedObj = [];
    for (var item in this.involved) {
      involvedObj.add(item.toJSON());
    }
    return {
      "id": this.taskID,
      "name": this.name,
      "start": this.start.toString(),
      "end": this.end.toString(),
      "type": this.type, //TODO string from enum
      "involved": involvedObj,
      "description": this.description,
      "room": this.room.toJSON(),
      "status": this.status //TODO string from enum
    };
  }

  factory JanitorTask.fromJSON(Map<String, Object> doc) {
    var involvedObj = <User>[];
    for (var item in doc['involved']) {
      try {
        involvedObj.add(User.fromJSON(item));
      } catch (ex) {}
    }
    var task = JanitorTask(
        taskID: doc['id'],
        name: doc['name'],
        start: DateTime.parse(doc['start']),
        end: DateTime.parse(doc['start']),
        type: doc["type"], //TODO enum from string
        involved: involvedObj,
        description: doc['description'],
        room: Place.fromJSON(doc['room']),
        status: doc['status'] //TODO enum from string
        );
    return task;
  }
}

class CleaningTask extends Task {
  String description;

  CleaningTask({taskID, name, start, end, type, involved, this.description})
      : super(taskID, name, start, end, type, involved);

  Map<String, Object> toJSON() {
    var involvedObj = [];
    for (var item in this.involved) {
      involvedObj.add(item.toJSON());
    }
    return {
      "id": this.taskID,
      "name": this.name,
      "start": this.start.toString(),
      "end": this.end.toString(),
      "type": this.type, //TODO string from enum
      "involved": involvedObj,
      "description": this.description
    };
  }

  factory CleaningTask.fromJSON(Map<String, Object> doc) {
    var involvedObj = <User>[];
    for (var item in doc['involved']) {
      try {
        involvedObj.add(User.fromJSON(item));
      } catch (ex) {}
    }
    var task = CleaningTask(
        taskID: doc['id'],
        name: doc['name'],
        start: DateTime.parse(doc['start']),
        end: DateTime.parse(doc['start']),
        type: doc["type"], //TODO enum from string
        involved: involvedObj,
        description: doc['description']);
    return task;
  }
}

class BookloanTask extends Task {
  String bookID;

  BookloanTask({taskID, name, start, end, type, involved, this.bookID})
      : super(taskID, name, start, end, type, involved);

  Map<String, Object> toJSON() {
    var involvedObj = [];
    for (var item in this.involved) {
      involvedObj.add(item.toJSON());
    }
    return {
      "id": this.taskID,
      "name": this.name,
      "start": this.start.toString(),
      "end": this.end.toString(),
      "type": this.type, //TODO string from enum
      "involved": involvedObj,
      "bookID": this.bookID
    };
  }

  factory BookloanTask.fromJSON(Map<String, Object> doc) {
    var involvedObj = <User>[];
    for (var item in doc['involved']) {
      try {
        involvedObj.add(User.fromJSON(item));
      } catch (ex) {}
    }
    var task = BookloanTask(
        taskID: doc['id'],
        name: doc['name'],
        start: DateTime.parse(doc['start']),
        end: DateTime.parse(doc['start']),
        type: doc["type"], //TODO enum from string
        involved: involvedObj,
        bookID: doc['bookID']);
    return task;
  }
}

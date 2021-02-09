import 'package:json_annotation/json_annotation.dart';

part 'tasks.g.dart';

///[TaskType] enum represents types of [Task]s
enum TaskType {
  @JsonValue('agenda')
  agenda,
  @JsonValue('janitor')
  janitor,
  @JsonValue('reservation')
  reservation,
  @JsonValue('timetable')
  timetable,
  @JsonValue('cleaning')
  cleaning,
  @JsonValue('bookloan')
  bookloan
}

///[TaskStatus] enum represents current statuses of [Task]s
enum TaskStatus {
  @JsonValue('noticed')
  noticed,
  @JsonValue('inprogress')
  inProgress,
  @JsonValue('completed')
  completed
}

///Basic [Task] class. Ancestor of descended Task types.
class Task {
  final String taskID;
  String name;
  DateTime start;
  DateTime end;
  final TaskType type;
  List<String> involvedIDs;

  Task(this.taskID, this.name, this.start, this.end, this.type,
      this.involvedIDs) {
    involvedIDs ??= <String>[];
  }
}

///Descendant of the basic [Task] class. Represents an event in the SZIK Agenda.
@JsonSerializable(explicitToJson: true)
class AgendaTask extends Task {
  String description;
  String organizerID;

  AgendaTask(
      {taskID,
      name,
      start,
      end,
      type,
      involved,
      this.description,
      this.organizerID})
      : super(taskID, name, start, end, type, involved);

  Map<String, dynamic> toJson() => _$AgendaTaskToJson(this);

  factory AgendaTask.fromJson(Map<String, dynamic> json) =>
      _$AgendaTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents an event in the SZIK
/// Timetable.
@JsonSerializable(explicitToJson: true)
class TimetableTask extends Task {
  String description;
  String organizerID;
  String roomID;

  TimetableTask(
      {taskID,
      name,
      start,
      end,
      type,
      involved,
      this.description,
      this.organizerID,
      this.roomID})
      : super(taskID, name, start, end, type, involved);

  Map<String, dynamic> toJson() => _$TimetableTaskToJson(this);

  factory TimetableTask.fromJson(Map<String, dynamic> json) =>
      _$TimetableTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a repair request.
@JsonSerializable(explicitToJson: true)
class JanitorTask extends Task {
  String description;
  String roomID;
  TaskStatus status;

  JanitorTask(
      {taskID,
      name,
      start,
      end,
      type,
      involved,
      this.description,
      this.roomID,
      this.status})
      : super(taskID, name, start, end, type, involved);

  Map<String, dynamic> toJson() => _$JanitorTaskToJson(this);

  factory JanitorTask.fromJson(Map<String, dynamic> json) =>
      _$JanitorTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a kitchen cleaning task.
@JsonSerializable(explicitToJson: true)
class CleaningTask extends Task {
  String description;

  CleaningTask({taskID, name, start, end, type, involved, this.description})
      : super(taskID, name, start, end, type, involved);

  Map<String, dynamic> toJson() => _$CleaningTaskToJson(this);

  factory CleaningTask.fromJson(Map<String, dynamic> json) =>
      _$CleaningTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a book loan from the
///library.
@JsonSerializable(explicitToJson: true)
class BookloanTask extends Task {
  String bookID;

  BookloanTask({taskID, name, start, end, type, involved, this.bookID})
      : super(taskID, name, start, end, type, involved);

  Map<String, dynamic> toJson() => _$BookloanTaskToJson(this);

  factory BookloanTask.fromJson(Map<String, dynamic> json) =>
      _$BookloanTaskFromJson(json);
}

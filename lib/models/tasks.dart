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
  @JsonValue('sent')
  sent,
  @JsonValue('irresolvable')
  irresolvable,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('awaiting_approval')
  awaitingApproval,
  @JsonValue('refused')
  refused,
  @JsonValue('approved')
  approved
}

///Basic [Task] class. Ancestor of descended Task types.
class Task {
  final String uid;
  String name;
  DateTime start;
  DateTime end;
  TaskType type;
  @JsonValue('involved_ids')
  List<String>? involvedIDs;
  String? description;
  @JsonValue('last_update')
  DateTime lastUpdate;

  Task({
    required this.uid,
    required this.name,
    required this.start,
    required this.end,
    required this.type,
    this.involvedIDs,
    this.description,
    required this.lastUpdate,
  }) {
    involvedIDs ??= <String>[];
  }
}

///Descendant of the basic [Task] class. Represents an event in the SZIK Agenda.
@JsonSerializable(explicitToJson: true)
class AgendaTask extends Task {
  @JsonValue('organizer_ids')
  List<String> organizerIDs;

  AgendaTask(
      {required uid,
      required name,
      required start,
      required end,
      required type,
      involved,
      description,
      update,
      required this.organizerIDs})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: update,
        );

  Map<String, dynamic> toJson() => _$AgendaTaskToJson(this);

  factory AgendaTask.fromJson(Map<String, dynamic> json) =>
      _$AgendaTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents an event in the SZIK
/// Timetable.
@JsonSerializable(explicitToJson: true)
class TimetableTask extends Task {
  @JsonValue('organizer_ids')
  List<String> organizerIDs;
  @JsonValue('resource_ids')
  List<String> resourceIDs;

  TimetableTask(
      {required uid,
      required name,
      required start,
      required end,
      required type,
      involved,
      description,
      update,
      required this.organizerIDs,
      required this.resourceIDs})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: update,
        );

  Map<String, dynamic> toJson() => _$TimetableTaskToJson(this);

  factory TimetableTask.fromJson(Map<String, dynamic> json) =>
      _$TimetableTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a repair request.
@JsonSerializable(explicitToJson: true)
class JanitorTask extends Task {
  List<Map<String, dynamic>>? feedback;
  @JsonValue('place_id')
  String placeID;
  TaskStatus status;

  JanitorTask(
      {required uid,
      required name,
      required start,
      required end,
      required type,
      involved,
      description,
      update,
      this.feedback,
      required this.placeID,
      required this.status})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: update,
        ) {
    feedback ??= <Map<String, dynamic>>[];
  }

  Map<String, dynamic> toJson() => _$JanitorTaskToJson(this);

  factory JanitorTask.fromJson(Map<String, dynamic> json) =>
      _$JanitorTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a kitchen cleaning task.
@JsonSerializable(explicitToJson: true)
class CleaningTask extends Task {
  List<Map<String, dynamic>>? feedback;
  TaskStatus status;

  CleaningTask(
      {required uid,
      required name,
      required start,
      required end,
      required type,
      involved,
      description,
      update,
      this.feedback,
      required this.status})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: update,
        ) {
    feedback ??= <Map<String, dynamic>>[];
  }

  Map<String, dynamic> toJson() => _$CleaningTaskToJson(this);

  factory CleaningTask.fromJson(Map<String, dynamic> json) =>
      _$CleaningTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a book loan from the
///library.
@JsonSerializable(explicitToJson: true)
class BookloanTask extends Task {
  @JsonValue('book_id')
  String bookID;

  BookloanTask(
      {required uid,
      required name,
      required start,
      required end,
      required type,
      involved,
      description,
      update,
      required this.bookID})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: update,
        );

  Map<String, dynamic> toJson() => _$BookloanTaskToJson(this);

  factory BookloanTask.fromJson(Map<String, dynamic> json) =>
      _$BookloanTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a poll.
@JsonSerializable()
class PollTask extends Task {
  String question;
  @JsonValue('answer_options')
  List<String> answerOptions;
  List<Map<String, String>>? answers;
  @JsonValue('issuer_ids')
  List<String> issuerIDs;
  @JsonValue('is_live')
  bool? isLive;
  @JsonValue('is_confidential')
  bool? isConfidential;
  @JsonValue('is_multiple_choice')
  bool? isMultipleChoice;

  PollTask({
    required uid,
    required name,
    required start,
    required end,
    required type,
    involved,
    description,
    update,
    required this.question,
    required this.answerOptions,
    this.answers,
    required this.issuerIDs,
    this.isLive = false,
    this.isConfidential = false,
    this.isMultipleChoice = false,
  }) : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: update,
        ) {
    answers ??= <Map<String, String>>[];
  }

  Map<String, dynamic> toJson() => _$PollTaskToJson(this);

  factory PollTask.fromJson(Map<String, dynamic> json) =>
      _$PollTaskFromJson(json);
}

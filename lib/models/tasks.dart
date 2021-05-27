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
  bookloan,
  @JsonValue('poll')
  poll
}

extension TaskTypeExtensions on TaskType {
  String toShortString() {
    return toString().split('.').last;
  }

  bool isEqual(TaskType? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///[TaskStatus] enum represents current statuses of [Task]s
enum TaskStatus {
  @JsonValue('created')
  created,
  @JsonValue('sent')
  sent,
  @JsonValue('irresolvable')
  irresolvable,
  @JsonValue('in_progress')
  in_progress,
  @JsonValue('awaiting_approval')
  awaiting_approval,
  @JsonValue('refused')
  refused,
  @JsonValue('approved')
  approved
}

extension TaskStatusExtensions on TaskStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  bool isEqual(TaskStatus? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///Basic [Task] class. Ancestor of descended Task types.
@JsonSerializable(explicitToJson: true)
class Task {
  final String uid;
  String name;
  DateTime start;
  DateTime end;
  TaskType type;
  @JsonKey(name: 'involved_ids')
  List<String>? involvedIDs;
  String? description;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

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

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents an event in the SZIK Agenda.
@JsonSerializable(explicitToJson: true)
class AgendaTask extends Task {
  @JsonKey(name: 'organizer_ids')
  List<String> organizerIDs;

  AgendaTask(
      {required String uid,
      required String name,
      required DateTime start,
      required DateTime end,
      required TaskType type,
      List<String>? involved,
      String? description,
      required DateTime lastUpdate,
      required this.organizerIDs})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Map<String, dynamic> toJson() => _$AgendaTaskToJson(this);

  factory AgendaTask.fromJson(Map<String, dynamic> json) =>
      _$AgendaTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents an event in the SZIK
/// Timetable.
@JsonSerializable(explicitToJson: true)
class TimetableTask extends Task {
  @JsonKey(name: 'organizer_ids')
  List<String> organizerIDs;
  @JsonKey(name: 'resource_ids')
  List<String> resourceIDs;

  TimetableTask(
      {required String uid,
      required String name,
      required DateTime start,
      required DateTime end,
      required TaskType type,
      List<String>? involved,
      String? description,
      required DateTime lastUpdate,
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
          lastUpdate: lastUpdate,
        );

  @override
  Map<String, dynamic> toJson() => _$TimetableTaskToJson(this);

  factory TimetableTask.fromJson(Map<String, dynamic> json) =>
      _$TimetableTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a repair request.
@JsonSerializable(explicitToJson: true)
class JanitorTask extends Task {
  List<Map<String, dynamic>>? feedback;
  @JsonKey(name: 'place_id')
  String placeID;
  TaskStatus status;
  String? answer;

  JanitorTask({
    required String uid,
    required String name,
    required DateTime start,
    required DateTime end,
    required TaskType type,
    List<String>? involved,
    String? description,
    required DateTime lastUpdate,
    this.feedback,
    required this.placeID,
    required this.status,
    this.answer,
  }) : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: lastUpdate,
        ) {
    feedback ??= <Map<String, dynamic>>[];
  }

  @override
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
      {required String uid,
      required String name,
      required DateTime start,
      required DateTime end,
      required TaskType type,
      List<String>? involved,
      String? description,
      required DateTime lastUpdate,
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
          lastUpdate: lastUpdate,
        ) {
    feedback ??= <Map<String, dynamic>>[];
  }

  @override
  Map<String, dynamic> toJson() => _$CleaningTaskToJson(this);

  factory CleaningTask.fromJson(Map<String, dynamic> json) =>
      _$CleaningTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a book loan from the
///library.
@JsonSerializable(explicitToJson: true)
class BookloanTask extends Task {
  @JsonKey(name: 'book_id')
  String bookID;

  BookloanTask(
      {required String uid,
      required String name,
      required DateTime start,
      required DateTime end,
      required TaskType type,
      List<String>? involved,
      String? description,
      required DateTime lastUpdate,
      required this.bookID})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Map<String, dynamic> toJson() => _$BookloanTaskToJson(this);

  factory BookloanTask.fromJson(Map<String, dynamic> json) =>
      _$BookloanTaskFromJson(json);
}

///Descendant of the basic [Task] class. Represents a poll.
@JsonSerializable(explicitToJson: true)
class PollTask extends Task {
  String question;
  @JsonKey(name: 'answer_options')
  List<String> answerOptions;
  List<Vote> answers;
  @JsonKey(name: 'issuer_ids')
  List<String> issuerIDs;
  @JsonKey(name: 'is_live')
  bool isLive;
  @JsonKey(name: 'is_confidential')
  bool isConfidential;
  @JsonKey(name: 'is_multiple_choice')
  bool isMultipleChoice;
  @JsonKey(name: 'max_selectable_options')
  int maxSelectableOptions;

  PollTask(
      {required String uid,
      required String name,
      required DateTime start,
      required DateTime end,
      required TaskType type,
      List<String>? involved,
      String? description,
      required DateTime lastUpdate,
      required this.question,
      required this.answerOptions,
      required this.answers,
      required this.issuerIDs,
      this.isLive = false,
      this.isConfidential = false,
      this.isMultipleChoice = false,
      this.maxSelectableOptions = 999})
      : super(
          uid: uid,
          name: name,
          start: start,
          end: end,
          type: type,
          involvedIDs: involved,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Map<String, dynamic> toJson() => _$PollTaskToJson(this);

  factory PollTask.fromJson(Map<String, dynamic> json) =>
      _$PollTaskFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class Vote {
  @JsonKey(name: 'voter_id')
  String voterID;
  List<String> votes;

  Vote({required this.voterID, required this.votes});

  Map<String, dynamic> toJson() => _$VoteToJson(this);

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
}

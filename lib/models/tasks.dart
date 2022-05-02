import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';
import 'interfaces.dart';

part 'tasks.g.dart';

///Feladattípusokat [Task] reprezentáló típus.
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

///Feladatok [Task] státuszát reprezentáló típus.
enum TaskStatus {
  @JsonValue('created')
  created,
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

extension TaskStatusExtensions on TaskStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  bool isEqual(TaskStatus? other) {
    if (other == null) return false;
    return index == other.index;
  }
}

///Alapvető feladat adatmodell ősosztály. Szerializálható `JSON` formátumba és
///vice versa.
@JsonSerializable(explicitToJson: true)
class Task implements Identifiable, Cachable {
  @override
  @JsonKey(name: 'uid')
  String id;
  String name;
  DateTime start;
  DateTime end;
  TaskType type;
  @JsonKey(name: 'manager_ids')
  List<String> managerIDs;
  @JsonKey(name: 'participant_ids')
  List<String> participantIDs;

  String? description;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Task({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.type,
    this.managerIDs = const [],
    this.participantIDs = const [],
    this.description,
    required this.lastUpdate,
  });

  Json toJson() => _$TaskToJson(this);

  factory Task.fromJson(Json json) => _$TaskFromJson(json);
}

///Órarendi vagy foglalási eseményt megtestesítő adatmodell osztály. A [Task]
///osztály leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class TimetableTask extends Task {
  @JsonKey(name: 'resource_ids')
  List<String> resourceIDs;

  TimetableTask({
    required String id,
    required String name,
    required DateTime start,
    required DateTime end,
    required TaskType type,
    List<String> managerIDs = const <String>[],
    List<String> participantIDs = const <String>[],
    String? description,
    required DateTime lastUpdate,
    required this.resourceIDs,
  }) : super(
          id: id,
          name: name,
          start: start,
          end: end,
          type: type,
          managerIDs: managerIDs,
          participantIDs: participantIDs,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$TimetableTaskToJson(this);

  factory TimetableTask.fromJson(Json json) => _$TimetableTaskFromJson(json);
}

///Gondnoki javítási kérést megtestesítő adatmodell osztály. A [Task] osztály
///leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class JanitorTask extends Task {
  List<Feedback> feedback;
  @JsonKey(name: 'place_id')
  String placeID;
  TaskStatus status;
  String? answer;

  JanitorTask({
    required String id,
    required String name,
    required DateTime start,
    required DateTime end,
    required TaskType type,
    List<String> managerIDs = const [],
    List<String> participantIDs = const [],
    String? description,
    required DateTime lastUpdate,
    this.feedback = const [],
    required this.placeID,
    required this.status,
    this.answer,
  }) : super(
          id: id,
          name: name,
          start: start,
          end: end,
          type: type,
          managerIDs: managerIDs,
          participantIDs: participantIDs,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$JanitorTaskToJson(this);

  factory JanitorTask.fromJson(Json json) => _$JanitorTaskFromJson(json);
}

///Felhasználói visszajelzést megvalósító adatmodell osztály.
///Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable()
class Feedback implements Identifiable, Cachable {
  @override
  String id;

  @JsonKey(name: 'user_id')
  String userID;
  String message;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Feedback({
    required this.id,
    required this.userID,
    required this.message,
    required this.lastUpdate,
  });

  Json toJson() => _$FeedbackToJson(this);

  factory Feedback.fromJson(Json json) => _$FeedbackFromJson(json);
}

///Konyhatakarítási feladatot megtestesítő adatmodell osztály. A [Task] osztály
///leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class CleaningTask extends Task {
  List<Feedback> feedback;
  TaskStatus status;

  CleaningTask({
    required String id,
    required String name,
    required DateTime start,
    required DateTime end,
    required TaskType type,
    List<String> managerIDs = const [],
    List<String> participantIDs = const [],
    String? description,
    required DateTime lastUpdate,
    this.feedback = const [],
    required this.status,
  }) : super(
          id: id,
          name: name,
          start: start,
          end: end,
          type: type,
          managerIDs: managerIDs,
          participantIDs: participantIDs,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$CleaningTaskToJson(this);

  factory CleaningTask.fromJson(Json json) => _$CleaningTaskFromJson(json);
}

///Könyvtári kölcsönzést megtestesítő adatmodell osztály. A [Task] osztály
///leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class BookloanTask extends Task {
  @JsonKey(name: 'book_id')
  String bookID;

  BookloanTask({
    required String id,
    required String name,
    required DateTime start,
    required DateTime end,
    required TaskType type,
    List<String> managerIDs = const [],
    List<String> participantIDs = const [],
    String? description,
    required DateTime lastUpdate,
    required this.bookID,
  }) : super(
          id: id,
          name: name,
          start: start,
          end: end,
          type: type,
          managerIDs: managerIDs,
          participantIDs: participantIDs,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$BookloanTaskToJson(this);

  factory BookloanTask.fromJson(Json json) => _$BookloanTaskFromJson(json);
}

///Szavazást megtestesítő adatmodell osztály. A [Task] osztály
///leszármazottja. Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class PollTask extends Task {
  String question;
  @JsonKey(name: 'answer_options')
  List<String> answerOptions;
  List<Vote> answers;
  @JsonKey(name: 'feedback_on_answer')
  String? feedbackOnAnswer;
  @JsonKey(name: 'is_live')
  bool isLive;
  @JsonKey(name: 'is_confidential')
  bool isConfidential;
  @JsonKey(name: 'is_multiple_choice')
  bool isMultipleChoice;
  @JsonKey(name: 'max_selectable_options')
  int maxSelectableOptions;

  PollTask({
    required String id,
    required String name,
    required DateTime start,
    required DateTime end,
    required TaskType type,
    List<String> managerIDs = const [],
    List<String> participantIDs = const [],
    String? description,
    required DateTime lastUpdate,
    required this.question,
    required this.answerOptions,
    required this.answers,
    this.feedbackOnAnswer,
    this.isLive = false,
    this.isConfidential = false,
    this.isMultipleChoice = false,
    this.maxSelectableOptions = 999,
  }) : super(
          id: id,
          name: name,
          start: start,
          end: end,
          type: type,
          managerIDs: managerIDs,
          participantIDs: participantIDs,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$PollTaskToJson(this);

  factory PollTask.fromJson(Json json) => _$PollTaskFromJson(json);
}

///Egy felhasználó szavazatát megtestesítő adatmodell osztály.
///Szerializálható `JSON` formátumba és vice versa.
@JsonSerializable(explicitToJson: true)
class Vote implements Cachable {
  @JsonKey(name: 'voter_id')
  String voterID;
  List<String> votes;
  @override
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  Vote({
    required this.voterID,
    required this.votes,
    required this.lastUpdate,
  });

  Json toJson() => _$VoteToJson(this);

  factory Vote.fromJson(Json json) => _$VoteFromJson(json);
}

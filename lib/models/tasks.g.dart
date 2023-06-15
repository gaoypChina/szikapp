// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['uid'] as String,
      name: json['name'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      managerIDs: (json['manager_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      participantIDs: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type]!,
      'manager_ids': instance.managerIDs,
      'participant_ids': instance.participantIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

const _$TaskTypeEnumMap = {
  TaskType.janitor: 'janitor',
  TaskType.reservation: 'reservation',
  TaskType.timetable: 'timetable',
  TaskType.cleaning: 'cleaning',
  TaskType.bookrent: 'bookrent',
  TaskType.poll: 'poll',
  TaskType.invitation: 'invitation',
};

TimetableTask _$TimetableTaskFromJson(Map<String, dynamic> json) =>
    TimetableTask(
      id: json['uid'] as String,
      name: json['name'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      managerIDs: (json['manager_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      participantIDs: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
      resourceIDs: (json['resource_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      url: json['url'] as String?,
      color: json['color'] as int,
    );

Map<String, dynamic> _$TimetableTaskToJson(TimetableTask instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type]!,
      'manager_ids': instance.managerIDs,
      'participant_ids': instance.participantIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'resource_ids': instance.resourceIDs,
      'url': instance.url,
      'color': instance.color,
    };

JanitorTask _$JanitorTaskFromJson(Map<String, dynamic> json) => JanitorTask(
      id: json['uid'] as String,
      name: json['name'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      managerIDs: (json['manager_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      participantIDs: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
      feedback: (json['feedback'] as List<dynamic>?)
              ?.map((e) => Feedback.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      placeID: json['place_id'] as String,
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$JanitorTaskToJson(JanitorTask instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type]!,
      'manager_ids': instance.managerIDs,
      'participant_ids': instance.participantIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'feedback': instance.feedback.map((e) => e.toJson()).toList(),
      'place_id': instance.placeID,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'answer': instance.answer,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.created: 'created',
  TaskStatus.sent: 'sent',
  TaskStatus.irresolvable: 'irresolvable',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.awaitingApproval: 'awaiting_approval',
  TaskStatus.refused: 'refused',
  TaskStatus.approved: 'approved',
};

Feedback _$FeedbackFromJson(Map<String, dynamic> json) => Feedback(
      id: json['id'] as String,
      userID: json['user_id'] as String,
      message: json['message'] as String,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$FeedbackToJson(Feedback instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userID,
      'message': instance.message,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

CleaningTask _$CleaningTaskFromJson(Map<String, dynamic> json) => CleaningTask(
      id: json['uid'] as String,
      name: json['name'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      managerIDs: (json['manager_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      participantIDs: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
      feedback: (json['feedback'] as List<dynamic>?)
              ?.map((e) => Feedback.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CleaningTaskToJson(CleaningTask instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type]!,
      'manager_ids': instance.managerIDs,
      'participant_ids': instance.participantIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'feedback': instance.feedback.map((e) => e.toJson()).toList(),
      'status': _$TaskStatusEnumMap[instance.status]!,
    };

BookrentTask _$BookrentTaskFromJson(Map<String, dynamic> json) => BookrentTask(
      id: json['uid'] as String,
      name: json['name'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      managerIDs: (json['manager_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      participantIDs: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
      bookID: json['book_id'] as String,
    );

Map<String, dynamic> _$BookrentTaskToJson(BookrentTask instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type]!,
      'manager_ids': instance.managerIDs,
      'participant_ids': instance.participantIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'book_id': instance.bookID,
    };

PollTask _$PollTaskFromJson(Map<String, dynamic> json) => PollTask(
      id: json['uid'] as String,
      name: json['name'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      managerIDs: (json['manager_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      participantIDs: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
      question: json['question'] as String,
      answerOptions: (json['answer_options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Vote.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedbackOnAnswer: json['feedback_on_answer'] as String?,
      isLive: json['is_live'] as bool? ?? false,
      isConfidential: json['is_confidential'] as bool? ?? false,
      isMultipleChoice: json['is_multiple_choice'] as bool? ?? false,
      maxSelectableOptions: json['max_selectable_options'] as int? ?? 999,
    );

Map<String, dynamic> _$PollTaskToJson(PollTask instance) => <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type]!,
      'manager_ids': instance.managerIDs,
      'participant_ids': instance.participantIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'question': instance.question,
      'answer_options': instance.answerOptions,
      'answers': instance.answers.map((e) => e.toJson()).toList(),
      'feedback_on_answer': instance.feedbackOnAnswer,
      'is_live': instance.isLive,
      'is_confidential': instance.isConfidential,
      'is_multiple_choice': instance.isMultipleChoice,
      'max_selectable_options': instance.maxSelectableOptions,
    };

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      voterID: json['voter_id'] as String,
      votes: (json['votes'] as List<dynamic>).map((e) => e as String).toList(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'voter_id': instance.voterID,
      'votes': instance.votes,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

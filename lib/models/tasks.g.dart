// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    involvedIDs: (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TaskTypeEnumMap = {
  TaskType.agenda: 'agenda',
  TaskType.janitor: 'janitor',
  TaskType.reservation: 'reservation',
  TaskType.timetable: 'timetable',
  TaskType.cleaning: 'cleaning',
  TaskType.bookloan: 'bookloan',
  TaskType.poll: 'poll',
};

AgendaTask _$AgendaTaskFromJson(Map<String, dynamic> json) {
  return AgendaTask(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
    organizerIDs: (json['organizer_ids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  )..involvedIDs = (json['involved_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$AgendaTaskToJson(AgendaTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'organizer_ids': instance.organizerIDs,
    };

TimetableTask _$TimetableTaskFromJson(Map<String, dynamic> json) {
  return TimetableTask(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
    organizerIDs: (json['organizer_ids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    resourceIDs: (json['resource_ids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  )..involvedIDs = (json['involved_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$TimetableTaskToJson(TimetableTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'organizer_ids': instance.organizerIDs,
      'resource_ids': instance.resourceIDs,
    };

JanitorTask _$JanitorTaskFromJson(Map<String, dynamic> json) {
  return JanitorTask(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
    feedback: (json['feedback'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    placeID: json['place_id'] as String,
    status: _$enumDecode(_$TaskStatusEnumMap, json['status']),
    answer: json['answer'] as String?,
  )..involvedIDs = (json['involved_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$JanitorTaskToJson(JanitorTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'feedback': instance.feedback,
      'place_id': instance.placeID,
      'status': _$TaskStatusEnumMap[instance.status],
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

CleaningTask _$CleaningTaskFromJson(Map<String, dynamic> json) {
  return CleaningTask(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
    feedback: (json['feedback'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    status: _$enumDecode(_$TaskStatusEnumMap, json['status']),
  )..involvedIDs = (json['involved_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$CleaningTaskToJson(CleaningTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'feedback': instance.feedback,
      'status': _$TaskStatusEnumMap[instance.status],
    };

BookloanTask _$BookloanTaskFromJson(Map<String, dynamic> json) {
  return BookloanTask(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
    bookID: json['book_id'] as String,
  )..involvedIDs = (json['involved_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$BookloanTaskToJson(BookloanTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'book_id': instance.bookID,
    };

PollTask _$PollTaskFromJson(Map<String, dynamic> json) {
  return PollTask(
    uid: json['uid'] as String,
    name: json['name'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    type: _$enumDecode(_$TaskTypeEnumMap, json['type']),
    description: json['description'] as String?,
    lastUpdate: DateTime.parse(json['last_update'] as String),
    question: json['question'] as String,
    answerOptions: (json['answer_options'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    answers: (json['answers'] as List<dynamic>)
        .map((e) => Vote.fromJson(e as Map<String, dynamic>))
        .toList(),
    issuerIDs:
        (json['issuer_ids'] as List<dynamic>).map((e) => e as String).toList(),
    isLive: json['is_live'] as bool,
    isConfidential: json['is_confidential'] as bool,
    isMultipleChoice: json['is_multiple_choice'] as bool,
    maxSelectableOptions: json['max_selectable_options'] as int,
  )..involvedIDs = (json['involved_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$PollTaskToJson(PollTask instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involved_ids': instance.involvedIDs,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'question': instance.question,
      'answer_options': instance.answerOptions,
      'answers': instance.answers.map((e) => e.toJson()).toList(),
      'issuer_ids': instance.issuerIDs,
      'is_live': instance.isLive,
      'is_confidential': instance.isConfidential,
      'is_multiple_choice': instance.isMultipleChoice,
      'max_selectable_options': instance.maxSelectableOptions,
    };

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return Vote(
    voterID: json['voter_id'] as String,
    votes: (json['votes'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'voter_id': instance.voterID,
      'votes': instance.votes,
    };

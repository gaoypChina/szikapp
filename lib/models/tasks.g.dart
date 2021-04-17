// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaTask _$AgendaTaskFromJson(Map<String, dynamic> json) {
  return AgendaTask(
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    organizerIDs: (json['organizer_ids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  )
    ..involvedIDs = (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..lastUpdate = DateTime.parse(json['last_update'] as String);
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

const _$TaskTypeEnumMap = {
  TaskType.agenda: 'agenda',
  TaskType.janitor: 'janitor',
  TaskType.reservation: 'reservation',
  TaskType.timetable: 'timetable',
  TaskType.cleaning: 'cleaning',
  TaskType.bookloan: 'bookloan',
};

TimetableTask _$TimetableTaskFromJson(Map<String, dynamic> json) {
  return TimetableTask(
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    organizerIDs: (json['organizer_ids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    resourceIDs: (json['resource_ids'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  )
    ..involvedIDs = (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..lastUpdate = DateTime.parse(json['last_update'] as String);
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
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    feedback: (json['feedback'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    placeID: json['place_id'] as String,
    status: _$enumDecode(_$TaskStatusEnumMap, json['status']),
  )
    ..involvedIDs = (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..lastUpdate = DateTime.parse(json['last_update'] as String);
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

const _$TaskStatusEnumMap = {
  TaskStatus.sent: 'sent',
  TaskStatus.irresolvable: 'irresolvable',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.awaitingApproval: 'awaiting_approval',
  TaskStatus.refused: 'refused',
  TaskStatus.approved: 'approved',
};

CleaningTask _$CleaningTaskFromJson(Map<String, dynamic> json) {
  return CleaningTask(
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    feedback: (json['feedback'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    status: _$enumDecode(_$TaskStatusEnumMap, json['status']),
  )
    ..involvedIDs = (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..lastUpdate = DateTime.parse(json['last_update'] as String);
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
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    bookID: json['book_id'] as String,
  )
    ..involvedIDs = (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..lastUpdate = DateTime.parse(json['last_update'] as String);
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
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    question: json['question'] as String,
    answerOptions: (json['answer_options'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    answers: (json['answers'] as List<dynamic>?)
        ?.map((e) => Map<String, String>.from(e as Map))
        .toList(),
    issuerIDs:
        (json['issuer_ids'] as List<dynamic>).map((e) => e as String).toList(),
    isLive: json['is_live'] as bool?,
    isConfidential: json['is_confidential'] as bool?,
    isMultipleChoice: json['is_multiple_choice'] as bool?,
  )
    ..involvedIDs = (json['involved_ids'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..lastUpdate = DateTime.parse(json['last_update'] as String);
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
      'answers': instance.answers,
      'issuer_ids': instance.issuerIDs,
      'is_live': instance.isLive,
      'is_confidential': instance.isConfidential,
      'is_multiple_choice': instance.isMultipleChoice,
    };

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
    organizerID: json['organizerID'] as String,
  )
    ..involvedIDs =
        (json['involvedIDs'] as List)?.map((e) => e as String)?.toList()
    ..lastUpdate = json['lastUpdate'] == null
        ? null
        : DateTime.parse(json['lastUpdate'] as String);
}

Map<String, dynamic> _$AgendaTaskToJson(AgendaTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'organizerID': instance.organizerID,
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
    organizerIDs:
        (json['organizerIDs'] as List)?.map((e) => e as String)?.toList(),
    resourceIDs:
        (json['resourceIDs'] as List)?.map((e) => e as String)?.toList(),
  )
    ..involvedIDs =
        (json['involvedIDs'] as List)?.map((e) => e as String)?.toList()
    ..lastUpdate = json['lastUpdate'] == null
        ? null
        : DateTime.parse(json['lastUpdate'] as String);
}

Map<String, dynamic> _$TimetableTaskToJson(TimetableTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'organizerIDs': instance.organizerIDs,
      'resourceIDs': instance.resourceIDs,
    };

JanitorTask _$JanitorTaskFromJson(Map<String, dynamic> json) {
  return JanitorTask(
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    feedback: (json['feedback'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
    roomID: json['roomID'] as String,
    status: _$enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
  )
    ..involvedIDs =
        (json['involvedIDs'] as List)?.map((e) => e as String)?.toList()
    ..lastUpdate = json['lastUpdate'] == null
        ? null
        : DateTime.parse(json['lastUpdate'] as String);
}

Map<String, dynamic> _$JanitorTaskToJson(JanitorTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'feedback': instance.feedback,
      'roomID': instance.roomID,
      'status': _$TaskStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TaskStatusEnumMap = {
  TaskStatus.noticed: 'noticed',
  TaskStatus.inProgress: 'inprogress',
  TaskStatus.completed: 'completed',
};

CleaningTask _$CleaningTaskFromJson(Map<String, dynamic> json) {
  return CleaningTask(
    uid: json['uid'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'],
    feedback: (json['feedback'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
    status: _$enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
  )
    ..involvedIDs =
        (json['involvedIDs'] as List)?.map((e) => e as String)?.toList()
    ..lastUpdate = json['lastUpdate'] == null
        ? null
        : DateTime.parse(json['lastUpdate'] as String);
}

Map<String, dynamic> _$CleaningTaskToJson(CleaningTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
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
    bookID: json['bookID'] as String,
  )
    ..involvedIDs =
        (json['involvedIDs'] as List)?.map((e) => e as String)?.toList()
    ..lastUpdate = json['lastUpdate'] == null
        ? null
        : DateTime.parse(json['lastUpdate'] as String);
}

Map<String, dynamic> _$BookloanTaskToJson(BookloanTask instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
      'bookID': instance.bookID,
    };

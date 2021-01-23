// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaTask _$AgendaTaskFromJson(Map<String, dynamic> json) {
  return AgendaTask(
    taskID: json['taskID'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'] as String,
    organizerID: json['organizerID'] as String,
  )..involvedIDs =
      (json['involvedIDs'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$AgendaTaskToJson(AgendaTask instance) =>
    <String, dynamic>{
      'taskID': instance.taskID,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'organizerID': instance.organizerID,
    };

const _$TaskTypeEnumMap = {
  TaskType.AGENDA: 'agenda',
  TaskType.JANITOR: 'janitor',
  TaskType.RESERVATION: 'reservation',
  TaskType.TIMETABLE: 'timetable',
  TaskType.CLEANING: 'cleaning',
  TaskType.BOOKLOAN: 'bookloan',
};

TimetableTask _$TimetableTaskFromJson(Map<String, dynamic> json) {
  return TimetableTask(
    taskID: json['taskID'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'] as String,
    organizerID: json['organizerID'] as String,
    roomID: json['roomID'] as String,
  )..involvedIDs =
      (json['involvedIDs'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TimetableTaskToJson(TimetableTask instance) =>
    <String, dynamic>{
      'taskID': instance.taskID,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
      'organizerID': instance.organizerID,
      'roomID': instance.roomID,
    };

JanitorTask _$JanitorTaskFromJson(Map<String, dynamic> json) {
  return JanitorTask(
    taskID: json['taskID'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'] as String,
    roomID: json['roomID'] as String,
    status: _$enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
  )..involvedIDs =
      (json['involvedIDs'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$JanitorTaskToJson(JanitorTask instance) =>
    <String, dynamic>{
      'taskID': instance.taskID,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
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
  TaskStatus.NOTICED: 'noticed',
  TaskStatus.INPROGRESS: 'inprogress',
  TaskStatus.COMPLETED: 'completed',
};

CleaningTask _$CleaningTaskFromJson(Map<String, dynamic> json) {
  return CleaningTask(
    taskID: json['taskID'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    description: json['description'] as String,
  )..involvedIDs =
      (json['involvedIDs'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$CleaningTaskToJson(CleaningTask instance) =>
    <String, dynamic>{
      'taskID': instance.taskID,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'description': instance.description,
    };

BookloanTask _$BookloanTaskFromJson(Map<String, dynamic> json) {
  return BookloanTask(
    taskID: json['taskID'],
    name: json['name'],
    start: json['start'],
    end: json['end'],
    type: json['type'],
    bookID: json['bookID'] as String,
  )..involvedIDs =
      (json['involvedIDs'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$BookloanTaskToJson(BookloanTask instance) =>
    <String, dynamic>{
      'taskID': instance.taskID,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'involvedIDs': instance.involvedIDs,
      'bookID': instance.bookID,
    };

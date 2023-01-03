// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningExchange _$CleaningExchangeFromJson(Map<String, dynamic> json) =>
    CleaningExchange(
      id: json['uid'] as String,
      taskID: json['task_id'] as String,
      initiatorID: json['initiator_id'] as String,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.created,
      replacements: (json['replacements'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$CleaningExchangeToJson(CleaningExchange instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'task_id': instance.taskID,
      'initiator_id': instance.initiatorID,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'replacements': instance.replacements,
      'last_update': instance.lastUpdate.toIso8601String(),
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

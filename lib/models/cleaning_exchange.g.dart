// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Replacement _$ReplacementFromJson(Map<String, dynamic> json) => Replacement(
      taskID: json['task_id'] as String,
      replacerID: json['replacer_id'] as String,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.created,
    );

Map<String, dynamic> _$ReplacementToJson(Replacement instance) =>
    <String, dynamic>{
      'task_id': instance.taskID,
      'replacer_id': instance.replacerID,
      'status': _$TaskStatusEnumMap[instance.status]!,
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

CleaningExchange _$CleaningExchangeFromJson(Map<String, dynamic> json) =>
    CleaningExchange(
      id: json['uid'] as String,
      taskID: json['task_id'] as String,
      initiatorID: json['initiator_id'] as String,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.created,
      replacements: (json['replacements'] as List<dynamic>?)
              ?.map((e) => Replacement.fromJson(e as Map<String, dynamic>))
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
      'replacements': instance.replacements.map((e) => e.toJson()).toList(),
      'last_update': instance.lastUpdate.toIso8601String(),
    };

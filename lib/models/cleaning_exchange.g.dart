// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningExchange _$CleaningExchangeFromJson(Map<String, dynamic> json) =>
    CleaningExchange(
      id: json['id'] as String,
      taskID: json['task_id'] as String,
      initiatorID: json['initiator_id'] as String,
      replaceTaskID: json['replace_task_id'] as String?,
      approved: json['approved'] as bool? ?? false,
      replacements: (json['replacements'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$CleaningExchangeToJson(CleaningExchange instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskID,
      'initiator_id': instance.initiatorID,
      'replace_task_id': instance.replaceTaskID,
      'approved': instance.approved,
      'replacements': instance.replacements,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningExchange _$CleaningExchangeFromJson(Map<String, dynamic> json) {
  return CleaningExchange(
    taskID: json['task_id'] as String,
    initiatorID: json['initiator_id'] as String,
    replaceTaskID: json['replace_task_id'] as String?,
    responderID: json['responder_id'] as String?,
    approved: json['approved'] as bool,
    rejected: (json['rejected'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    lastUpdate: DateTime.parse(json['last_update'] as String),
  );
}

Map<String, dynamic> _$CleaningExchangeToJson(CleaningExchange instance) =>
    <String, dynamic>{
      'task_id': instance.taskID,
      'initiator_id': instance.initiatorID,
      'replace_task_id': instance.replaceTaskID,
      'responder_id': instance.responderID,
      'approved': instance.approved,
      'rejected': instance.rejected,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningExchange _$CleaningExchangeFromJson(Map<String, dynamic> json) {
  return CleaningExchange(
    taskID: json['taskID'] as String,
    initiatorID: json['initiatorID'] as String,
    replaceTaskID: json['replaceTaskID'] as String?,
    responderID: json['responderID'] as String?,
    approved: json['approved'] as bool,
    rejected: (json['rejected'] as List<dynamic>?)
        ?.map((e) => e as Map<String, dynamic>)
        .toList(),
    lastUpdate: DateTime.parse(json['lastUpdate'] as String),
  );
}

Map<String, dynamic> _$CleaningExchangeToJson(CleaningExchange instance) =>
    <String, dynamic>{
      'taskID': instance.taskID,
      'initiatorID': instance.initiatorID,
      'replaceTaskID': instance.replaceTaskID,
      'responderID': instance.responderID,
      'approved': instance.approved,
      'rejected': instance.rejected,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

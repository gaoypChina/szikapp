// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningPeriod _$CleaningPeriodFromJson(Map<String, dynamic> json) =>
    CleaningPeriod(
      uid: json['uid'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      isLive: json['is_live'] as bool? ?? false,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$CleaningPeriodToJson(CleaningPeriod instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'is_live': instance.isLive,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

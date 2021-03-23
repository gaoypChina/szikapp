// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningPeriod _$CleaningPeriodFromJson(Map<String, dynamic> json) {
  return CleaningPeriod(
    uid: json['uid'] as String,
    start: DateTime.parse(json['start'] as String),
    end: DateTime.parse(json['end'] as String),
    isLive: json['isLive'] as bool,
    lastUpdate: json['lastUpdate'] == null
        ? null
        : DateTime.parse(json['lastUpdate'] as String),
  );
}

Map<String, dynamic> _$CleaningPeriodToJson(CleaningPeriod instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'isLive': instance.isLive,
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_administration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CleaningPeriod _$CleaningPeriodFromJson(Map<String, dynamic> json) =>
    CleaningPeriod(
      id: json['uid'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      isLive: json['is_live'] as bool? ?? false,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$CleaningPeriodToJson(CleaningPeriod instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'is_live': instance.isLive,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

CleaningParticipants _$CleaningParticipantsFromJson(
        Map<String, dynamic> json) =>
    CleaningParticipants(
      groupIDs:
          (json['group_ids'] as List<dynamic>).map((e) => e as String).toList(),
      blackList: (json['black_list'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$CleaningParticipantsToJson(
        CleaningParticipants instance) =>
    <String, dynamic>{
      'group_ids': instance.groupIDs,
      'black_list': instance.blackList,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

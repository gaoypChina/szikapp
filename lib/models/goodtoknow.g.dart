// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goodtoknow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodToKnow _$GoodToKnowFromJson(Map<String, dynamic> json) => GoodToKnow(
      uid: json['uid'] as String,
      title: json['title'] as String,
      category: _$enumDecode(_$GoodToKnowCategoryEnumMap, json['category']),
      description: json['description'] as String?,
      keyValuePairs: (json['key_value_pairs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$GoodToKnowToJson(GoodToKnow instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'category': _$GoodToKnowCategoryEnumMap[instance.category],
      'description': instance.description,
      'key_value_pairs': instance.keyValuePairs,
      'last_update': instance.lastUpdate.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$GoodToKnowCategoryEnumMap = {
  GoodToKnowCategory.document: 'document',
  GoodToKnowCategory.pinned_post: 'pinned_post',
};

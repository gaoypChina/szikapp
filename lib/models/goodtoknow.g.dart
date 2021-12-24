// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goodtoknow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodToKnow _$GoodToKnowFromJson(Map<String, dynamic> json) => GoodToKnow(
      uid: json['uid'] as String,
      title: json['title'] as String,
      category: $enumDecode(_$GoodToKnowCategoryEnumMap, json['category']),
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

const _$GoodToKnowCategoryEnumMap = {
  GoodToKnowCategory.document: 'document',
  GoodToKnowCategory.pinned_post: 'pinned_post',
};

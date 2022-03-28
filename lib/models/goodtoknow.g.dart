// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goodtoknow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodToKnow _$GoodToKnowFromJson(Map<String, dynamic> json) => GoodToKnow(
      id: json['id'],
      title: json['title'] as String,
      category: $enumDecode(_$GoodToKnowCategoryEnumMap, json['category']),
      keyValuePairs: (json['key_value_pairs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      name: json['name'] as String,
      description: json['description'] as String?,
      lastUpdate: DateTime.parse(json['last_update'] as String),
    );

Map<String, dynamic> _$GoodToKnowToJson(GoodToKnow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'last_update': instance.lastUpdate.toIso8601String(),
      'title': instance.title,
      'category': _$GoodToKnowCategoryEnumMap[instance.category],
      'key_value_pairs': instance.keyValuePairs,
    };

const _$GoodToKnowCategoryEnumMap = {
  GoodToKnowCategory.document: 'document',
  GoodToKnowCategory.pinnedPost: 'pinned_post',
};

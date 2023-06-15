import 'package:json_annotation/json_annotation.dart';
import '../utils/utils.dart';
import 'models.dart';

part 'goodtoknow.g.dart';

enum GoodToKnowCategory {
  @JsonValue('document')
  document,
  @JsonValue('pinned_post')
  pinnedPost;

  static GoodToKnowCategory categoryFromJson(dynamic rawCategory) {
    for (var category in GoodToKnowCategory.values) {
      if (category.toString() == rawCategory.toString()) {
        return category;
      }
    }
    return GoodToKnowCategory.document;
  }
}

@JsonSerializable()
class GoodToKnow extends Resource implements Identifiable, Cachable {
  static const String urlKey = 'url';

  String title;
  @JsonKey(fromJson: GoodToKnowCategory.categoryFromJson)
  GoodToKnowCategory category;
  @JsonKey(name: 'key_value_pairs')
  KeyValuePairs? keyValuePairs;

  GoodToKnow({
    required super.id,
    required this.title,
    required this.category,
    this.keyValuePairs,
    required super.name,
    super.description,
    required super.lastUpdate,
  });

  @override
  Json toJson() => _$GoodToKnowToJson(this);

  factory GoodToKnow.fromJson(Json json) => _$GoodToKnowFromJson(json);
}

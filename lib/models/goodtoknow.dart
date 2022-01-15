import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';

part 'goodtoknow.g.dart';

enum GoodToKnowCategory {
  @JsonValue('document')
  document,
  @JsonValue('pinned_post')
  pinned_post,
}

@JsonSerializable()
class GoodToKnow {
  static const String urlKey = 'url';

  final String uid;
  String title;
  GoodToKnowCategory category;
  String? description;
  @JsonKey(name: 'key_value_pairs')
  KeyValuePairs? keyValuePairs;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  GoodToKnow({
    required this.uid,
    required this.title,
    required this.category,
    this.description,
    this.keyValuePairs,
    required this.lastUpdate,
  });

  Json toJson() => _$GoodToKnowToJson(this);

  factory GoodToKnow.fromJson(Json json) => _$GoodToKnowFromJson(json);
}

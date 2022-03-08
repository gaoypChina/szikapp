import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';
import 'interfaces.dart';
import 'models.dart';

part 'goodtoknow.g.dart';

enum GoodToKnowCategory {
  @JsonValue('document')
  document,
  @JsonValue('pinned_post')
  pinnedPost,
}

@JsonSerializable()
class GoodToKnow extends Resource implements Identifiable, Cachable {
  static const String urlKey = 'url';

  String title;
  GoodToKnowCategory category;
  @JsonKey(name: 'key_value_pairs')
  KeyValuePairs? keyValuePairs;

  GoodToKnow({
    required id,
    required this.title,
    required this.category,
    this.keyValuePairs,
    required String name,
    String? description,
    required DateTime lastUpdate,
  }) : super(
          id: id,
          name: name,
          description: description,
          lastUpdate: lastUpdate,
        );

  @override
  Json toJson() => _$GoodToKnowToJson(this);

  factory GoodToKnow.fromJson(Json json) => _$GoodToKnowFromJson(json);
}

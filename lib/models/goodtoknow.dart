import 'package:json_annotation/json_annotation.dart';
import '../utils/types.dart';

part 'goodtoknow.g.dart';

@JsonSerializable()
class GoodToKnow {
  final String uid;
  String title;
  String? description;
  @JsonKey(name: 'key_value_pairs')
  KeyValuePairs? keyValuePairs;
  @JsonKey(name: 'last_update')
  final DateTime lastUpdate;

  GoodToKnow({
    required this.uid,
    required this.title,
    this.description,
    this.keyValuePairs,
    required this.lastUpdate,
  });

  Json toJson() => _$GoodToKnowToJson(this);

  factory GoodToKnow.fromJson(Json json) => _$GoodToKnowFromJson(json);
}

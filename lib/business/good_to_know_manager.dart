import '../models/goodtoknow.dart';
import '../utils/io.dart';

class GoodToKnowManager {
  late List<GoodToKnow> _posts;

  static final GoodToKnowManager _instance =
      GoodToKnowManager._privateConstructor();

  factory GoodToKnowManager() => _instance;

  GoodToKnowManager._privateConstructor() {
    _posts = [];
  }

  List<GoodToKnow> get posts => List.unmodifiable(_posts);

  Future<bool> addItem(GoodToKnow item) async {
    var io = IO();
    await io.postGoodToKnow(item);

    posts.add(item);

    return true;
  }

  Future<bool> editItem(GoodToKnow item) async {
    if (!posts.contains(item)) return false;

    var io = IO();
    var parameter = {'id': item.uid};
    await io.putGoodToKnow(item, parameter);

    posts.removeWhere((element) => element.uid == item.uid);
    posts.add(item);
    return true;
  }

  Future<bool> deleteItem(GoodToKnow item) async {
    if (!posts.contains(item)) return false;

    var io = IO();
    var parameter = {'id': item.uid};
    await io.deleteGoodToKnow(parameter, item.lastUpdate);

    posts.remove(item);

    return true;
  }

  List<GoodToKnow> search(String text) {
    if (text == '') {
      return posts;
    } else {
      var results = <GoodToKnow>[];
      for (var item in _posts) {
        if (item.title.contains(text)) {
          results.add(item);
        }
      }
      return results;
    }
  }

  List<GoodToKnow> filter(GoodToKnowCategory category) {
    return _posts.where((element) => element.category == category).toList();
  }

  Future<void> refresh() async {
    var io = IO();
    _posts = await io.getGoodToKnow();
  }
}

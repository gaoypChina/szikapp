import '../models/goodtoknow.dart';
import '../utils/io.dart';

class GoodToKnowManager {
  List<GoodToKnow> _posts = [];

  static final GoodToKnowManager _instance =
      GoodToKnowManager._privateConstructor();

  factory GoodToKnowManager() => _instance;

  GoodToKnowManager._privateConstructor() {
    refresh();
  }

  List<GoodToKnow> get posts => List.unmodifiable(_posts);

  Future<bool> addItem(GoodToKnow item) async {
    var io = IO();
    await io.postGoodToKnow(item);

    _posts.add(item);

    return true;
  }

  Future<bool> editItem(GoodToKnow item) async {
    if (!_posts.contains(item)) return false;

    var io = IO();
    var parameter = {'id': item.uid};
    await io.putGoodToKnow(item, parameter);

    _posts.removeWhere((element) => element.uid == item.uid);
    _posts.add(item);
    return true;
  }

  Future<bool> deleteItem(GoodToKnow item) async {
    if (!_posts.contains(item)) return false;

    var io = IO();
    var parameter = {'id': item.uid};
    await io.deleteGoodToKnow(parameter, item.lastUpdate);

    _posts.remove(item);

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

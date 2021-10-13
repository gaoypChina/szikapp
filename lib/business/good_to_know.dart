import '../models/goodtoknow.dart';
import '../utils/io.dart';

class Goodtoknow {
  late List<GoodToKnow> posts;

  static final Goodtoknow _instance = Goodtoknow._privateConstructor();

  factory Goodtoknow() => _instance;

  Goodtoknow._privateConstructor() {
    posts = [];
  }

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

  void refresh() async {
    var io = IO();
    posts = await io.getGoodToKnow();
  }
}

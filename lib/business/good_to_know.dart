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
    var io = IO();
    var parameter = {'id': item.uid};
    await io.putGoodToKnow(item, parameter);

    posts.removeWhere((element) => element.uid == item.uid);
    posts.add(item);
    return true;
  }

  Future<bool> deketeItem(GoodToKnow post) async {
    if (!posts.contains(post)) return true;

    var io = IO();
    var parameter = {'id': post.uid};
    await io.deleteGoodToKnow(parameter, post.lastUpdate);

    posts.remove(post);

    return true;
  }

  void refresh() async {
    var io = IO();
    posts = await io.getGoodToKnow();
  }
}

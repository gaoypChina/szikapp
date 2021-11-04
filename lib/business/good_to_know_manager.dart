import 'package:flutter/material.dart';

import '../models/goodtoknow.dart';
import '../utils/io.dart';

class GoodToKnowManager extends ChangeNotifier {
  List<GoodToKnow> _posts = [];
  bool _createNewItem = false;
  bool _editItem = false;

  static final GoodToKnowManager _instance =
      GoodToKnowManager._privateConstructor();

  factory GoodToKnowManager() => _instance;

  GoodToKnowManager._privateConstructor();

  List<GoodToKnow> get posts => List.unmodifiable(_posts);
  bool get isCreatingNewItem => _createNewItem;
  bool get isEditingItem => _editItem;

  void createNewItem() {
    _createNewItem = true;
    _editItem = false;
    notifyListeners();
  }

  void editItem() {
    _createNewItem = false;
    _editItem = true;
    notifyListeners();
  }

  Future<bool> addItem(GoodToKnow item) async {
    var io = IO();
    await io.postGoodToKnow(item);

    _posts.add(item);
    _createNewItem = false;
    _editItem = false;
    notifyListeners();
    return true;
  }

  Future<bool> updateItem(GoodToKnow item) async {
    if (!_posts.contains(item)) return false;

    var io = IO();
    var parameter = {'id': item.uid};
    await io.putGoodToKnow(item, parameter);

    _posts.removeWhere((element) => element.uid == item.uid);
    _posts.add(item);
    _createNewItem = false;
    _editItem = false;
    notifyListeners();
    return true;
  }

  Future<bool> deleteItem(GoodToKnow item) async {
    if (!_posts.contains(item)) return false;

    var io = IO();
    var parameter = {'id': item.uid};
    await io.deleteGoodToKnow(parameter, item.lastUpdate);

    _posts.remove(item);
    _createNewItem = false;
    _editItem = false;
    notifyListeners();
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
      return List.unmodifiable(results);
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

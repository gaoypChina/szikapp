import 'package:flutter/material.dart';

import '../models/models.dart';
import '../utils/utils.dart';

class GoodToKnowManager extends ChangeNotifier {
  List<GoodToKnow> _posts = [];
  int _selectedIndex = -1;
  bool _createNewItem = false;
  bool _editItem = false;

  static final GoodToKnowManager _instance =
      GoodToKnowManager._privateConstructor();

  factory GoodToKnowManager() => _instance;

  GoodToKnowManager._privateConstructor();

  List<GoodToKnow> get items => List.unmodifiable(_posts);
  int get selectedIndex => _selectedIndex;
  GoodToKnow? get selectedItem =>
      selectedIndex != -1 ? _posts[selectedIndex] : null;
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

  void setSelectedGoodToKnowItem({required String id}) {
    final index = _posts.indexWhere((post) => post.id == id);
    _selectedIndex = index;
    _createNewItem = false;
    _editItem = true;
    notifyListeners();
  }

  Future<bool> addItem({required GoodToKnow item}) async {
    var io = IO();
    await io.postGoodToKnow(data: item);

    _posts.add(item);
    _createNewItem = false;
    _editItem = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  Future<bool> updateItem({required GoodToKnow item}) async {
    if (!_posts.any((post) => post.id == item.id)) return false;

    var io = IO();
    var parameter = {'id': item.id};
    await io.putGoodToKnow(data: item, parameters: parameter);

    _posts.removeWhere((post) => post.id == item.id);
    _posts.add(item);
    _createNewItem = false;
    _editItem = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  Future<bool> deleteItem({required GoodToKnow item}) async {
    if (!_posts.any((post) => post.id == item.id)) return false;

    var io = IO();
    var parameter = {'id': item.id};
    await io.deleteGoodToKnow(
        parameters: parameter, lastUpdate: item.lastUpdate);

    _posts.remove(item);
    _createNewItem = false;
    _editItem = false;
    _selectedIndex = -1;
    notifyListeners();
    return true;
  }

  List<GoodToKnow> search({required String text}) {
    if (text == '') {
      return _posts;
    } else {
      var results = <GoodToKnow>[];
      for (var item in _posts) {
        if (item.title.toLowerCase().contains(text.toLowerCase())) {
          results.add(item);
        }
      }
      return List.unmodifiable(results);
    }
  }

  List<GoodToKnow> filter({required GoodToKnowCategory category}) {
    return List.unmodifiable(
      _posts.where((post) => post.category == category).toList(),
    );
  }

  Future<void> refresh() async {
    try {
      var io = IO();
      _posts = await io.getGoodToKnow();
    } on IONotModifiedException {
      _posts = [];
    }
  }
}

class Calendar {
  static final Calendar _instance = Calendar._privateConstructor();
  factory Calendar() => _instance;
  Calendar._privateConstructor() {
    refresh();
  }

  Future<void> refresh() async {}
}

///Naptár funkció logikai működését megvalósító singleton háttérosztály.
class Calendar {
  ///Singleton osztálypéldány
  static final Calendar _instance = Calendar._privateConstructor();

  ///Publikus konstruktor, ami visszatér a singleton példánnyal.
  factory Calendar() => _instance;

  ///Privát konstruktor
  Calendar._privateConstructor() {
    refresh();
  }

  Future<void> refresh() async {}
}

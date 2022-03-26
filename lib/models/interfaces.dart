abstract class Identifiable {
  final String id;

  Identifiable(this.id);
}

abstract class Cachable {
  final DateTime lastUpdate;

  Cachable(this.lastUpdate);
}

/*
  //Publikus változók - amik a specifikációban vannak

  //Privát változók - amikre szerinted szükség van

  //Setterek és getterek - amennyiben vannak validálandó publikus váltózóid

  //Publikus függvények aka Interface - amit a specifikáció megkövetel

  //Privát függvények - amikre szerinted szükség van

*/

class BaseException implements Exception {
  String message;

  BaseException(this.message);

  @override
  String toString() => 'Exception: $message\n';
}

class IOException extends BaseException {
  IOException(message) : super(message);
}

class IOServerException extends IOException {
  IOServerException(message) : super(message);
}

class IOClientException extends IOException {
  IOClientException(message) : super(message);
}

class IOUnknownException extends IOException {
  IOUnknownException(message) : super(message);
}

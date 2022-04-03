List<int> boolListToInt(List<bool> boolList) {
  var intList = <int>[];

  for (var i = 0; i < boolList.length; i++) {
    if (boolList[i] == true) {
      intList.add(i);
    }
  }
  return intList;
}

List<bool> intListToBool(List<int> intList, int length) {
  var boolList = List<bool>.filled(length, false);

  for (var index in intList) {
    boolList[index] = true;
  }
  return boolList;
}

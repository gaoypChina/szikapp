///Általános `JSON` adattípus
typedef Json = Map<String, dynamic>;

///String kulcs-érték párokat tároló típus
typedef KeyValuePairs = Map<String, String>;

extension StringExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200b');
  }
}

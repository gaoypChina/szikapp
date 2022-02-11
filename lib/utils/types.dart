///Általános `JSON` adattípus
typedef Json = Map<String, dynamic>;

///String kulcs-érték párokat tároló típus
typedef KeyValuePairs = Map<String, String>;

extension StringExtension on String {
  ///Extension function on [String]s to correct [Textoverflow.ellipsis] behaviour
  ///on flexible text widgets.
  String useCorrectEllipsis() {
    return replaceAll('', '\u200b');
  }
}

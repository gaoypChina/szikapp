import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences.dart';
import 'io.dart';

class Settings {

  //Privát változók
  SharedPreferences? ownSharedPreferences;
  Settings(){intialize();}
  
  //Getterek
  DarkMode get darkMode { 
    var value = ownSharedPreferences!.getString('darkMode');
    return DarkMode.values.firstWhere((element) => 
    element.toString()=='DarkMode.$value');
  }

  Language get language { 
    var value = ownSharedPreferences!.getString('language');
    return Language.values.firstWhere((element) => 
    element.toString()=='Language.$value');
  }

  Theme get theme { 
    var value = ownSharedPreferences!.getString('theme');
    return Theme.values.firstWhere((element) => 
    element.toString()=='Theme.$value');
  }

  bool? get dataLite => ownSharedPreferences!.getBool('dataLite');

  Map <String, bool>? get notifications {
    var enabled = ownSharedPreferences!.getStringList('enabled');
    var disabled = ownSharedPreferences!.getStringList('disabled');
    var result = <String, bool>{};
    
    enabled!.forEach((element) {result.putIfAbsent(element, () => true);});
    disabled!.forEach((element) {result.putIfAbsent(element, () => false);});
    
    return result;
  }

  //Setterek
 set darkMode (DarkMode mode) { 
    ownSharedPreferences!.setString('darkMode', mode.toString());
  }

 set language (Language ownLanguage) { 
    ownSharedPreferences!.setString('language', ownLanguage.toString());
  }

 set theme (Theme ownTheme) { 
    ownSharedPreferences!.setString('theme', ownTheme.toString());
  }

  set dataLite (bool? ownLite){
    ownLite ??= false;
    ownSharedPreferences!.setBool('dataLite', ownLite);
  } 

  set notifications (Map<String,bool>? notif){
    var enabled = <String>[];
    var disabled = <String>[];
    for(var key in notif!.keys){
      notif[key] == true? enabled.add(key): disabled.add(key);
    }
    ownSharedPreferences!.setStringList('disabled',disabled);
    ownSharedPreferences!.setStringList('enabled',enabled);
      }

  //További publikus függvények (Interface)
  bool loadPreferences(){
    var io = IO();
    var serverPreferences = io.getUserPreferences();
    darkMode = serverPreferences.darkMode;
    theme = serverPreferences.theme;
    language = serverPreferences.language;
    dataLite = serverPreferences.dataLite;
    notifications = serverPreferences.notifications;
    return true;
  }

  bool savePreferences(){ 
  var prefs = Preferences();
  prefs.darkMode = darkMode; 
  prefs.language = language;
  prefs.theme = theme;

  var io = IO();
  io.putUserPreferences(data:prefs);
  return true;
  }

  //Publikus függvények
  void intialize () async {
    ownSharedPreferences??= await SharedPreferences.getInstance();
  }

}
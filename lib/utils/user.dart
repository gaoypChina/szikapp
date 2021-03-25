import 'package:json_annotation/json_annotation.dart';
import 'package:szikapp/utils/io.dart';//Warning1

class User {
  //Publikus változók - amik a specifikációban vannak
  String?       name;
  String?       email;
  Uri?          profilePicture;
  String?       nick;
  DateTime?     birthday;
  String?       phone;
  String?       secondaryPhone;
  List<String>? groupIDs;
  //Privát változók - amikre szerinted szükség van

  //Setterek és getterek - amennyiben vannak validálandó publikus váltózóid
  void setBirthday(DateTime birthday){
    if(birthday.isBefore(DateTime(1903, 01, 2))){
      print('Nem lehet ilyen idős'); 
      }
      else{
        this.birthday = birthday; 
      }
  }
  //Publikus függvények aka Interface - amit a specifikáció megkövetel
  User.email(this.email,{String name = 'guest'}){
    // ignore: prefer_initializing_formals
    this.name = name;
    // ignore: prefer_initializing_formals
    groupIDs = <String>[];
  }
  User.data(Uri profilePicture, UserData userData){  //Error1: Undefined class 'UserData'
    // ignore: prefer_initializing_formals
    this.profilePicture = profilePicture;
    name = userData.name;
    email = userData.email;
    nick = userData.nick;
    birthday = userData.birthday;
    phone = userData.phone;
    secondaryPhone = userData.secondaryPhone;
    groupIDs = userData.groupIDs;
  }
  // ignore: type_annotate_public_apis
  bool hasPermission(type, Object subject){
    List<String> permissions = getUserPermissions();//Error2: The method 'getUserPermissions' isn't defined for the type 'User'.
    if (permissions.contains(type.toString())){ 
      return true;
   }
   return false;   
  }
  //Privát függvények - amikre szerinted szükség vaN
}
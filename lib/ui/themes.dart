import 'package:flutter/material.dart';
import '../models/tasks.dart';
export 'dark_theme.dart';
export 'light_theme.dart';

///Méretek
const double kIconSizeSmall = 20;
const double kIconSizeNormal = 24;
const double kIconsSizeLarge = 32;

const double kCurveHeight = 12;

///Light theme színek
const Color szikAmour = Color(0xfffefbfc);
const Color szikLavenderBlush = Color(0xfffefafb);
const Color szikMonarch = Color(0xff990e35);
const Color szikTarawera = Color(0xff094757);
const Color szikShiraz = Color(0xffbb1141);

///Dark theme színek
const Color szikDaintree = Color(0xff002b36);
const Color szikEden = Color(0xff0d3d48);
const Color szikSilver = Color(0xffbdbdbd);
const Color szikMalibu = Color(0xff41dfff);
const Color szikSilverChalice = Color(0xffb1b1b1);

///Közös színek
const Color szikHippieBlue = Color(0xff59a3b0);
const Color szikGunSmoke = Color(0xff888989);

///Az egyes [TaskStatus]okhoz rendelt állapotjelző színek.
const Map<TaskStatus, Color> taskStatusColors = {
  TaskStatus.created: Color(0xffa00a34),
  TaskStatus.sent: Color(0xffa00a34),
  TaskStatus.in_progress: Color(0xffffbf1b),
  TaskStatus.irresolvable: Color(0xffa00a34),
  TaskStatus.refused: Color(0xffa00a34),
  TaskStatus.awaiting_approval: Color(0xff278230),
  TaskStatus.approved: Color(0xff278230),
};

TextTheme szikTextTheme = const TextTheme(
  ///Used for emphasizing text that would otherwise be bodyText2.
  ///Nunito, Semi-bold, 18 pt
  bodyText1: TextStyle(
      fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w600),

  ///The default text style for Material.
  ///Nunito, Semi-bold, Italic, 18 pt
  bodyText2: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic),

  ///Used for text on ElevatedButton, TextButton and OutlinedButton.
  ///Montserrat, 18 pt
  button: TextStyle(fontFamily: 'Montserrat', fontSize: 18),

  ///Used for auxiliary text associated with images.
  ///Nunito, italic, 14 pt
  caption: TextStyle(
      fontFamily: 'Nunito', fontSize: 14, fontStyle: FontStyle.italic),

  ///Extremely large text.
  ///Montserrat, 18 pt
  headline1: TextStyle(fontFamily: 'Montserrat', fontSize: 18),

  ///Very, very large text.
  ///Used for the date in the dialog shown by showDatePicker.
  ///Montserrat, Semi-bold, 18 pt
  headline2: TextStyle(
      fontFamily: 'Montserrat', fontSize: 25, fontWeight: FontWeight.w600),

  ///Very large text.
  ///Montserrat, Semi-bold, 18 pt
  headline3: TextStyle(
      fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600),

  ///Large text.
  ///Montserrat, Extra-bold, 18 pt
  headline4: TextStyle(
      fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w800),

  ///Used for large text in dialogs
  ///(e.g., the month and year in the dialog shown by showDatePicker).
  ///Nunito, Black, 18 pt
  headline5: TextStyle(
      fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w900),

  ///Used for the primary text in app bars and dialogs
  ///(e.g., AppBar.title and AlertDialog.title).
  ///Montserrat, 18 pt
  headline6: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
  ),

  ///The smallest style. [...]
  ///Montserrat, 14 pt
  overline: TextStyle(fontFamily: 'Montserrat', fontSize: 12),

  ///Used for the primary text in lists (e.g., ListTile.title).
  ///Montserrat, 14 pt
  subtitle1: TextStyle(fontFamily: 'Montserrat', fontSize: 14),

  ///For medium emphasis text thats a little smaller than subtitle1.
  ///Montserrat, 14 pt
  subtitle2: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
);

import 'package:flutter/material.dart';
import '../models/models.dart';
export 'dark_theme.dart';
export 'light_theme.dart';

///Méretek
const double kIconSizeSmall = 20;
const double kIconSizeNormal = 24;
const double kIconSizeLarge = 32;
const double kIconSizeXLarge = 48;
const double kIconSizeGiant = 64;

const double kPaddingSmall = 5;
const double kPaddingNormal = 10;
const double kPaddingLarge = 20;
const double kPaddingXLarge = 30;

const double kBorderRadiusSmall = 10;
const double kBorderRadiusNormal = 20;
const double kBorderRadiusLarge = 30;

const double kCurveHeight = 8;

const double kCalendarMarkerSize = 5;
const double kDaysOfWeekSize = 20;
const double kSearchBarIconSize = 30;

const double kColorPickerHeight = 100;

///Light theme színek
const Color szikAmour = Color(0xfffefbfc);
const Color szikLavenderBlush = Color(0xfffffafb);
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

///Státusz színek
const Color statusRed = Color(0xffa00a34);
const Color statusYellow = Color(0xffffbf1b);
const Color statusGreen = Color(0xff278230);

///Az egyes [TaskStatus]okhoz rendelt állapotjelző színek.
const Map<TaskStatus, Color> taskStatusColors = {
  TaskStatus.created: statusRed,
  TaskStatus.sent: statusRed,
  TaskStatus.inProgress: statusYellow,
  TaskStatus.irresolvable: statusRed,
  TaskStatus.refused: statusRed,
  TaskStatus.awaitingApproval: statusYellow,
  TaskStatus.approved: statusGreen,
};

///foglalások színei
const Color reservationColor1 = Color(0xff8b5959); //dark
const Color reservationColor2 = Color(0xffc8465d); //dark
const Color reservationColor3 = Color(0xfff9c8c7); //light
const Color reservationColor4 = Color(0xfff9d8d8); //light
const Color reservationColor5 = Color(0xffb8b8b8); //light
const Color reservationColor6 = Color(0xff59a3b0); //dark
const Color reservationColor7 = Color(0xff095555); //dark
const Color reservationColor8 = Color(0xff043130); //dark

const reservationColors = [
  reservationColor1,
  reservationColor2,
  reservationColor3,
  reservationColor4,
  reservationColor5,
  reservationColor6,
  reservationColor7,
  reservationColor8,
];
const darkReservationColors = [
  reservationColor1,
  reservationColor2,
  reservationColor5,
  reservationColor6,
  reservationColor7,
  reservationColor8,
];
const lightReservationColors = [
  reservationColor3,
  reservationColor4,
];

TextTheme szikTextTheme = const TextTheme(
  ///Used for emphasizing text that would otherwise be bodyText2.
  ///Nunito, Semi-bold, 18 pt
  bodyLarge: TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),

  ///The default text style for Material.
  ///Nunito, Semi-bold, Italic, 18 pt
  bodyMedium: TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
  ),

  ///Used for text on ElevatedButton, TextButton and OutlinedButton.
  ///Montserrat, 18 pt
  labelLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
  ),

  ///Used for auxiliary text associated with images.
  ///Nunito, italic, 14 pt
  bodySmall: TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontStyle: FontStyle.italic,
  ),

  ///Extremely large text.
  ///Montserrat, 18 pt
  displayLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
  ),

  ///Very, very large text.
  ///Used for the date in the dialog shown by showDatePicker.
  ///Montserrat, Semi-bold, 18 pt
  displayMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 25,
    fontWeight: FontWeight.w600,
  ),

  ///Very large text.
  ///Montserrat, Semi-bold, 18 pt
  displaySmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),

  ///Large text.
  ///Montserrat, Extra-bold, 18 pt
  headlineMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontWeight: FontWeight.w800,
  ),

  ///Used for large text in dialogs
  ///(e.g., the month and year in the dialog shown by showDatePicker).
  ///Nunito, Black, 18 pt
  headlineSmall: TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w900,
  ),

  ///Used for the primary text in app bars and dialogs
  ///(e.g., AppBar.title and AlertDialog.title).
  ///Montserrat, 18 pt
  titleLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
  ),

  ///The smallest style. [...]
  ///Montserrat, 14 pt
  labelSmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
  ),

  ///Used for the primary text in lists (e.g., ListTile.title).
  ///Montserrat, 14 pt
  titleMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
  ),

  ///For medium emphasis text thats a little smaller than subtitle1.
  ///Montserrat, 14 pt
  titleSmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
  ),
);

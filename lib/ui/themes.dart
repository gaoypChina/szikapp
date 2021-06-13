import 'package:flutter/material.dart';
import '../models/tasks.dart';

const Color szikHippieBlue = Color(0xff59a3b0);
const Color szikHippieBlueLight = Color(0xe359a3b0);
const Color szikTarawera = Color(0xff094757);
const Color szikMonarch = Color(0xff990e35);
const Color szikShiraz = Color(0xffb7113d);
const Color szikAmour = Color(0xfffefbfc);
const Color szikGunSmoke = Color(0xff888989);

const szikColorScheme = ColorScheme(
  primary: szikHippieBlue,
  primaryVariant: szikTarawera,
  secondary: szikMonarch,
  secondaryVariant: szikGunSmoke,
  surface: szikHippieBlueLight,
  background: szikAmour,
  error: Color(0xffc80000),
  onPrimary: szikAmour,
  onSecondary: szikAmour,
  onSurface: szikTarawera,
  onBackground: szikTarawera,
  onError: szikAmour,
  brightness: Brightness.light,
);

///Az egyes [TaskStatus]okhoz rendelt állapotjelző színek.
final Map<TaskStatus, Color> statusColors = {
  TaskStatus.created: szikColorScheme.secondary,
  TaskStatus.sent: szikColorScheme.secondary,
  TaskStatus.in_progress: szikColorScheme.secondary,
  TaskStatus.irresolvable: szikColorScheme.secondaryVariant,
  TaskStatus.refused: szikColorScheme.secondary,
  TaskStatus.awaiting_approval: szikColorScheme.primaryVariant,
  TaskStatus.approved: szikColorScheme.primaryVariant,
};

TextTheme szikTextTheme = TextTheme(
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

ThemeData szikThemeData = ThemeData(
  brightness: Brightness.light,
  //visualDensity: null,
  //primarySwatch: null,
  primaryColor: szikHippieBlue,
  primaryColorBrightness: Brightness.light,
  primaryColorLight: szikHippieBlueLight,
  primaryColorDark: szikTarawera,
  accentColor: szikMonarch,
  accentColorBrightness: Brightness.dark,
  //canvasColor: null,
  //shadowColor: null,
  scaffoldBackgroundColor: szikAmour,
  bottomAppBarColor: szikHippieBlue,
  //cardColor: null,
  dividerColor: szikTarawera,
  //focusColor: null,
  //hoverColor: null,
  //highlightColor: null,
  //splashColor: null,
  //splashFactory: null,
  //selectedRowColor: null,
  //unselectedWidgetColor: null,
  //disabledColor: null,
  buttonColor: szikHippieBlue,
  //buttonTheme: null,
  //toggleButtonsTheme: null,
  //secondaryHeaderColor: null,
  backgroundColor: szikAmour,
  //dialogBackgroundColor: null,
  //indicatorColor: null,
  //hintColor: null,
  errorColor: Color(0xffe80000),
  //toggleableActiveColor: null,
  //fontFamily: null,
  textTheme: szikTextTheme,
  //primaryTextTheme: null,
  //accentTextTheme: null,
  //inputDecorationTheme: null,
  //iconTheme: null,
  //primaryIconTheme: null,
  //accentIconTheme: null,
  //sliderTheme: null,
  //tabBarTheme: null,
  //tooltipTheme: null,
  //cardTheme: null,
  //chipTheme: null,
  //platform: null,
  //materialTapTargetSize: null,
  //applyElevationOverlayColor: null,
  //pageTransitionsTheme: null,
  //appBarTheme: null,
  //scrollbarTheme: null,
  //bottomAppBarTheme: null,
  colorScheme: szikColorScheme,
  //dialogTheme: null,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: szikAmour,
      backgroundColor: szikMonarch,
      elevation: 10,
      splashColor: szikShiraz),
  //navigationRailTheme: null,
  //typography: null,
  //cupertinoOverrideTheme: null,
  //snackBarTheme: null,
  //bottomSheetTheme: null,
  //popupMenuTheme: null,
  //bannerTheme: null,
  //dividerTheme: null,
  //buttonBarTheme: null,
  //bottomNavigationBarTheme: null,
  timePickerTheme: TimePickerThemeData(
    backgroundColor: szikAmour,
    dayPeriodColor: szikHippieBlue,
    dayPeriodTextColor: szikAmour,
    dialBackgroundColor: szikTarawera,
    dialHandColor: szikHippieBlue,
    dialTextColor: szikAmour,
    entryModeIconColor: szikGunSmoke,
    hourMinuteColor: szikHippieBlue,
    hourMinuteTextColor: szikAmour,
    hourMinuteTextStyle: szikTextTheme.bodyText1!
        .copyWith(fontSize: 46, fontStyle: FontStyle.normal),
    hourMinuteShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    helpTextStyle: szikTextTheme.bodyText1!.copyWith(
        fontSize: 14, fontStyle: FontStyle.normal, color: szikGunSmoke),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
  //textButtonTheme: null,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: szikColorScheme.primary,
      onPrimary: szikColorScheme.background,
      shape: StadiumBorder(
        side: BorderSide(color: szikColorScheme.primary),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: szikColorScheme.background,
      backgroundColor: szikColorScheme.background.withOpacity(0.2),
      shape: StadiumBorder(
        side: BorderSide(color: szikColorScheme.background),
      ),
    ),
  ),
  //textSelectionTheme: null,
  //dataTableTheme: null,
  //checkboxTheme: null,
  //radioTheme: null,
  //switchTheme: null,
  //fixTextFieldOutlineLabel: null,
);

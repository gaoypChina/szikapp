import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

TextTheme szikTextTheme = TextTheme(
  ///Used for emphasizing text that would otherwise be bodyText2.
  ///Nunito, Semi-bold, 18 pt
  bodyText1: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),

  ///The default text style for Material.
  ///Nunito, Semi-bold, Italic, 18 pt
  bodyText2: GoogleFonts.nunito(
      fontSize: 18, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),

  ///Used for text on ElevatedButton, TextButton and OutlinedButton.
  ///Montserrat, 18 pt
  button: GoogleFonts.montserrat(fontSize: 18),

  ///Used for auxiliary text associated with images.
  ///Nunito, italic, 14 pt
  caption: GoogleFonts.nunito(fontSize: 14, fontStyle: FontStyle.italic),

  ///Extremely large text.
  ///Montserrat, 18 pt
  headline1: GoogleFonts.montserrat(fontSize: 18),

  ///Very, very large text.
  ///Used for the date in the dialog shown by showDatePicker.
  ///Montserrat, Semi-bold, 18 pt
  headline2: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),

  ///Very large text.
  ///Montserrat, Semi-bold, 18 pt
  headline3: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),

  ///Large text.
  ///Montserrat, Extra-bold, 18 pt
  headline4: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w800),

  ///Used for large text in dialogs
  ///(e.g., the month and year in the dialog shown by showDatePicker).
  ///Nunito, Black, 18 pt
  headline5: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900),

  ///Used for the primary text in app bars and dialogs
  ///(e.g., AppBar.title and AlertDialog.title).
  ///Montserrat, 18 pt
  headline6: GoogleFonts.montserrat(
    fontSize: 18,
  ),

  ///The smallest style. [...]
  ///Montserrat, 14 pt
  overline: GoogleFonts.montserrat(fontSize: 14),

  ///Used for the primary text in lists (e.g., ListTile.title).
  ///Montserrat, 14 pt
  subtitle1: GoogleFonts.montserrat(fontSize: 14),

  ///For medium emphasis text thats a little smaller than subtitle1.
  ///Montserrat, 14 pt
  subtitle2: GoogleFonts.montserrat(fontSize: 14),
);

ThemeData ourThemeData = ThemeData(
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
  //elevatedButtonTheme: null,
  //outlinedButtonTheme: null,
  //textSelectionTheme: null,
  //dataTableTheme: null,
  //checkboxTheme: null,
  //radioTheme: null,
  //switchTheme: null,
  //fixTextFieldOutlineLabel: null,
);

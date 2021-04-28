import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData ourThemeData = ThemeData(
  brightness: Brightness.light,
  //visualDensity: null,
  //primarySwatch: null,
  primaryColor: Color(0xff59a3b0),
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Color(0xe359a3b0),
  primaryColorDark: Color(0xff094757),
  accentColor: Color(0xFF990e35),
  accentColorBrightness: Brightness.dark,
  //canvasColor: null,
  //shadowColor: null,
  scaffoldBackgroundColor: Color(0xfffefbfc),
  bottomAppBarColor: Color(0xff59a3b0),
  //cardColor: null,
  dividerColor: Color(0xff094757),
  //focusColor: null,
  //hoverColor: null,
  //highlightColor: null,
  //splashColor: null,
  //splashFactory: null,
  //selectedRowColor: null,
  //unselectedWidgetColor: null,
  //disabledColor: null,
  buttonColor: Color(0xff59a3b0),
  //buttonTheme: null,
  //toggleButtonsTheme: null,
  //secondaryHeaderColor: null,
  backgroundColor: Color(0xfffefbfc),
  //dialogBackgroundColor: null,
  //indicatorColor: null,
  //hintColor: null,
  errorColor: Color(0xffe80000),
  //toggleableActiveColor: null,
  //fontFamily: null,
  textTheme: TextTheme(
    ///Used for emphasizing text that would otherwise be bodyText2.
    bodyText1: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),

    ///The default text style for Material.
    bodyText2: GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),

    ///Used for text on ElevatedButton, TextButton and OutlinedButton.
    button: GoogleFonts.montserrat(fontSize: 18),

    ///Used for auxiliary text associated with images.
    caption: GoogleFonts.nunito(fontSize: 14, fontStyle: FontStyle.italic),

    ///Extremely large text.
    headline1: GoogleFonts.montserrat(fontSize: 18),

    ///Very, very large text.
    ///Used for the date in the dialog shown by showDatePicker.
    headline2:
        GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),

    ///Very large text.
    headline3:
        GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),

    ///Large text.
    headline4:
        GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w800),

    ///Used for large text in dialogs
    ///(e.g., the month and year in the dialog shown by showDatePicker).
    headline5: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900),

    ///Used for the primary text in app bars and dialogs
    ///(e.g., AppBar.title and AlertDialog.title).
    headline6: GoogleFonts.montserrat(
      fontSize: 18,
    ),

    ///The smallest style. [...]
    overline: GoogleFonts.montserrat(fontSize: 14),

    ///Used for the primary text in lists (e.g., ListTile.title).
    subtitle1: GoogleFonts.montserrat(fontSize: 14),

    ///For medium emphasis text thats a little smaller than subtitle1.
    subtitle2: GoogleFonts.montserrat(fontSize: 14),
  ),
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
  colorScheme: ColorScheme(
    primary: Color(0xff59a3b0),
    primaryVariant: Color(0xff094757),
    secondary: Color(0xFF990e35),
    secondaryVariant: Color(0xff990e35),
    surface: Color(0xe359a3b0),
    background: Color(0xfffefbfc),
    error: Color(0xffc80000),
    onPrimary: Color(0xfffefbfc),
    onSecondary: Color(0xfffefbfc),
    onSurface: Color(0xff094757),
    onBackground: Color(0xff094757),
    onError: Color(0xfffefbfc),
    brightness: Brightness.light,
  ),

  //dialogTheme: null,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Color(0xfffefbfc),
      backgroundColor: Color(0xff990e35),
      elevation: 10,
      splashColor: Color(0xffb7113d)),
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
  //timePickerTheme: null,
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

import 'package:flutter/material.dart';
import 'themes.dart';

const szikLightColorScheme = ColorScheme(
  primary: szikHippieBlue,
  primaryContainer: szikTarawera,
  secondary: szikMonarch,
  secondaryContainer: szikGunSmoke,
  surface: szikLavenderBlush,
  background: szikAmour,
  error: Color(0xffc80000),
  onPrimary: szikAmour,
  onSecondary: szikAmour,
  onSurface: szikTarawera,
  onBackground: szikTarawera,
  onError: szikAmour,
  brightness: Brightness.light,
);

ThemeData szikLightThemeData = ThemeData(
  brightness: Brightness.light,
  //visualDensity: null,
  //primarySwatch: null,
  primaryColor: szikHippieBlue,
  primaryColorLight: null,
  primaryColorDark: szikTarawera,
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
  //buttonTheme: null,
  //toggleButtonsTheme: null,
  //secondaryHeaderColor: null,
  //backgroundColor: szikAmour,
  //dialogBackgroundColor: null,
  //indicatorColor: null,
  //hintColor: null,
  errorColor: const Color(0xffe80000),
  //toggleableActiveColor: null,
  //fontFamily: null,
  textTheme: szikTextTheme,
  //primaryTextTheme: null,
  //inputDecorationTheme: null,
  //iconTheme: null,
  //primaryIconTheme: null,
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
  colorScheme: szikLightColorScheme,
  //dialogTheme: null,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: szikAmour,
      backgroundColor: szikMonarch,
      elevation: 0,
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
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kBorderRadiusSmall),
      ),
    ),
    helpTextStyle: szikTextTheme.bodyText1!.copyWith(
        fontSize: 14, fontStyle: FontStyle.normal, color: szikGunSmoke),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kBorderRadiusSmall),
      ),
    ),
  ),
  //textButtonTheme: null,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: szikLightColorScheme.primary,
      foregroundColor: szikLightColorScheme.background,
      shape: StadiumBorder(
        side: BorderSide(color: szikLightColorScheme.primary),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: szikLightColorScheme.background,
      backgroundColor: szikLightColorScheme.background.withOpacity(0.2),
      shape: StadiumBorder(
        side: BorderSide(color: szikLightColorScheme.background),
      ),
    ),
  ),
  //textSelectionTheme: null,
  //dataTableTheme: null,
  //checkboxTheme: null,
  //radioTheme: null,
  //switchTheme: null,
);

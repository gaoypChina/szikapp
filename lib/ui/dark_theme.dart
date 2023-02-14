import 'package:flutter/material.dart';
import 'themes.dart';

const szikDarkColorScheme = ColorScheme(
  primary: szikHippieBlue,
  primaryContainer: szikMalibu,
  secondary: szikSilver,
  secondaryContainer: szikGunSmoke,
  surface: szikEden,
  background: szikDaintree,
  error: Color(0xffc80000),
  onPrimary: szikDaintree,
  onSecondary: szikDaintree,
  onSurface: szikMalibu,
  onBackground: szikMalibu,
  onError: szikDaintree,
  brightness: Brightness.dark,
);

ThemeData szikDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  //visualDensity: null,
  //primarySwatch: null,
  primaryColor: szikHippieBlue,
  primaryColorLight: null,
  primaryColorDark: szikMalibu,
  //canvasColor: null,
  //shadowColor: null,
  scaffoldBackgroundColor: szikDaintree,
  //cardColor: null,
  dividerColor: szikMalibu,
  //toggleableActiveColor: null,
  //fontFamily: null,
  textTheme: szikTextTheme,
  //dialogTheme: null,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: szikEden,
      backgroundColor: szikSilver,
      elevation: 0,
      splashColor: szikSilverChalice),
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
    backgroundColor: szikEden,
    dayPeriodColor: szikHippieBlue,
    dayPeriodTextColor: szikEden,
    dialBackgroundColor: szikMalibu,
    dialHandColor: szikHippieBlue,
    dialTextColor: szikEden,
    entryModeIconColor: szikGunSmoke,
    hourMinuteColor: szikHippieBlue,
    hourMinuteTextColor: szikEden,
    hourMinuteTextStyle: szikTextTheme.bodyLarge!
        .copyWith(fontSize: 46, fontStyle: FontStyle.normal),
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kBorderRadiusSmall),
      ),
    ),
    helpTextStyle: szikTextTheme.bodyLarge!.copyWith(
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
      backgroundColor: szikDarkColorScheme.primary,
      foregroundColor: szikDarkColorScheme.background,
      shape: StadiumBorder(
        side: BorderSide(color: szikDarkColorScheme.primary),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: szikDarkColorScheme.background,
      backgroundColor: szikDarkColorScheme.background.withOpacity(0.2),
      shape: StadiumBorder(
        side: BorderSide(color: szikDarkColorScheme.background),
      ),
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: szikHippieBlue),
  colorScheme: szikDarkColorScheme
      .copyWith(background: szikEden)
      .copyWith(error: const Color(0xffe80000)),
  //textSelectionTheme: null,
  //dataTableTheme: null,
  //checkboxTheme: null,
  //radioTheme: null,
  //switchTheme: null,
);

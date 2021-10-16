import 'package:flutter/material.dart';
import '../models/tasks.dart';
import 'themes.dart';

///Az egyes [TaskStatus]okhoz rendelt állapotjelző színek dark módban.
final Map<TaskStatus, Color> taskStatusDarkColors = {
  TaskStatus.created: szikDarkColorScheme.secondary,
  TaskStatus.sent: szikDarkColorScheme.secondary,
  TaskStatus.in_progress: szikDarkColorScheme.secondary,
  TaskStatus.irresolvable: szikDarkColorScheme.secondaryVariant,
  TaskStatus.refused: szikDarkColorScheme.secondary,
  TaskStatus.awaiting_approval: szikDarkColorScheme.primaryVariant,
  TaskStatus.approved: szikDarkColorScheme.primaryVariant,
};

const szikDarkColorScheme = ColorScheme(
  primary: szikHippieBlue,
  primaryVariant: szikMalibu,
  secondary: szikSilver,
  secondaryVariant: szikGunSmoke,
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
  primaryColorBrightness: Brightness.light,
  primaryColorLight: null,
  primaryColorDark: szikMalibu,
  //canvasColor: null,
  //shadowColor: null,
  scaffoldBackgroundColor: szikDaintree,
  bottomAppBarColor: szikHippieBlue,
  //cardColor: null,
  dividerColor: szikMalibu,
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
  backgroundColor: szikEden,
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
  colorScheme: szikDarkColorScheme,
  //dialogTheme: null,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: szikEden,
      backgroundColor: szikSilver,
      elevation: 10,
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
    hourMinuteTextStyle: szikTextTheme.bodyText1!
        .copyWith(fontSize: 46, fontStyle: FontStyle.normal),
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    helpTextStyle: szikTextTheme.bodyText1!.copyWith(
        fontSize: 14, fontStyle: FontStyle.normal, color: szikGunSmoke),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
  //textButtonTheme: null,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: szikDarkColorScheme.primary,
      onPrimary: szikDarkColorScheme.background,
      shape: StadiumBorder(
        side: BorderSide(color: szikDarkColorScheme.primary),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: szikDarkColorScheme.background,
      backgroundColor: szikDarkColorScheme.background.withOpacity(0.2),
      shape: StadiumBorder(
        side: BorderSide(color: szikDarkColorScheme.background),
      ),
    ),
  ),
  //textSelectionTheme: null,
  //dataTableTheme: null,
  //checkboxTheme: null,
  //radioTheme: null,
  //switchTheme: null,
);

import 'package:flutter/material.dart';

enum ApiKeys {
  openWeatherMap,
}

enum AppTheme { light, dark }

enum Status { initialized, ongoing, completed }

enum WeatherTypes { sunny, cloudy, rainy, windy, stormy }

enum Difficulty { Easy, Medium, Hard }

enum WeatherKeyState { add, update, saveAdded, saveUpdated }

const Color kprimaryColor = Color(0xffAFFC41);

// Dark Theme Color Palette
const Color ksecondaryColor = Color(0xffB8E9C4);
const Color kprimaryBackgroundColor = Color(0xff16171c);
const Color ksecondaryBackgroundColor = Color(0xff1c1f26);
const Color kprimaryTextColor = Colors.white;
const Color ksecondaryTextColor = Colors.black;
const Color kprimaryDisabledTextColor = Color(0xff595f6b);

// Light Theme Color Palette
const Color kLightSecondaryColor = Color(0xff6FBC00);
const Color kLightPrimaryBackgroundColor = Color(0xffFFFFFF);
const Color kLightSecondaryBackgroundColor = Color(0xffF9F9F9);
const Color kLightPrimaryTextColor = Color(0xff444444);
const Color kLightSecondaryTextColor = Color(0xff7C7C7C);
const Color kLightPrimaryDisabledTextColor = Color(0xffACACAB);

// Dark ThemeData
ThemeData kThemeData = ThemeData(
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: ksecondaryColor)),
  iconTheme: const IconThemeData(
    color: kprimaryTextColor,
  ),
  fontFamily: 'poppins',
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(kprimaryTextColor),
    fillColor: MaterialStateProperty.all(kprimaryBackgroundColor),
  ),
  textTheme: const TextTheme(
      titleSmall: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      titleMedium: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      titleLarge: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      bodySmall: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      bodyMedium: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      bodyLarge: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      displaySmall: TextStyle(
          fontSize: 16,
          color: kprimaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15),
      displayLarge: TextStyle(
          fontSize: 28,
          color: kprimaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15),
      displayMedium: TextStyle(
          fontSize: 23,
          color: kprimaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black, backgroundColor: kprimaryColor),
  primaryColor: kprimaryColor,
  scaffoldBackgroundColor: kprimaryBackgroundColor,
  appBarTheme: const AppBarTheme(backgroundColor: kprimaryBackgroundColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ksecondaryColor,
      background: kprimaryBackgroundColor,
      onPrimaryContainer: ksecondaryBackgroundColor),
  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: kprimaryTextColor.withOpacity(0.5)),
      labelStyle: const TextStyle(color: kprimaryTextColor),
      focusColor: kprimaryTextColor,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kprimaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kprimaryColor),
        borderRadius: BorderRadius.circular(12),
      )),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kprimaryColor,
    selectionColor: kprimaryColor,
    selectionHandleColor: ksecondaryColor,
  ),
  sliderTheme: SliderThemeData(
      thumbColor: kprimaryColor,
      activeTrackColor: kprimaryColor,
      inactiveTrackColor: kprimaryTextColor.withOpacity(0.3)),
);

// Light ThemeData
ThemeData kLightThemeData = ThemeData(
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kprimaryColor)),
  iconTheme: const IconThemeData(
    color: kLightPrimaryTextColor,
  ),
  fontFamily: 'poppins',
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(kprimaryTextColor),
    fillColor: MaterialStateProperty.all(kLightPrimaryBackgroundColor),
  ),
  textTheme: const TextTheme(
      titleSmall: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
      titleMedium:
          TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
      titleLarge: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
      bodySmall: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
      bodyMedium: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
      bodyLarge: TextStyle(color: kLightPrimaryTextColor, letterSpacing: 0.15),
      displaySmall: TextStyle(
          fontSize: 16,
          color: kLightPrimaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15),
      displayLarge: TextStyle(
          fontSize: 28,
          color: kLightPrimaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15),
      displayMedium: TextStyle(
          fontSize: 23,
          color: kLightPrimaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black, backgroundColor: kprimaryColor),
  primaryColor: kprimaryColor,
  scaffoldBackgroundColor: kLightPrimaryBackgroundColor,
  appBarTheme: const AppBarTheme(backgroundColor: kLightPrimaryBackgroundColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: kLightSecondaryColor,
      background: kLightPrimaryBackgroundColor,
      onPrimaryContainer: kLightSecondaryBackgroundColor),
  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: kLightPrimaryTextColor.withOpacity(0.5)),
      labelStyle: const TextStyle(color: kLightPrimaryTextColor),
      focusColor: kLightPrimaryTextColor,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kprimaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kprimaryColor),
        borderRadius: BorderRadius.circular(12),
      )),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kprimaryColor,
    selectionColor: kprimaryColor,
    selectionHandleColor: kLightSecondaryColor,
  ),
  sliderTheme: SliderThemeData(
      thumbColor: kprimaryColor,
      activeTrackColor: kprimaryColor,
      inactiveTrackColor: kLightPrimaryTextColor.withOpacity(0.3)),
);

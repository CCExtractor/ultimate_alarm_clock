import 'package:flutter/material.dart';

enum ApiKeys {
  openWeatherMap,
}

const Color kprimaryColor = Color(0xffAFFC41);
const Color ksecondaryColor = Color(0xffB8E9C4);
const Color kprimaryBackgroundColor = Color(0xff16171c);
const Color ksecondaryBackgroundColor = Color(0xff1c1f26);
const Color kprimaryTextColor = Colors.white;
const Color ksecondaryTextColor = Colors.black;

const Color kprimaryDisabledTextColor = Color(0xff595f6b);
ThemeData kThemeData = ThemeData(
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: ksecondaryColor)),
  fontFamily: 'poppins',
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(kprimaryTextColor),
    fillColor: MaterialStateProperty.all(kprimaryColor.withOpacity(0.8)),
  ),
  textTheme: const TextTheme(
      titleSmall: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
      titleMedium: TextStyle(color: kprimaryTextColor, letterSpacing: 0.15),
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
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.black, backgroundColor: kprimaryColor),
  primaryColor: kprimaryColor,
  scaffoldBackgroundColor: kprimaryBackgroundColor,
  appBarTheme: const AppBarTheme(backgroundColor: kprimaryBackgroundColor),
  colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ksecondaryColor,
      background: kprimaryBackgroundColor,
      onPrimaryContainer: ksecondaryBackgroundColor),
  inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: kprimaryTextColor),
      labelStyle: TextStyle(color: kprimaryTextColor),
      focusColor: kprimaryTextColor,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kprimaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kprimaryColor),
        borderRadius: BorderRadius.circular(12),
      )),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kprimaryColor,
    selectionColor: kprimaryColor,
    selectionHandleColor: ksecondaryColor,
  ),
);

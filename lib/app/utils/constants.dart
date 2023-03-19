import 'package:flutter/material.dart';

Color kprimaryColor = Color(0xffAFFC41);
Color ksecondaryColor = Color(0xffB8E9C4);
Color kprimaryBackgroundColor = Color(0xff16171c);
Color ksecondaryBackgroundColor = Color(0xff1c1f26);

ThemeData kThemeData = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.black, backgroundColor: kprimaryColor),
    primaryColor: kprimaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: ksecondaryColor,
        background: kprimaryBackgroundColor,
        onPrimaryContainer: ksecondaryBackgroundColor));

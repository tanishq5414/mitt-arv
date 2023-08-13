import 'package:flutter/material.dart';
import 'package:mittarv/theme/pallete.dart';
import 'package:mittarv/theme/transition.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: Pallete.whiteColor,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 28,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: ExtendedBlackScreenTransitionsBuilder(),
      TargetPlatform.iOS: const ZoomPageTransitionsBuilder(),
    }),
    splashFactory: NoSplash.splashFactory,
    fontFamily: 'HevleticaNowDisplay',
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.greenColor,
    ),
  );
}

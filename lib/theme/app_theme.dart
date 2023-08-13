import 'package:flutter/material.dart';
import 'package:mittarv/theme/pallete.dart';
import 'package:mittarv/theme/transition.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: Pallete.whiteColor,
    textTheme: const TextTheme(
      
    ),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: ExtendedBlackScreenTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    }),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    primaryTextTheme: const TextTheme(
      headline6: TextStyle(
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

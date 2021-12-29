import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

ThemeData getDarkTheme(Color accentColor) {
  var bgColor = Color(0xff1a1e2b);
  var cardColor = Color(0x20000000);
  var bottomNavbarColor = Color(0xff1f1f1f);

  return ThemeData.dark().copyWith(
    cardColor: cardColor,
    scaffoldBackgroundColor: bgColor,
    dialogBackgroundColor: bgColor,
    accentColor: accentColor,
    toggleableActiveColor: accentColor,
    appBarTheme: AppBarTheme(
      color: bgColor,
      elevation: 0.0,
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: ButtonStyleButton.allOrNull<Color>(
          accentColor,
        ),
        overlayColor: ButtonStyleButton.allOrNull<Color>(
          accentColor.withOpacity(0.2),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: accentColor)),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bgColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: bottomNavbarColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: MaterialStateProperty.all(4),
      showTrackOnHover: true,
      trackColor: MaterialStateProperty.all(cardColor),
      trackBorderColor: MaterialStateProperty.all(cardColor),
      isAlwaysShown: Platform.isLinux || Platform.isWindows || Platform.isMacOS,
    ),
  );
}

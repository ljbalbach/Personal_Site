import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkTheme = false;

  ThemeData get currentTheme {
    return _isDarkTheme ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.rock3d(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.caveatBrush(
      fontSize: 40,
    ),
    bodyMedium: GoogleFonts.caveatBrush(
      fontSize: 23,
    ),
    displaySmall: GoogleFonts.caveatBrush(
      fontSize: 21,
    ),
  );

  ThemeData get lightTheme => ThemeData(
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.black,
    useMaterial3: true,
    textTheme: textTheme,
  );

  ThemeData get darkTheme => ThemeData(
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    useMaterial3: true,
    textTheme: textTheme,
  );
}
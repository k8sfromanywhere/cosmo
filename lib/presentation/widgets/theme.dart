import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get themeSetUp {
    return ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontStyle: FontStyle.normal,
        ),
      ),
      scaffoldBackgroundColor: Colors.transparent,
    );
  }
}

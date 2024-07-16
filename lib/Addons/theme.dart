import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xFF03AED2),
      secondary: const Color(0xFFF6F5F2),
      surface: const Color(0xFF03AED2),
      background: Colors.white,
      onBackground: const Color(0xFF000000), // Changed to ensure readability
    ),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Color(0xFF3A98B9)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 232, 228, 228),
      iconTheme: IconThemeData(color: Color(0xFF3A98B9)),
      titleTextStyle: TextStyle(color: Color(0xFF3A98B9), fontSize: 20),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Color(0xFF3A98B9), fontSize: 22),
      titleMedium: TextStyle(color: Color(0xFF3A98B9), fontSize: 18),
      titleSmall: TextStyle(color: Color(0xFF3A98B9), fontSize: 16),
      bodyLarge: TextStyle(color: Color(0xFF000000), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFF000000), fontSize: 14),
      bodySmall: TextStyle(color: Color(0xFF000000), fontSize: 12),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFF76ABAE),
      secondary: const Color(0xFF222831),
      surface: Colors.black87,
      background: Colors.black87,
      onBackground: Colors.white,
    ),
    scaffoldBackgroundColor: Color.fromARGB(198, 12, 44, 56),
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(198, 12, 44, 56), // Colors.black87,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontSize: 22),
      titleMedium: TextStyle(color: Colors.white, fontSize: 18),
      titleSmall: TextStyle(color: Colors.white, fontSize: 16),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}

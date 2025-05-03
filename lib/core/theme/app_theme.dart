import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color(0xFFFF6B6B),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFFF6B6B),
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFFFF6B6B),
      foregroundColor: Colors.black,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    iconTheme: IconThemeData(color: Color(0xFFFF6B6B)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF6B6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFFF8F8F8),
      selectedItemColor: const Color(0xFFFF6B6B),
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.poppins(),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      elevation: 12,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}

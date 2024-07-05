import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme getDefaultColorScheme() {
    return const ColorScheme(

      // Main colors
      primary: Color(0xFFFFFFFF),
      secondary: Color(0xFF820EEF),

      // Background color
      surface: Color(0xFF121212),

      // Error stuff
      error: Color(0xFFF66121),

      // Inverse of primary
      onPrimary: Colors.black,

      // Inverse of secondary
      onSecondary: Colors.white,

      // Inverse of surface
      onSurface: Colors.white,

      // Inverse of error
      onError: Colors.white,


      brightness: Brightness.light, // Specify the brightness
    );
  }
}

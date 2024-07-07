import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme getDefaultColorScheme() {
    return const ColorScheme(

      // Main colors
      primary: Color(0xFFFFFFFF),
      secondary:   Color(0xFF0E7CC1),

      // Background color
      surface: Color.fromRGBO(12, 12, 12, 1),

      // Error stuff
      error: Color(0xFFF66121),

      // Inverse of primary
      onPrimary: Colors.black,

      // Inverse of secondary
      onSecondary: Colors.white,

      // Inverse of surface
      onSurface:   Color(0xFF0E7CC1),

      // Inverse of error
      onError: Colors.white,


      brightness: Brightness.light, // Specify the brightness
    );
  }
}

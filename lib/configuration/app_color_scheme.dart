import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme getDefaultColorScheme() {
    return const ColorScheme(
      primary: Color(0xFF000000),
      // Customize your primary color
      secondary: Color(0xFF0320DA),
      // Customize your secondary color
      surface: Color(0xFFE0E0E0),
      // Customize your surface color
      background: Color(0xFF202020),
      // Customize your background color
      error: Color(0xFFB00020),
      // Customize your error color
      onPrimary: Colors.white,
      // Customize your onPrimary color
      onSecondary: Colors.black,
      // Customize your onSecondary color
      onSurface: Colors.black,
      // Customize your onSurface color
      onBackground: Colors.black,
      // Customize your onBackground color
      onError: Colors.white,
      // Customize your onError color
      brightness: Brightness.light, // Specify the brightness
    );
  }
}

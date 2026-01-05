import 'package:flutter/material.dart';

class TracelyTheme {
  // Colors from your Figma file
  static const Color primary700 = Color(0xFF152636);
  static const Color primary900 = Color(0xFF0C161E);
  static const Color primary800 = Color(0xFF11202A);
  static const Color primary600 = Color(0xFF193044);
  static const Color primary500 = Color(0xFF1D3A51);
  static const Color primary100 = Color(0xFFE4EBEF);

  static const Color secondary500 = Color(0xFF2CC5A7);
  static const Color secondary700 = Color(0xFF1F8E78);
  static const Color secondary300 = Color(0xFF9EE7D9);
  static const Color secondary200 = Color(0xFFE2E8F0);

  static const Color neutral800 = Color(0xFF1A1A1A);
  static const Color neutral700 = Color(0xFF2E2E2E);
  static const Color neutral600 = Color(0xFF333333);
  static const Color neutral300 = Color(0xFFD6D6D6);
  static const Color neutral200 = Color(0xFF858585);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral0 = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF0CC25F);
  static const Color warning = Color(0xFFF4A62A);
  static const Color error = Color(0xFFE54848);
  static const Color links = Color(0xFF0286FF);

  // THEME
  static final ThemeData theme = ThemeData(
    fontFamily: "PlusJakartaSans",

    // Basic color assignments only — nothing added
    primaryColor: primary500,
    scaffoldBackgroundColor: neutral100,
    canvasColor: neutral0,
    dividerColor: neutral300,
    hintColor: neutral600,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary500,
      onPrimary: neutral0,
      secondary: secondary500,
      onSecondary: neutral0,
      error: error,
      onError: neutral0,
      background: neutral100,
      onBackground: neutral800,
      surface: neutral0,
      onSurface: neutral800,
    ),
  );
}

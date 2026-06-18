import 'package:flutter/material.dart';
import 'sky_palette.dart';
import 'sky_type.dart';

class SkyTheme {
  static ThemeData build() {
    final scheme = ColorScheme.fromSeed(
      seedColor: SkyPalette.sky,
      primary: SkyPalette.skyDeep,
      secondary: SkyPalette.sunset,
      surface: SkyPalette.card,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: SkyPalette.paper,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: SkyPalette.ink,
      ),
      cardTheme: CardThemeData(
        color: SkyPalette.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SkyPalette.hairline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SkyPalette.card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: SkyType.body(color: SkyPalette.inkFaint),
        border: _inputBorder(SkyPalette.hairline),
        enabledBorder: _inputBorder(SkyPalette.hairline),
        focusedBorder: _inputBorder(SkyPalette.sky),
        errorBorder: _inputBorder(SkyPalette.cancelled),
        focusedErrorBorder: _inputBorder(SkyPalette.cancelled),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: SkyPalette.ink,
        contentTextStyle: SkyType.bodyStrong(color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: 1.4),
      );
}

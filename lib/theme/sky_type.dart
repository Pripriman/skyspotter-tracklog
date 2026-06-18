import 'package:flutter/material.dart';
import 'sky_palette.dart';

class SkyType {
  static TextStyle _t(
    FontWeight weight,
    double size, {
    double? height,
    double? spacing,
    Color? color,
  }) {
    return TextStyle(
      fontWeight: weight,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      color: color ?? SkyPalette.ink,
    );
  }

  static TextStyle display({Color? color}) =>
      _t(FontWeight.w800, 30, height: 1.08, spacing: -0.6, color: color);
  static TextStyle title({Color? color}) =>
      _t(FontWeight.w700, 22, height: 1.15, spacing: -0.3, color: color);
  static TextStyle heading({Color? color}) =>
      _t(FontWeight.w700, 17, height: 1.2, color: color);
  static TextStyle body({Color? color}) =>
      _t(FontWeight.w400, 15, height: 1.42, color: color ?? SkyPalette.inkSoft);
  static TextStyle bodyStrong({Color? color}) =>
      _t(FontWeight.w600, 15, height: 1.42, color: color);
  static TextStyle label({Color? color}) =>
      _t(FontWeight.w700, 12.5, spacing: 0.8, color: color);
  static TextStyle caption({Color? color}) =>
      _t(FontWeight.w600, 12, spacing: 0.3, color: color ?? SkyPalette.inkFaint);
  static TextStyle mono(double size, {Color? color, FontWeight? weight}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: weight ?? FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: 0.5,
        color: color ?? SkyPalette.ink,
      );
  static TextStyle ticket(double size, {Color? color, double spacing = 3.0}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: spacing,
        color: color ?? SkyPalette.ink,
      );
}

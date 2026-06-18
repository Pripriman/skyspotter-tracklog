import 'package:flutter/material.dart';

class SkyPalette {
  static const Color paper = Color(0xFFF4F8FD);
  static const Color paperDeep = Color(0xFFE4EEF8);
  static const Color hairline = Color(0xFFD2E0EE);
  static const Color card = Color(0xFFFFFFFF);

  static const Color ink = Color(0xFF14233A);
  static const Color inkSoft = Color(0xFF52647C);
  static const Color inkFaint = Color(0xFF93A6BC);

  static const Color sky = Color(0xFF2E9BE6);
  static const Color skyDeep = Color(0xFF1565C0);
  static const Color skyWash = Color(0xFFDCEDFB);

  static const Color sunset = Color(0xFFFF7A59);
  static const Color sunsetDeep = Color(0xFFE85C3C);
  static const Color sunsetWash = Color(0xFFFFE3DA);

  static const Color runway = Color(0xFFF2B544);
  static const Color runwayWash = Color(0xFFFCEFD2);

  static const Color airborne = Color(0xFF2FB57C);
  static const Color delayed = Color(0xFFE6A23C);
  static const Color cancelled = Color(0xFFD9554C);

  static const LinearGradient skyWashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFCFE7FB), Color(0xFFF7FBFF)],
  );
}

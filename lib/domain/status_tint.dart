import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';

Color statusTint(String status) {
  switch (status) {
    case 'On time':
    case 'Landed':
      return SkyPalette.airborne;
    case 'In air':
    case 'Boarding':
      return SkyPalette.skyDeep;
    case 'Delayed':
      return SkyPalette.delayed;
    case 'Cancelled':
      return SkyPalette.cancelled;
    default:
      return SkyPalette.inkSoft;
  }
}

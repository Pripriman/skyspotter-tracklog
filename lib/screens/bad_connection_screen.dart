import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';
import '../theme/sky_type.dart';
import '../widgets/lift_button.dart';

class BadConnectionScreen extends StatelessWidget {
  final VoidCallback onRetry;
  const BadConnectionScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SkyPalette.skyWashGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: SkyPalette.runwayWash,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                      Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
                      size: 38,
                      color: SkyPalette.runway),
                ),
                const SizedBox(height: 24),
                Text('No signal on this frequency',
                    style: SkyType.title(), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(
                  'We could not reach the live board. Check your network and tune in again.',
                  style: SkyType.body(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                LiftButton(
                  label: 'Retry',
                  icon: Icons.refresh_rounded,
                  expand: false,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

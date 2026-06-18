import 'package:flutter/material.dart';

import 'domain/spot_repository.dart';
import 'screens/boot_gate_screen.dart';
import 'state/logbook_scope.dart';
import 'theme/sky_theme.dart';

class TrackLogApp extends StatelessWidget {
  final SpotRepository logbook;
  const TrackLogApp({super.key, required this.logbook});

  @override
  Widget build(BuildContext context) {
    return LogbookScope(
      logbook: logbook,
      child: MaterialApp(
        title: 'Aviator Flight Tracker',
        debugShowCheckedModeBanner: false,
        theme: SkyTheme.build(),
        home: const BootGateScreen(),
      ),
    );
  }
}

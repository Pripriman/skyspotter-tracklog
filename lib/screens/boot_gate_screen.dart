import 'package:flutter/material.dart';

import '../runtime/gate_router.dart';
import '../runtime/trace_beacon.dart';
import '../theme/sky_palette.dart';
import '../theme/sky_type.dart';
import '../widgets/aircraft_silhouette.dart';
import 'bad_connection_screen.dart';
import 'content/spotter_deck_view.dart';
import 'native_root.dart';

class BootGateScreen extends StatefulWidget {
  const BootGateScreen({super.key});

  @override
  State<BootGateScreen> createState() => _BootGateScreenState();
}

class _BootGateScreenState extends State<BootGateScreen>
    with SingleTickerProviderStateMixin {
  late Future<GateResult> _future;
  late final AnimationController _drift;

  @override
  void initState() {
    super.initState();
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _future = BoardGate.resolve();
  }

  void _retry() {
    setState(() {
      _future = BoardGate.resolve();
    });
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GateResult>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return _splash();
        }
        final result = snap.data ?? const GateResult(GateOutcome.native);
        switch (result.outcome) {
          case GateOutcome.badConnection:
            return BadConnectionScreen(onRetry: _retry);
          case GateOutcome.content:
            TraceBeacon.contentOpen();
            return SpotterDeckView(endpoint: result.endpoint!);
          case GateOutcome.native:
            return const NativeRoot();
        }
      },
    );
  }

  Widget _splash() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SkyPalette.skyWashGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _drift,
                builder: (context, child) {
                  final dx = (_drift.value - 0.5) * 28;
                  final dy = -(_drift.value - 0.5).abs() * 14;
                  return Transform.translate(
                    offset: Offset(dx, dy),
                    child: child,
                  );
                },
                child: const AircraftSilhouette(
                  size: 92,
                  heading: 45,
                  color: SkyPalette.skyDeep,
                ),
              ),
              const SizedBox(height: 28),
              Text('Scanning the skies…',
                  style: SkyType.heading(color: SkyPalette.skyDeep)),
            ],
          ),
        ),
      ),
    );
  }
}

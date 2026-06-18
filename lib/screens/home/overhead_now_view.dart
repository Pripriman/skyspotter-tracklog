import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../domain/demo_board.dart';
import '../../domain/status_tint.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/aircraft_silhouette.dart';
import '../../widgets/lift_button.dart';
import '../../widgets/sky_card.dart';

class OverheadNowView extends StatefulWidget {
  const OverheadNowView({super.key});

  @override
  State<OverheadNowView> createState() => _OverheadNowViewState();
}

class _OverheadNowViewState extends State<OverheadNowView> {
  List<FlightLeg> _flights = const [];
  int _bearing = 0;
  bool _scanned = false;

  void _scan() {
    final seed = DateTime.now().millisecondsSinceEpoch ~/ 60000;
    setState(() {
      _flights = DemoBoard.overhead(seed);
      _bearing = math.Random(seed).nextInt(360);
      _scanned = true;
    });
  }

  String _compass(int deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((deg + 22) ~/ 45) % 8];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      children: [
        SkyCard(
          color: SkyPalette.skyWash,
          border: Border.all(color: SkyPalette.sky),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.my_location_rounded,
                      color: SkyPalette.skyDeep),
                  const SizedBox(width: 8),
                  Text('What is overhead', style: SkyType.heading()),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _scanned
                    ? 'Facing ${_compass(_bearing)} ($_bearing°). These are the flights matched to your heading.'
                    : 'Point your phone toward a passing aircraft, then scan to match it to nearby flights.',
                style: SkyType.body(color: SkyPalette.ink),
              ),
              const SizedBox(height: 14),
              LiftButton(
                label: _scanned ? 'Scan again' : 'Scan the sky',
                icon: Icons.radar_rounded,
                onPressed: _scan,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (!_scanned)
          SkyCard(
            child: Row(
              children: [
                const Icon(Icons.flight_takeoff_rounded,
                    color: SkyPalette.inkFaint),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No scan yet. Tap “Scan the sky” to reveal aircraft in your direction.',
                    style: SkyType.body(),
                  ),
                ),
              ],
            ),
          )
        else
          ..._flights.asMap().entries.map((e) => _overheadTile(e.key, e.value)),
        if (_scanned) ...[
          const SizedBox(height: 12),
          Text(
            'Positions are approximate reference data and should not be used for navigation.',
            style: SkyType.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _overheadTile(int index, FlightLeg leg) {
    final relHeading = (_bearing + index * 37) % 360;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SkyPalette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SkyPalette.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: SkyPalette.skyWash,
              shape: BoxShape.circle,
            ),
            child: AircraftSilhouette(
              size: 30,
              heading: relHeading.toDouble(),
              color: SkyPalette.skyDeep,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(leg.flightNumber, style: SkyType.bodyStrong()),
                    const SizedBox(width: 8),
                    Text(leg.aircraft.label,
                        style: SkyType.caption(color: SkyPalette.skyDeep)),
                  ],
                ),
                const SizedBox(height: 3),
                Text('${leg.origin.code} → ${leg.destination.code} · ${leg.airline.name}',
                    style: SkyType.caption()),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${_compass(relHeading)} $relHeading°',
                  style: SkyType.mono(13, color: SkyPalette.inkSoft)),
              const SizedBox(height: 4),
              Text(leg.status,
                  style: SkyType.label(color: statusTint(leg.status))),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../domain/demo_board.dart';
import '../../domain/status_tint.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/sky_card.dart';

class AirportBoardView extends StatefulWidget {
  const AirportBoardView({super.key});

  @override
  State<AirportBoardView> createState() => _AirportBoardViewState();
}

class _AirportBoardViewState extends State<AirportBoardView> {
  Airport _airport = DemoBoard.airports.first;
  bool _arrivals = false;

  @override
  Widget build(BuildContext context) {
    final board = DemoBoard.boardFor(_airport, arrivals: _arrivals);
    return Column(
      children: [
        _airportSelector(),
        _modeToggle(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            itemCount: board.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              if (i == board.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Schedule shown for reference only. Confirm with the airport before travelling.',
                    style: SkyType.caption(),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return _boardRow(board[i]);
            },
          ),
        ),
      ],
    );
  }

  Widget _airportSelector() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: DemoBoard.airports.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final a = DemoBoard.airports[i];
          final selected = a.code == _airport.code;
          return GestureDetector(
            onTap: () => setState(() => _airport = a),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? SkyPalette.skyDeep : SkyPalette.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? SkyPalette.skyDeep : SkyPalette.hairline,
                ),
              ),
              child: Row(
                children: [
                  Text(a.code,
                      style: SkyType.ticket(15,
                          spacing: 1.5,
                          color:
                              selected ? Colors.white : SkyPalette.ink)),
                  const SizedBox(width: 7),
                  Text(a.city,
                      style: SkyType.label(
                          color: selected
                              ? Colors.white70
                              : SkyPalette.inkSoft)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _modeToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: SkyPalette.paperDeep,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _toggleChip('Departures', !_arrivals,
                () => setState(() => _arrivals = false)),
            _toggleChip('Arrivals', _arrivals,
                () => setState(() => _arrivals = true)),
          ],
        ),
      ),
    );
  }

  Widget _toggleChip(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? SkyPalette.card : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: SkyPalette.skyDeep.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: SkyType.label(
                color: selected ? SkyPalette.skyDeep : SkyPalette.inkSoft),
          ),
        ),
      ),
    );
  }

  Widget _boardRow(FlightLeg leg) {
    final other = _arrivals ? leg.origin : leg.destination;
    final time = _arrivals ? leg.arriveTime : leg.departTime;
    return SkyCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: SkyType.mono(18)),
              const SizedBox(height: 2),
              Text(_arrivals ? 'from' : 'to',
                  style: SkyType.caption(color: SkyPalette.inkFaint)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(other.code,
                        style: SkyType.ticket(16, spacing: 1)),
                    const SizedBox(width: 8),
                    Text(other.city, style: SkyType.bodyStrong()),
                  ],
                ),
                const SizedBox(height: 3),
                Text('${leg.flightNumber} · ${leg.airline.name} · ${leg.aircraft.label}',
                    style: SkyType.caption()),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(leg.status,
                  style: SkyType.label(color: statusTint(leg.status))),
              const SizedBox(height: 4),
              Text('Gate ${leg.gate}', style: SkyType.caption()),
            ],
          ),
        ],
      ),
    );
  }
}

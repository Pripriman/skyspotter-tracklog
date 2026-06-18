import 'package:flutter/material.dart';

import '../../domain/demo_board.dart';
import '../../domain/status_tint.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/boarding_pass_card.dart';
import '../../widgets/lift_button.dart';
import '../../widgets/sky_card.dart';

class FlightSearchView extends StatefulWidget {
  const FlightSearchView({super.key});

  @override
  State<FlightSearchView> createState() => _FlightSearchViewState();
}

class _FlightSearchViewState extends State<FlightSearchView> {
  final _input = TextEditingController();
  FlightLeg? _result;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _search() {
    final raw = _input.text.trim();
    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a flight number, e.g. BA117.')),
      );
      return;
    }
    setState(() => _result = DemoBoard.lookup(raw));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      children: [
        SkyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Flight lookup', style: SkyType.heading()),
              const SizedBox(height: 6),
              Text(
                'Enter a flight number to pull its route, status and aircraft.',
                style: SkyType.body(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _input,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: const InputDecoration(
                  hintText: 'Flight number',
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                ),
              ),
              const SizedBox(height: 14),
              LiftButton(
                label: 'Track flight',
                icon: Icons.search_rounded,
                onPressed: _search,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_result == null)
          _hint()
        else ...[
          BoardingPassCard(
            flightNumber: _result!.flightNumber,
            carrier: _result!.airline.name,
            originCode: _result!.origin.code,
            originCity: _result!.origin.city,
            destCode: _result!.destination.code,
            destCity: _result!.destination.city,
            statusLabel: _result!.status,
            statusColor: statusTint(_result!.status),
            gate: _result!.gate,
            terminal: _result!.terminal,
            aircraftType: _result!.aircraft.label,
            departTime: _result!.departTime,
            arriveTime: _result!.arriveTime,
          ),
          const SizedBox(height: 16),
          SkyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aircraft', style: SkyType.label()),
                const SizedBox(height: 6),
                Text(
                  '${_result!.aircraft.manufacturer} ${_result!.aircraft.label} · ${_result!.aircraft.family}',
                  style: SkyType.bodyStrong(),
                ),
                const SizedBox(height: 4),
                Text('Registration ${_result!.registration}',
                    style: SkyType.caption()),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _disclaimer(),
        ],
      ],
    );
  }

  Widget _hint() {
    return SkyCard(
      color: SkyPalette.skyWash,
      border: Border.all(color: SkyPalette.sky),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: SkyPalette.skyDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Try a flight number to see its boarding-pass card. Times and gates are illustrative reference data.',
              style: SkyType.bodyStrong(color: SkyPalette.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer() => Text(
        'Flight details are shown for reference and orientation only and are not intended for boarding, navigation or operational decisions.',
        style: SkyType.caption(),
        textAlign: TextAlign.center,
      );
}

import 'package:flutter/material.dart';

import '../../domain/aircraft_types.dart';
import '../../domain/demo_board.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/aircraft_silhouette.dart';
import '../../widgets/sky_card.dart';

class FleetGuideView extends StatefulWidget {
  const FleetGuideView({super.key});

  @override
  State<FleetGuideView> createState() => _FleetGuideViewState();
}

class _FleetGuideViewState extends State<FleetGuideView> {
  bool _liveries = false;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _modeToggle(),
        Expanded(
          child: _liveries ? _liveryList() : _typeList(),
        ),
      ],
    );
  }

  Widget _modeToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: SkyPalette.paperDeep,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _chip('Aircraft types', !_liveries,
                () => setState(() => _liveries = false)),
            _chip('Liveries', _liveries,
                () => setState(() => _liveries = true)),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
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

  Widget _typeList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      itemCount: AircraftCatalog.all.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _typeCard(AircraftCatalog.all[i]),
    );
  }

  Widget _typeCard(AircraftType a) {
    final expanded = _expandedId == a.id;
    return SkyCard(
      onTap: () => setState(() => _expandedId = expanded ? null : a.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: SkyPalette.skyWash,
                  shape: BoxShape.circle,
                ),
                child: const AircraftSilhouette(
                    size: 30, color: SkyPalette.skyDeep),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${a.manufacturer} ${a.label}',
                        style: SkyType.heading()),
                    const SizedBox(height: 2),
                    Text(a.family, style: SkyType.caption()),
                  ],
                ),
              ),
              Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: SkyPalette.inkFaint),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _spec('Seats', '${a.typicalSeats}'),
              _spec('Range', '${a.rangeKm} km'),
              _spec('Engines', '${a.engines} · ${a.engineMount}'),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SkyPalette.runwayWash,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.visibility_outlined,
                      size: 18, color: SkyPalette.runway),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(a.spotterTip,
                        style: SkyType.body(color: SkyPalette.ink)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _spec(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: SkyType.caption(color: SkyPalette.inkFaint)),
          const SizedBox(height: 3),
          Text(value, style: SkyType.bodyStrong()),
        ],
      ),
    );
  }

  Widget _liveryList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
      itemCount: DemoBoard.airlines.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final a = DemoBoard.airlines[i];
        return SkyCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: SkyPalette.skyWash,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(a.code,
                    style: SkyType.ticket(13,
                        spacing: 1, color: SkyPalette.skyDeep)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.name, style: SkyType.bodyStrong()),
                    const SizedBox(height: 3),
                    Text(a.livery, style: SkyType.caption()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

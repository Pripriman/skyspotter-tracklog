import 'package:flutter/material.dart';
import '../theme/sky_palette.dart';
import '../theme/sky_type.dart';
import 'aircraft_silhouette.dart';
import 'barcode_strip.dart';

class BoardingPassCard extends StatelessWidget {
  final String flightNumber;
  final String carrier;
  final String originCode;
  final String originCity;
  final String destCode;
  final String destCity;
  final String statusLabel;
  final Color statusColor;
  final String gate;
  final String terminal;
  final String aircraftType;
  final String departTime;
  final String arriveTime;

  const BoardingPassCard({
    super.key,
    required this.flightNumber,
    required this.carrier,
    required this.originCode,
    required this.originCity,
    required this.destCode,
    required this.destCity,
    required this.statusLabel,
    required this.statusColor,
    required this.gate,
    required this.terminal,
    required this.aircraftType,
    required this.departTime,
    required this.arriveTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SkyPalette.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.12),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [SkyPalette.sky, SkyPalette.skyDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                Text(carrier,
                    style: SkyType.label(color: Colors.white)),
                const Spacer(),
                Text(flightNumber, style: SkyType.ticket(18, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _endpoint(originCode, originCity, departTime, left: true),
                Expanded(
                  child: Column(
                    children: [
                      const AircraftSilhouette(size: 30, heading: 90),
                      const SizedBox(height: 4),
                      const _RouteDots(),
                    ],
                  ),
                ),
                _endpoint(destCode, destCity, arriveTime, left: false),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: PerforationLine(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                _field('GATE', gate),
                _field('TERM', terminal),
                _field('TYPE', aircraftType),
                _statusPill(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            child: BarcodeStrip(seed: '$flightNumber$originCode$destCode'),
          ),
        ],
      ),
    );
  }

  Widget _endpoint(String code, String city, String time,
      {required bool left}) {
    return Column(
      crossAxisAlignment:
          left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(code, style: SkyType.ticket(28, spacing: 2)),
        const SizedBox(height: 2),
        Text(city,
            style: SkyType.caption(),
            textAlign: left ? TextAlign.left : TextAlign.right),
        const SizedBox(height: 6),
        Text(time, style: SkyType.mono(14, color: SkyPalette.inkSoft)),
      ],
    );
  }

  Widget _field(String label, String value) {
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

  Widget _statusPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(statusLabel, style: SkyType.label(color: statusColor)),
    );
  }
}

class _RouteDots extends StatelessWidget {
  const _RouteDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: SkyPalette.hairline,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

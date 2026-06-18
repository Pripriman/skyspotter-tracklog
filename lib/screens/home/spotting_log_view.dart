import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/aircraft_types.dart';
import '../../domain/spot_models.dart';
import '../../domain/spot_repository.dart';
import '../../state/logbook_scope.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/aircraft_silhouette.dart';
import '../../widgets/sky_card.dart';
import '../../widgets/stat_dial.dart';
import 'log_entry_sheet.dart';

class SpottingLogView extends StatefulWidget {
  const SpottingLogView({super.key});

  @override
  State<SpottingLogView> createState() => _SpottingLogViewState();
}

class _SpottingLogViewState extends State<SpottingLogView> {
  Future<void> _add(SpotRepository repo) async {
    await openLogEntrySheet(context, repo);
  }

  @override
  Widget build(BuildContext context) {
    final repo = LogbookScope.of(context);
    final entries = repo.entries;

    return Stack(
      children: [
        if (entries.isEmpty)
          _empty(repo)
        else
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            children: [
              _summary(repo),
              const SizedBox(height: 18),
              if (repo.spotsByType().length >= 2) ...[
                _byType(repo),
                const SizedBox(height: 18),
              ],
              Text('Recent sightings', style: SkyType.label()),
              const SizedBox(height: 12),
              ...entries.map((e) => _entryTile(repo, e)),
            ],
          ),
        Positioned(
          right: 18,
          bottom: 18,
          child: FloatingActionButton(
            backgroundColor: SkyPalette.sunset,
            foregroundColor: Colors.white,
            onPressed: () => _add(repo),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }

  Widget _empty(SpotRepository repo) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AircraftSilhouette(
                size: 64, heading: 30, color: SkyPalette.skyDeep),
            const SizedBox(height: 22),
            Text('Your logbook is empty', style: SkyType.title()),
            const SizedBox(height: 10),
            Text(
              'Log your first sighting — tail number, place and type — and start building your collection.',
              style: SkyType.body(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _add(repo),
              style: FilledButton.styleFrom(
                backgroundColor: SkyPalette.skyDeep,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text('Log a sighting',
                  style: SkyType.heading(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(SpotRepository repo) {
    final total = repo.totalSpots;
    final types = repo.uniqueTypes.length;
    final progress = (types / AircraftCatalog.all.length).clamp(0.0, 1.0);
    return SkyCard(
      child: Row(
        children: [
          StatDial(
            size: 96,
            progress: progress,
            stroke: 11,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$types',
                    style: SkyType.mono(24, color: SkyPalette.ink)),
                Text('types', style: SkyType.caption()),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your collection', style: SkyType.heading()),
                const SizedBox(height: 8),
                _stat('$total sightings logged', Icons.menu_book_rounded,
                    SkyPalette.skyDeep),
                const SizedBox(height: 4),
                _stat('${repo.uniqueAirlines.length} airlines',
                    Icons.business_rounded, SkyPalette.airborne),
                const SizedBox(height: 4),
                _stat('${repo.uniqueRegistrations.length} unique tails',
                    Icons.tag_rounded, SkyPalette.sunsetDeep),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text,
              style: SkyType.bodyStrong(color: SkyPalette.ink),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _byType(SpotRepository repo) {
    final map = repo.spotsByType();
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sorted.first.value;
    return SkyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Most spotted types', style: SkyType.heading()),
          const SizedBox(height: 12),
          ...sorted.take(6).map((e) {
            final type = AircraftCatalog.byId(e.key);
            final frac = maxVal == 0 ? 0.0 : e.value / maxVal;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(type.label, style: SkyType.bodyStrong()),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: frac.clamp(0, 1),
                        minHeight: 9,
                        backgroundColor: SkyPalette.paperDeep,
                        color: SkyPalette.sky,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${e.value}',
                      style: SkyType.label(color: SkyPalette.ink)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _entryTile(SpotRepository repo, SpotEntry e) {
    final type = AircraftCatalog.byId(e.aircraftTypeId);
    return Dismissible(
      key: ValueKey(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: SkyPalette.sunsetWash,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: SkyPalette.sunsetDeep),
      ),
      onDismissed: (_) => repo.remove(e.id),
      child: Container(
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
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: SkyPalette.skyWash,
                shape: BoxShape.circle,
              ),
              child: const AircraftSilhouette(
                  size: 28, color: SkyPalette.skyDeep),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (e.registration.isNotEmpty)
                        Text(e.registration, style: SkyType.ticket(14)),
                      if (e.registration.isNotEmpty)
                        const SizedBox(width: 8),
                      Text(type.label,
                          style: SkyType.caption(color: SkyPalette.skyDeep)),
                      if (e.hasPhoto) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.photo_camera_rounded,
                            size: 13, color: SkyPalette.inkFaint),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (e.airline.isNotEmpty) e.airline,
                      if (e.location.isNotEmpty) e.location,
                      DateFormat('MMM d, y').format(e.observedAt),
                    ].join(' · '),
                    style: SkyType.caption(),
                  ),
                  if (e.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(e.note,
                        style: SkyType.body(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/aircraft_types.dart';
import '../../domain/spot_models.dart';
import '../../domain/spot_repository.dart';
import '../../theme/sky_palette.dart';
import '../../theme/sky_type.dart';
import '../../widgets/lift_button.dart';

Future<SpotEntry?> openLogEntrySheet(
  BuildContext context,
  SpotRepository repo,
) {
  return showModalBottomSheet<SpotEntry>(
    context: context,
    isScrollControlled: true,
    backgroundColor: SkyPalette.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (_) => _LogEntrySheet(repo: repo),
  );
}

class _LogEntrySheet extends StatefulWidget {
  final SpotRepository repo;
  const _LogEntrySheet({required this.repo});

  @override
  State<_LogEntrySheet> createState() => _LogEntrySheetState();
}

class _LogEntrySheetState extends State<_LogEntrySheet> {
  final _location = TextEditingController();
  final _registration = TextEditingController();
  final _airline = TextEditingController();
  final _note = TextEditingController();
  String _typeId = AircraftCatalog.all.first.id;
  DateTime _observed = DateTime.now();
  bool _hasPhoto = false;
  bool _busy = false;

  @override
  void dispose() {
    _location.dispose();
    _registration.dispose();
    _airline.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _observed,
      firstDate: now.subtract(const Duration(days: 3650)),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: SkyPalette.skyDeep,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _observed = picked);
  }

  Future<void> _save() async {
    if (_registration.text.trim().isEmpty && _location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least a tail number or a place.')),
      );
      return;
    }
    setState(() => _busy = true);
    final entry = await widget.repo.add(
      observedAt: _observed,
      location: _location.text.trim(),
      aircraftTypeId: _typeId,
      registration: _registration.text.trim().toUpperCase(),
      airline: _airline.text.trim(),
      note: _note.text.trim(),
      hasPhoto: _hasPhoto,
    );
    if (mounted) Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: SkyPalette.hairline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('Log a sighting', style: SkyType.title()),
              const SizedBox(height: 18),
              Text('Aircraft type', style: SkyType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AircraftCatalog.all.map((a) {
                  final sel = a.id == _typeId;
                  return GestureDetector(
                    onTap: () => setState(() => _typeId = a.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? SkyPalette.skyWash : SkyPalette.paper,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? SkyPalette.sky : SkyPalette.hairline,
                          width: sel ? 1.6 : 1,
                        ),
                      ),
                      child: Text(a.label,
                          style: SkyType.label(
                              color: sel
                                  ? SkyPalette.skyDeep
                                  : SkyPalette.ink)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              _field('Tail number', _registration,
                  hint: 'e.g. G-XWBA', caps: true),
              const SizedBox(height: 14),
              _field('Airline', _airline, hint: 'e.g. British Airways'),
              const SizedBox(height: 14),
              _field('Place', _location, hint: 'e.g. LHR 27L'),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date', style: SkyType.label()),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 15),
                            decoration: BoxDecoration(
                              color: SkyPalette.paper,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: SkyPalette.hairline),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.event_rounded,
                                    size: 18, color: SkyPalette.skyDeep),
                                const SizedBox(width: 8),
                                Text(DateFormat('MMM d, y').format(_observed),
                                    style: SkyType.bodyStrong()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Photo', style: SkyType.label()),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _hasPhoto = !_hasPhoto),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 15),
                            decoration: BoxDecoration(
                              color: _hasPhoto
                                  ? SkyPalette.skyWash
                                  : SkyPalette.paper,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: _hasPhoto
                                      ? SkyPalette.sky
                                      : SkyPalette.hairline),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                    _hasPhoto
                                        ? Icons.photo_camera_rounded
                                        : Icons.photo_camera_outlined,
                                    size: 18,
                                    color: SkyPalette.skyDeep),
                                const SizedBox(width: 8),
                                Text(_hasPhoto ? 'Captured' : 'No photo',
                                    style: SkyType.bodyStrong()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _field('Note', _note,
                  hint: 'Special livery, rare visitor…', lines: 2),
              const SizedBox(height: 22),
              LiftButton(
                label: 'Save sighting',
                busy: _busy,
                onPressed: _busy ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {String? hint, bool caps = false, int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SkyType.label()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: lines,
          textCapitalization:
              caps ? TextCapitalization.characters : TextCapitalization.words,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

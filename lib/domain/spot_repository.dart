import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'spot_models.dart';

class SpotRepository extends ChangeNotifier {
  static const _storeKey = 'spot.entries';
  static const _uuid = Uuid();

  final List<SpotEntry> _entries = [];
  bool _loaded = false;

  List<SpotEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  int get totalSpots => _entries.length;

  Set<String> get uniqueTypes =>
      _entries.map((e) => e.aircraftTypeId).where((t) => t.isNotEmpty).toSet();

  Set<String> get uniqueAirlines => _entries
      .map((e) => e.airline.trim().toLowerCase())
      .where((a) => a.isNotEmpty)
      .toSet();

  Set<String> get uniqueRegistrations => _entries
      .map((e) => e.registration.trim().toUpperCase())
      .where((r) => r.isNotEmpty)
      .toSet();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storeKey);
    _entries.clear();
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        for (final e in list) {
          _entries.add(SpotEntry.fromJson(e as Map<String, dynamic>));
        }
      } catch (_) {}
    }
    _entries.sort((a, b) => b.observedAt.compareTo(a.observedAt));
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storeKey, encoded);
  }

  SpotEntry? byId(String id) {
    for (final e in _entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<SpotEntry> add({
    required DateTime observedAt,
    required String location,
    required String aircraftTypeId,
    required String registration,
    required String airline,
    String note = '',
    bool hasPhoto = false,
  }) async {
    final entry = SpotEntry(
      id: _uuid.v4(),
      observedAt: observedAt,
      location: location,
      aircraftTypeId: aircraftTypeId,
      registration: registration,
      airline: airline,
      note: note,
      hasPhoto: hasPhoto,
    );
    _entries.insert(0, entry);
    _entries.sort((a, b) => b.observedAt.compareTo(a.observedAt));
    await _persist();
    notifyListeners();
    return entry;
  }

  Future<void> remove(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> save() async {
    await _persist();
    notifyListeners();
  }

  Map<String, int> spotsByType() {
    final map = <String, int>{};
    for (final e in _entries) {
      if (e.aircraftTypeId.isEmpty) continue;
      map[e.aircraftTypeId] = (map[e.aircraftTypeId] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> spotsByLocation() {
    final map = <String, int>{};
    for (final e in _entries) {
      final loc = e.location.trim();
      if (loc.isEmpty) continue;
      map[loc] = (map[loc] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> spotsByMonth() {
    final map = <String, int>{};
    for (final e in _entries) {
      map[e.monthKey] = (map[e.monthKey] ?? 0) + 1;
    }
    return map;
  }
}

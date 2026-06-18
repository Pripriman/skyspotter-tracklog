import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_env.dart';
import '../config/route_blob.dart';
import 'backend_link.dart';
import 'crypto_unsealer.dart';

enum GateOutcome { content, native, badConnection }

class GateResult {
  final GateOutcome outcome;
  final String? endpoint;
  const GateResult(this.outcome, [this.endpoint]);
}

class BoardGate {
  static const _boardKey = 'spot.board';
  static const _storage = FlutterSecureStorage();

  static Future<GateResult> resolve() async {
    final cached = await _freshBoard();
    if (cached != null) {
      return GateResult(GateOutcome.content, cached);
    }

    if (!AppEnv.hasSupabase) {
      return const GateResult(GateOutcome.native);
    }

    String? key;
    try {
      key = await BackendLink.fetchGateKey();
    } catch (_) {
      return const GateResult(GateOutcome.badConnection);
    }

    if (key == null || key.isEmpty) {
      return const GateResult(GateOutcome.native);
    }

    final route = await CryptoUnsealer.reveal(RouteBlob.forPlatform(), key);
    if (route == null || route.isEmpty) {
      return const GateResult(GateOutcome.native);
    }

    final reachable = await _probe(route);
    if (!reachable) {
      return const GateResult(GateOutcome.native);
    }

    await _storeBoard(route);
    return GateResult(GateOutcome.content, route);
  }

  static Future<bool> _probe(String route) async {
    try {
      final resp = await http
          .get(Uri.parse(route))
          .timeout(const Duration(seconds: AppEnv.endpointProbeSeconds));
      if (resp.statusCode != 200) return false;
      return resp.bodyBytes.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> _freshBoard() async {
    try {
      final raw = await _storage.read(key: _boardKey);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final route = map['route'] as String?;
      final ts = map['ts'] as int?;
      if (route == null || ts == null) return null;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > AppEnv.endpointCacheTtl.inMilliseconds) return null;
      return route;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _storeBoard(String route) async {
    try {
      final payload = jsonEncode({
        'route': route,
        'ts': DateTime.now().millisecondsSinceEpoch,
      });
      await _storage.write(key: _boardKey, value: payload);
    } catch (_) {}
  }

  static Future<void> clearBoard() async {
    try {
      await _storage.delete(key: _boardKey);
    } catch (_) {}
  }
}

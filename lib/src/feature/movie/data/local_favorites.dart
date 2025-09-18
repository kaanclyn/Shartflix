import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

class LocalFavorites {
  static const String _boxName = 'local_favorites_box_v1';
  static const String _key = 'ids';
  static Box<dynamic>? _box;
  static final Set<String> _memory = <String>{};
  static bool _initTried = false;

  static Future<void> _ensureInit() async {
    if (_box != null || _initTried) return;
    _initTried = true;
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<dynamic>(_boxName);
      final List<dynamic>? raw = _box!.get(_key) as List<dynamic>?;
      if (raw != null) {
        _memory
          ..clear()
          ..addAll(raw.map((dynamic e) => e.toString()));
      }
    } catch (_) {
      // Fallback to in-memory only
    }
  }

  static Future<bool> isFavorite(String id) async {
    await _ensureInit();
    return _memory.contains(id);
  }

  static Future<void> toggle(String id) async {
    await _ensureInit();
    if (_memory.contains(id)) {
      _memory.remove(id);
    } else {
      _memory.add(id);
    }
    await _persist();
  }

  static Future<void> _persist() async {
    try {
      if (_box != null) {
        await _box!.put(_key, _memory.toList(growable: false));
      }
    } catch (_) {
      // ignore persistence errors
    }
  }

  static Future<List<String>> all() async {
    await _ensureInit();
    return _memory.toList(growable: false);
  }
}



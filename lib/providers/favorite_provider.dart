import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/car_wash.dart';

class FavoriteNotifier extends AsyncNotifier<List<CarWash>> {
  static const _key = 'favorite_car_washes';

  @override
  Future<List<CarWash>> build() => _loadFromPrefs();

  Future<List<CarWash>> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((s) => CarWash.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveToPrefs(List<CarWash> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      list.map((cw) => jsonEncode(cw.toJson())).toList(),
    );
  }

  Future<void> addFavorite(CarWash carWash) async {
    final current = state.valueOrNull ?? [];
    if (current.any((cw) => cw.id == carWash.id)) return;
    final updated = [carWash, ...current];
    await _saveToPrefs(updated);
    state = AsyncData(updated);
  }

  Future<void> removeFavorite(String id) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((cw) => cw.id != id).toList();
    await _saveToPrefs(updated);
    state = AsyncData(updated);
  }

  bool isFavorite(String id) =>
      state.valueOrNull?.any((cw) => cw.id == id) ?? false;

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const AsyncData([]);
  }
}

final favoriteProvider =
    AsyncNotifierProvider<FavoriteNotifier, List<CarWash>>(
  () => FavoriteNotifier(),
);

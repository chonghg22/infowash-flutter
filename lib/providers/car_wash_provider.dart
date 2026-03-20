import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/car_wash.dart';
import '../data/repositories/car_wash_repository.dart';
import 'location_provider.dart';

// ── Repository ────────────────────────────────────────────────────────────────
final carWashRepositoryProvider = Provider<CarWashRepository>((ref) {
  return CarWashRepository(Supabase.instance.client);
});

// ── Nearby Car Washes ─────────────────────────────────────────────────────────
final nearbyCarWashesProvider =
    FutureProvider.autoDispose<List<CarWash>>((ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  final repo = ref.watch(carWashRepositoryProvider);

  if (position == null) return [];

  return repo.fetchNearby(
    latitude: position.latitude,
    longitude: position.longitude,
  );
});

// ── Car Wash List (검색/필터) ──────────────────────────────────────────────────
final carWashListProvider =
    FutureProvider.autoDispose.family<List<CarWash>, String?>((ref, query) {
  final repo = ref.watch(carWashRepositoryProvider);
  return repo.fetchList(searchQuery: query);
});

// ── Car Wash Detail ───────────────────────────────────────────────────────────
final carWashDetailProvider =
    FutureProvider.autoDispose.family<CarWash?, String>((ref, id) {
  final repo = ref.watch(carWashRepositoryProvider);
  return repo.fetchById(id);
});

// ── Search Query State ────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Selected Car Wash (지도 마커 선택) ────────────────────────────────────────
final selectedCarWashProvider = StateProvider<CarWash?>((ref) => null);

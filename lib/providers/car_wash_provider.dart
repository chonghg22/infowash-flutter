import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/car_wash.dart';
import '../data/repositories/car_wash_repository.dart';
import 'location_provider.dart';

// ── Repository ────────────────────────────────────────────────────────────────
final carWashRepositoryProvider = Provider<CarWashRepository>((ref) {
  return CarWashRepository(Supabase.instance.client);
});

// ── Nearby Car Washes — nearby-carwash Edge Function 호출 ─────────────────────
final nearbyCarWashesProvider =
    FutureProvider.autoDispose<List<CarWash>>((ref) async {
  try {
    final position = await ref.watch(locationNotifierProvider.future);
    if (position == null) return [];

    final response = await Supabase.instance.client.functions.invoke(
      'nearby-carwash',
      body: {
        'lat': position.latitude,
        'lng': position.longitude,
        'radius_km': 5,
        'limit': 20,
      },
    );

    final data = response.data as List<dynamic>;
    return data
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e, st) {
    debugPrint('[nearbyCarWashesProvider] error: $e\n$st');
    return [];
  }
});

// ── Car Wash List (검색/필터) ──────────────────────────────────────────────────
final carWashListProvider =
    FutureProvider.autoDispose.family<List<CarWash>, String?>((ref, query) async {
  try {
    final repo = ref.watch(carWashRepositoryProvider);
    return repo.fetchList(searchQuery: query);
  } catch (e, st) {
    debugPrint('[carWashListProvider] error: $e\n$st');
    return [];
  }
});

// ── Car Wash Detail ───────────────────────────────────────────────────────────
final carWashDetailProvider =
    FutureProvider.autoDispose.family<CarWash?, String>((ref, id) {
  final repo = ref.watch(carWashRepositoryProvider);
  return repo.fetchById(id);
});

// ── 지도 검색 파라미터 (홈 화면 카메라 중심 기준) ─────────────────────────────
typedef MapSearchParams = ({double lat, double lng, double radiusKm});

final mapSearchParamsProvider = StateProvider<MapSearchParams?>(
  (ref) => null,
);

// ── 지도 중심 기반 주변 세차장 검색 ───────────────────────────────────────────
final mapNearbyCarWashesProvider =
    FutureProvider.autoDispose<List<CarWash>>((ref) async {
  final params = ref.watch(mapSearchParamsProvider);
  if (params == null) return [];

  try {
    final response = await Supabase.instance.client.functions.invoke(
      'nearby-carwash',
      body: {
        'lat': params.lat,
        'lng': params.lng,
        'radius_km': params.radiusKm,
        'limit': 30,
      },
    );
    final data = response.data as List<dynamic>;
    return data
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e, st) {
    debugPrint('[mapNearbyCarWashesProvider] error: $e\n$st');
    return [];
  }
});

// ── Search Query State ────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Selected Car Wash (지도 마커 선택) ────────────────────────────────────────
final selectedCarWashProvider = StateProvider<CarWash?>((ref) => null);

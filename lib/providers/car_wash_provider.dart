import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/car_wash.dart';
import '../data/repositories/car_wash_repository.dart';
import 'location_provider.dart';

// ── Repository ────────────────────────────────────────────────────────────────
final carWashRepositoryProvider = Provider<CarWashRepository>((ref) {
  return CarWashRepository(Supabase.instance.client);
});

// ── Nearby Car Washes — RPC 호출 ──────────────────────────────────────────────
final nearbyCarWashesProvider =
    FutureProvider.autoDispose<List<CarWash>>((ref) async {
  try {
    final position = await ref.watch(locationNotifierProvider.future);
    if (position == null) return [];

    final response = await Supabase.instance.client
        .schema('infowash')
        .rpc('get_nearby_car_washes', params: {
      'user_lat': position.latitude,
      'user_lng': position.longitude,
      'radius_km': 5,
      'max_limit': 20,
    });

    final data = response as List<dynamic>;
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

// ── 지도 중심 기반 주변 세차장 검색 (RPC + 캐싱) ──────────────────────────────
class _MapNearbyNotifier extends AsyncNotifier<List<CarWash>> {
  List<CarWash>? _cache;
  double? _cacheLat;
  double? _cacheLng;

  bool _isSameLocation(double lat, double lng) {
    if (_cacheLat == null || _cacheLng == null) return false;
    return Geolocator.distanceBetween(_cacheLat!, _cacheLng!, lat, lng) < 1000;
  }

  @override
  Future<List<CarWash>> build() async {
    final params = ref.watch(mapSearchParamsProvider);
    if (params == null) return _cache ?? [];

    if (_cache != null && _isSameLocation(params.lat, params.lng)) {
      // 캐시 즉시 반환 후 백그라운드에서 업데이트
      Future.delayed(Duration.zero, () async {
        try {
          final fresh =
              await _doFetch(params.lat, params.lng, params.radiusKm);
          state = AsyncData(fresh);
        } catch (_) {}
      });
      return _cache!;
    }

    return _doFetch(params.lat, params.lng, params.radiusKm);
  }

  Future<List<CarWash>> _doFetch(
      double lat, double lng, double radiusKm) async {
    final response = await Supabase.instance.client
        .schema('infowash')
        .rpc('get_nearby_car_washes', params: {
      'user_lat': lat,
      'user_lng': lng,
      'radius_km': radiusKm,
      'max_limit': 20,
    });

    final data = response as List<dynamic>;
    final result = data
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();

    _cache = result;
    _cacheLat = lat;
    _cacheLng = lng;
    debugPrint('[mapNearbyCarWashesProvider] fetched ${result.length}개');
    return result;
  }
}

final mapNearbyCarWashesProvider =
    AsyncNotifierProvider<_MapNearbyNotifier, List<CarWash>>(
  _MapNearbyNotifier.new,
);

// ── Search Query State ────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Selected Car Wash (지도 마커 선택) ────────────────────────────────────────
final selectedCarWashProvider = StateProvider<CarWash?>((ref) => null);

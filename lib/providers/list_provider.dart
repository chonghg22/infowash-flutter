import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../data/models/car_wash.dart';
import 'car_wash_provider.dart';
import 'location_provider.dart';

// ── 필터 상태 ──────────────────────────────────────────────────────────────────
class ListFilterState {
  const ListFilterState({
    this.searchQuery = '',
    this.facilityFilters = const {},
  });

  final String searchQuery;
  final Set<String> facilityFilters;

  ListFilterState copyWith({
    String? searchQuery,
    Set<String>? facilityFilters,
  }) {
    return ListFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      facilityFilters: facilityFilters ?? this.facilityFilters,
    );
  }
}

final listFilterStateProvider =
    StateProvider<ListFilterState>((ref) => const ListFilterState());

// ── 전체 세차장 목록 (거리순 정렬) ────────────────────────────────────────────
final allCarWashListProvider = FutureProvider<List<CarWash>>((ref) async {
  final repo = ref.watch(carWashRepositoryProvider);
  // 마지막으로 알려진 위치 사용 (없으면 서울 기본값)
  final position = ref.read(locationNotifierProvider).valueOrNull;
  final lat = position?.latitude ?? AppConstants.defaultLatitude;
  final lng = position?.longitude ?? AppConstants.defaultLongitude;
  return repo.getAllCarWashes(lat: lat, lng: lng);
});

// ── 필터 적용된 목록 ──────────────────────────────────────────────────────────
final filteredCarWashListProvider =
    Provider<AsyncValue<List<CarWash>>>((ref) {
  final allAsync = ref.watch(allCarWashListProvider);
  final filter = ref.watch(listFilterStateProvider);

  return allAsync.whenData((all) {
    var result = all;

    // 지역/이름 검색
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      result = result.where((c) {
        return c.address.toLowerCase().contains(q) ||
            (c.roadAddress?.toLowerCase().contains(q) ?? false) ||
            c.name.toLowerCase().contains(q);
      }).toList();
    }

    // 편의시설 필터
    for (final f in filter.facilityFilters) {
      result = result.where((c) {
        switch (f) {
          case '영업중':
            return c.status == 'ACTIVE';
          case '진공청소기':
            return c.hasVacuum;
          case '에어건':
            return c.hasAirGun;
          case '매트세척기':
            return c.hasMatWash;
          default:
            return true;
        }
      }).toList();
    }

    return result;
  });
});

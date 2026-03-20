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
    this.selectedCity,
    this.selectedDistrict,
  });

  final String searchQuery;
  final Set<String> facilityFilters;
  final String? selectedCity;
  final String? selectedDistrict;

  ListFilterState copyWith({
    String? searchQuery,
    Set<String>? facilityFilters,
    // null을 명시적으로 설정할 수 있도록 Object? 패턴 사용
    Object? selectedCity = _sentinel,
    Object? selectedDistrict = _sentinel,
  }) {
    return ListFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      facilityFilters: facilityFilters ?? this.facilityFilters,
      selectedCity: identical(selectedCity, _sentinel)
          ? this.selectedCity
          : selectedCity as String?,
      selectedDistrict: identical(selectedDistrict, _sentinel)
          ? this.selectedDistrict
          : selectedDistrict as String?,
    );
  }
}

const _sentinel = Object();

final listFilterStateProvider =
    StateProvider<ListFilterState>((ref) => const ListFilterState());

// ── 전체 세차장 목록 (거리순 정렬) ────────────────────────────────────────────
final allCarWashListProvider = FutureProvider<List<CarWash>>((ref) async {
  final repo = ref.watch(carWashRepositoryProvider);
  final position = ref.read(locationNotifierProvider).valueOrNull;
  final lat = position?.latitude ?? AppConstants.defaultLatitude;
  final lng = position?.longitude ?? AppConstants.defaultLongitude;
  return repo.getAllCarWashes(lat: lat, lng: lng);
});

// ── 주소에서 시/도 추출 ────────────────────────────────────────────────────────
String? _extractCity(CarWash cw) {
  final addr = (cw.roadAddress ?? cw.address).trim();
  final parts = addr.split(' ');
  return parts.isNotEmpty ? parts[0] : null;
}

// ── 주소에서 구/군/시 추출 ─────────────────────────────────────────────────────
String? _extractDistrict(CarWash cw) {
  final addr = (cw.roadAddress ?? cw.address).trim();
  final parts = addr.split(' ');
  return parts.length >= 2 ? parts[1] : null;
}

// ── 선택된 시에 해당하는 구/군 목록 (DB 기반 동적 생성) ───────────────────────
final districtListProvider =
    Provider.family<List<String>, String>((ref, city) {
  final allAsync = ref.watch(allCarWashListProvider);
  final all = allAsync.valueOrNull ?? [];

  final districts = <String>{};
  for (final cw in all) {
    if (_extractCity(cw) == city) {
      final d = _extractDistrict(cw);
      if (d != null && d.isNotEmpty) districts.add(d);
    }
  }

  return districts.toList()..sort();
});

// ── 필터 적용된 목록 ──────────────────────────────────────────────────────────
final filteredCarWashListProvider =
    Provider<AsyncValue<List<CarWash>>>((ref) {
  final allAsync = ref.watch(allCarWashListProvider);
  final filter = ref.watch(listFilterStateProvider);

  return allAsync.whenData((all) {
    var result = all;

    // 시/도 필터
    if (filter.selectedCity != null) {
      result = result
          .where((c) => _extractCity(c) == filter.selectedCity)
          .toList();
    }

    // 구/군 필터
    if (filter.selectedDistrict != null) {
      result = result
          .where((c) => _extractDistrict(c) == filter.selectedDistrict)
          .toList();
    }

    // 텍스트 검색
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

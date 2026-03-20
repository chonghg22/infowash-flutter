import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/list_provider.dart';
import '../../widgets/car_wash_card.dart';

const _cityChips = [
  '서울', '부산', '대구', '인천', '광주', '대전', '울산',
  '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남', '제주',
];

const _facilityFilters = ['영업중', '진공청소기', '에어건', '매트세척기'];

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCity(String? city) {
    ref.read(listFilterStateProvider.notifier).update(
          (s) => s.copyWith(
            selectedCity: city,
            selectedDistrict: null, // 시 변경 시 구 초기화
          ),
        );
  }

  void _selectDistrict(String? district) {
    ref.read(listFilterStateProvider.notifier).update(
          (s) => s.copyWith(selectedDistrict: district),
        );
  }

  void _toggleFacility(String label, bool on) {
    ref.read(listFilterStateProvider.notifier).update((s) {
      final next = Set<String>.from(s.facilityFilters);
      on ? next.add(label) : next.remove(label);
      return s.copyWith(facilityFilters: next);
    });
  }

  void _resetAll() {
    _searchController.clear();
    ref.read(listFilterStateProvider.notifier).state =
        const ListFilterState();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(listFilterStateProvider);
    final filteredAsync = ref.watch(filteredCarWashListProvider);
    final districts = filter.selectedCity != null
        ? ref.watch(districtListProvider(filter.selectedCity!))
        : <String>[];

    return Scaffold(
      appBar: AppBar(title: const Text('세차장 목록')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 텍스트 검색바 ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '세차장 이름 또는 주소 검색',
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.primary),
                suffixIcon: filter.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(listFilterStateProvider.notifier)
                              .update((s) => s.copyWith(searchQuery: ''));
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (v) => ref
                  .read(listFilterStateProvider.notifier)
                  .update((s) => s.copyWith(searchQuery: v)),
            ),
          ),

          // ── 1단계: 시/도 선택 칩 ────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              children: [
                // 전체 칩
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CityChip(
                    label: '전체',
                    selected: filter.selectedCity == null,
                    onTap: () => _selectCity(null),
                  ),
                ),
                ..._cityChips.map((city) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CityChip(
                        label: city,
                        selected: filter.selectedCity == city,
                        onTap: () => filter.selectedCity == city
                            ? _selectCity(null)
                            : _selectCity(city),
                      ),
                    )),
              ],
            ),
          ),

          // ── 2단계: 구/군 선택 칩 (AnimatedSize) ─────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: filter.selectedCity == null || districts.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      children: [
                        // 시 전체 칩
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _DistrictChip(
                            label: '${filter.selectedCity} 전체',
                            selected: filter.selectedDistrict == null,
                            onTap: () => _selectDistrict(null),
                          ),
                        ),
                        ...districts.map((d) => Padding(
                              padding:
                                  const EdgeInsets.only(right: 8),
                              child: _DistrictChip(
                                label: d,
                                selected:
                                    filter.selectedDistrict == d,
                                onTap: () =>
                                    filter.selectedDistrict == d
                                        ? _selectDistrict(null)
                                        : _selectDistrict(d),
                              ),
                            )),
                      ],
                    ),
                  ),
          ),

          // ── 편의시설 필터 칩 ─────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              children: _facilityFilters.map((label) {
                final selected =
                    filter.facilityFilters.contains(label);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (on) => _toggleFacility(label, on),
                    selectedColor:
                        AppTheme.primary.withValues(alpha: 0.12),
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: selected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // ── 결과 수 + 현재 선택 지역 표시 ───────────────────────
          filteredAsync.when(
            data: (list) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _buildCountLabel(filter, list.length),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (filter.selectedCity != null ||
                      filter.facilityFilters.isNotEmpty ||
                      filter.searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: _resetAll,
                      child: const Text(
                        '초기화',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 36),
            error: (_, __) => const SizedBox(height: 36),
          ),

          // ── 목록 본문 ─────────────────────────────────────────────
          Expanded(
            child: filteredAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppTheme.error),
                    const SizedBox(height: 12),
                    const Text(
                      '데이터를 불러올 수 없습니다',
                      style:
                          TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(allCarWashListProvider),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64,
                            color: AppTheme.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          _buildEmptyLabel(filter),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _resetAll,
                          child: const Text('필터 초기화'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(allCarWashListProvider),
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final carWash = list[index];
                      return GestureDetector(
                        onTap: () => context
                            .push(AppRoutes.detailPath(carWash.id)),
                        child: CarWashCard(carWash: carWash),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _buildCountLabel(ListFilterState filter, int count) {
    final city = filter.selectedCity;
    final district = filter.selectedDistrict;
    if (city == null) return '세차장 $count개';
    if (district == null) return '$city 세차장 $count개';
    return '$city > $district 세차장 $count개';
  }

  String _buildEmptyLabel(ListFilterState filter) {
    final city = filter.selectedCity;
    final district = filter.selectedDistrict;
    final q = filter.searchQuery;

    if (q.isNotEmpty) return "'$q' 검색 결과가 없어요";
    if (district != null) return '$city $district\n근처 세차장이 없어요';
    if (city != null) return '$city\n근처 세차장이 없어요';
    return '주변에 세차장이 없어요';
  }
}

// ── 시/도 선택 칩 ─────────────────────────────────────────────────────────────
class _CityChip extends StatelessWidget {
  const _CityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── 구/군 선택 칩 ──────────────────────────────────────────────────────────────
class _DistrictChip extends StatelessWidget {
  const _DistrictChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.divider,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? AppTheme.primary : AppTheme.textSecondary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

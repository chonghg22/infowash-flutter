import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/list_provider.dart';
import '../../widgets/car_wash_card.dart';

// 지역 빠른 선택 칩 목록
const _regionChips = ['전체', '서울', '부산', '대구', '인천', '광주', '대전', '울산', '경기'];

// 편의시설 필터 목록
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

  void _setSearchQuery(String query) {
    _searchController.text = query;
    ref.read(listFilterStateProvider.notifier).update(
          (s) => s.copyWith(searchQuery: query),
        );
  }

  void _toggleFacility(String label, bool on) {
    ref.read(listFilterStateProvider.notifier).update((s) {
      final next = Set<String>.from(s.facilityFilters);
      on ? next.add(label) : next.remove(label);
      return s.copyWith(facilityFilters: next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(listFilterStateProvider);
    final filteredAsync = ref.watch(filteredCarWashListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('세차장 목록')),
      body: Column(
        children: [
          // ── 검색바 ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '시/군/구 또는 세차장 이름 검색',
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.primary),
                suffixIcon: filter.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _setSearchQuery(''),
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

          // ── 지역 빠른 선택 칩 ────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _regionChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final region = _regionChips[i];
                final isSelected = region == '전체'
                    ? filter.searchQuery.isEmpty
                    : filter.searchQuery == region;

                return ChoiceChip(
                  label: Text(region),
                  selected: isSelected,
                  onSelected: (_) =>
                      _setSearchQuery(region == '전체' ? '' : region),
                  selectedColor:
                      AppTheme.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                );
              },
            ),
          ),

          // ── 편의시설 필터 칩 ─────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _facilityFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final label = _facilityFilters[i];
                final selected =
                    filter.facilityFilters.contains(label);

                return FilterChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (on) => _toggleFacility(label, on),
                  selectedColor:
                      AppTheme.primary.withValues(alpha: 0.15),
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
                );
              },
            ),
          ),

          const Divider(height: 1),

          // ── 결과 수 ──────────────────────────────────────────────
          filteredAsync.when(
            data: (list) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '세차장 ${list.length}개',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox(height: 36),
            error: (_, __) => const SizedBox(height: 36),
          ),

          // ── 목록 ────────────────────────────────────────────────
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
                      style: TextStyle(color: AppTheme.textSecondary),
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
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filter.searchQuery.isNotEmpty
                              ? '\'${filter.searchQuery}\' 근처 세차장이 없어요'
                              : '주변에 세차장이 없어요',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (filter.searchQuery.isNotEmpty ||
                            filter.facilityFilters.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _setSearchQuery('');
                              ref
                                  .read(listFilterStateProvider.notifier)
                                  .update((s) => s.copyWith(
                                        facilityFilters: const {},
                                      ));
                            },
                            child: const Text('필터 초기화'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(allCarWashListProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
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
}

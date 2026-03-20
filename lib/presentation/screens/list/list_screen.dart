import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/car_wash.dart';
import '../../../providers/car_wash_provider.dart';
import '../../widgets/car_wash_card.dart';

// 필터 상태 (list 화면 내에서만 사용)
final _listFilterProvider = StateProvider<Set<String>>((ref) => const {});

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync = ref.watch(nearbyCarWashesProvider);
    final filters = ref.watch(_listFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('세차장 목록')),
      body: nearbyAsync.when(
        data: (list) => _ListBody(list: list, filters: filters),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
              const SizedBox(height: 12),
              const Text(
                '오류가 발생했습니다',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(nearbyCarWashesProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListBody extends ConsumerWidget {
  const _ListBody({required this.list, required this.filters});

  final List<CarWash> list;
  final Set<String> filters;

  static const _filterLabels = ['영업중', '진공청소기', '에어건', '매트세척기'];

  List<CarWash> _applyFilters(List<CarWash> items, Set<String> filters) {
    if (filters.isEmpty) return items;
    return items.where((c) {
      if (filters.contains('영업중') && c.status != 'ACTIVE') return false;
      if (filters.contains('진공청소기') && !c.hasVacuum) return false;
      if (filters.contains('에어건') && !c.hasAirGun) return false;
      if (filters.contains('매트세척기') && !c.hasMatWash) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = _applyFilters(list, filters);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(nearbyCarWashesProvider),
      child: CustomScrollView(
        slivers: [
          // ── 필터 칩 ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: _filterLabels.map((label) {
                  final selected = filters.contains(label);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (on) {
                        final notifier =
                            ref.read(_listFilterProvider.notifier);
                        final next = Set<String>.from(notifier.state);
                        on ? next.add(label) : next.remove(label);
                        notifier.state = next;
                      },
                      selectedColor: AppTheme.primary.withValues(alpha: 0.15),
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
          ),

          // ── 목록 또는 빈 상태 ─────────────────────────────────
          if (filtered.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_car_wash,
                      size: 64,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '주변에 세차장이 없어요',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '필터를 해제하거나 위치를 변경해 보세요',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final carWash = filtered[index];
                  return GestureDetector(
                    onTap: () =>
                        context.push(AppRoutes.detailPath(carWash.id)),
                    child: CarWashCard(carWash: carWash),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/car_wash_provider.dart';
import '../../../providers/location_provider.dart';
import '../../widgets/car_wash_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // TODO: NaverMapController 추가 (flutter_naver_map 연동 시)

  @override
  Widget build(BuildContext context) {
    final nearbyAsync = ref.watch(nearbyCarWashesProvider);
    final selectedCarWash = ref.watch(selectedCarWashProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── 지도 영역 ─────────────────────────────────────────
          // TODO: NaverMap 위젯으로 교체
          // NaverMap(
          //   options: NaverMapViewOptions(initialCameraPosition: ...),
          //   onMapReady: (controller) => ...,
          //   onMarkerTab: (marker, iconSize) => ...,
          // )
          Container(
            color: const Color(0xFFD9E8F5),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map, size: 64, color: AppTheme.primary),
                  SizedBox(height: 12),
                  Text(
                    '네이버 지도 연동 예정',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  Text(
                    'flutter_naver_map 키 설정 후 활성화',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 상단 검색바 ───────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.list),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.primary),
                      SizedBox(width: 8),
                      Text(
                        '세차장 검색',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 내 위치 버튼 ──────────────────────────────────────
          Positioned(
            right: 16,
            bottom: selectedCarWash != null ? 220 : 100,
            child: FloatingActionButton.small(
              heroTag: 'location_btn',
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              onPressed: () => ref.refresh(currentPositionProvider),
              child: const Icon(Icons.my_location),
            ),
          ),

          // ── 선택된 세차장 카드 ─────────────────────────────────
          if (selectedCarWash != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () => context.push(
                  AppRoutes.detailPath(selectedCarWash.id),
                ),
                child: CarWashCard(carWash: selectedCarWash),
              ),
            ),

          // ── 주변 세차장 수 뱃지 ───────────────────────────────
          nearbyAsync.when(
            data: (list) => Positioned(
              left: 16,
              bottom: selectedCarWash != null ? 230 : 100,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '주변 ${list.length}개',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

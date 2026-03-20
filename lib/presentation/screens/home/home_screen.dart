import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/car_wash.dart';
import '../../../providers/car_wash_provider.dart';
import '../../../providers/location_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  NaverMapController? _mapController;
  CarWash? _selectedCarWash;
  bool _cameraMoved = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // ── 마커 추가 ──────────────────────────────────────────────────────────────
  void _updateMarkers(List<CarWash> carWashes) {
    final controller = _mapController;
    if (controller == null) return;

    controller.clearOverlays();
    final markers = carWashes.map((cw) {
      final marker = NMarker(
        id: cw.id,
        position: NLatLng(cw.lat, cw.lng),
        caption: NOverlayCaption(
          text: cw.name,
          textSize: 12,
          color: AppTheme.textPrimary,
          haloColor: Colors.white,
        ),
      );
      marker.setOnTapListener((_) {
        setState(() => _selectedCarWash = cw);
      });
      return marker;
    }).toSet();

    controller.addOverlayAll(markers);
  }

  // ── 현재 위치로 카메라 이동 ────────────────────────────────────────────────
  Future<void> _moveToCurrentPosition() async {
    final position = ref.read(locationNotifierProvider).valueOrNull;
    if (position == null || _mapController == null) return;

    await _mapController!.updateCamera(
      NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(position.latitude, position.longitude),
        zoom: 14,
      ),
    );
    _cameraMoved = true;
  }

  // ── 위치 권한 거부 다이얼로그 ──────────────────────────────────────────────
  void _showPermissionDialog({bool isPermanent = false}) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('위치 권한 필요'),
        content: Text(
          isPermanent
              ? '위치 권한이 영구적으로 거부되었습니다.\n설정 앱에서 위치 권한을 허용해주세요.'
              : '주변 세차장을 찾으려면 위치 권한이 필요합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('닫기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (isPermanent) {
                Geolocator.openAppSettings();
              } else {
                ref.read(locationNotifierProvider.notifier).refresh();
              }
            },
            child: Text(isPermanent ? '설정으로 이동' : '다시 시도'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 위치 상태 감지
    ref.listen(locationNotifierProvider, (prev, next) {
      if (next.hasError) {
        final notifier = ref.read(locationNotifierProvider.notifier);
        _showPermissionDialog(isPermanent: notifier.isDeniedForever);
      } else if (next.hasValue && !_cameraMoved) {
        _moveToCurrentPosition();
      }
    });

    // 주변 세차장 로드되면 마커 갱신
    ref.listen(nearbyCarWashesProvider, (prev, next) {
      next.whenData(_updateMarkers);
    });

    final nearbyAsync = ref.watch(nearbyCarWashesProvider);
    final selectedCarWash = _selectedCarWash;
    final bottomOffset = selectedCarWash != null ? 250.0 : 100.0;

    return Scaffold(
      body: Stack(
        children: [
          // ── 네이버 지도 ────────────────────────────────────────────────────
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(
                  AppConstants.defaultLatitude,
                  AppConstants.defaultLongitude,
                ),
                zoom: AppConstants.defaultZoomLevel,
              ),
              locationButtonEnable: false,
              consumeSymbolTapEvents: false,
            ),
            onMapReady: (controller) {
              _mapController = controller;
              _moveToCurrentPosition();
              nearbyAsync.whenData(_updateMarkers);
            },
            onMapTapped: (_, __) {
              if (_selectedCarWash != null) {
                setState(() => _selectedCarWash = null);
              }
            },
          ),

          // ── 상단 검색바 ────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GestureDetector(
                onTap: () => context.push('/list'),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '세차장 검색',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── 주변 세차장 수 뱃지 ────────────────────────────────────────────
          nearbyAsync.when(
            data: (list) => Positioned(
              left: 16,
              bottom: bottomOffset,
              child: AnimatedOpacity(
                opacity: list.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
            ),
            loading: () => Positioned(
              left: 16,
              bottom: bottomOffset,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primary,
                ),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // ── 우하단 FAB: 현재 위치로 이동 ──────────────────────────────────
          Positioned(
            right: 16,
            bottom: bottomOffset,
            child: FloatingActionButton.small(
              heroTag: 'location_fab',
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              elevation: 4,
              onPressed: () async {
                await ref
                    .read(locationNotifierProvider.notifier)
                    .refresh();
                _cameraMoved = false;
                await _moveToCurrentPosition();
              },
              child: const Icon(Icons.my_location, size: 20),
            ),
          ),

          // ── 선택된 세차장 미니 카드 (DraggableScrollableSheet) ─────────────
          if (selectedCarWash != null)
            DraggableScrollableSheet(
              initialChildSize: 0.22,
              minChildSize: 0.12,
              maxChildSize: 0.45,
              snap: true,
              snapSizes: const [0.22, 0.45],
              builder: (ctx, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _MiniCarWashCard(
                      carWash: selectedCarWash,
                      onTap: () =>
                          context.push('/detail/${selectedCarWash.id}'),
                      onClose: () =>
                          setState(() => _selectedCarWash = null),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ── 미니 카드 위젯 ─────────────────────────────────────────────────────────────
class _MiniCarWashCard extends StatelessWidget {
  const _MiniCarWashCard({
    required this.carWash,
    required this.onTap,
    required this.onClose,
  });

  final CarWash carWash;
  final VoidCallback onTap;
  final VoidCallback onClose;

  String _formatDistance(double m) {
    if (m < 1000) return '${m.toInt()}m';
    return '${(m / 1000).toStringAsFixed(1)}km';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 드래그 핸들
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: carWash.images.isNotEmpty
                        ? Image.network(
                            carWash.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const _PlaceholderThumb(),
                          )
                        : const _PlaceholderThumb(),
                  ),
                ),
                const SizedBox(width: 14),

                // 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carWash.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        carWash.roadAddress ?? carWash.address,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (carWash.distanceM != null) ...[
                            const Icon(
                              Icons.place,
                              size: 13,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _formatDistance(carWash.distanceM!),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          _StatusBadge(isActive: carWash.status == 'ACTIVE'),
                        ],
                      ),
                    ],
                  ),
                ),

                // 닫기 버튼
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: AppTheme.textSecondary,
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 상세보기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                child: const Text('상세 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderThumb extends StatelessWidget {
  const _PlaceholderThumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3F2FD),
      child: const Icon(
        Icons.local_car_wash,
        color: AppTheme.primary,
        size: 32,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isActive ? '운영중' : '운영종료',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green.shade700 : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

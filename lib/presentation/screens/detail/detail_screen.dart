import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/car_wash_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/ad_banner.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(carWashDetailProvider(id));

    return Scaffold(
      body: detailAsync.when(
        data: (carWash) {
          if (carWash == null) {
            return const Center(child: Text('세차장 정보를 찾을 수 없습니다.'));
          }

          final isActive = carWash.status == 'ACTIVE';
          final firstImage =
              carWash.images.isNotEmpty ? carWash.images.first : null;

          return CustomScrollView(
            slivers: [
              // ── SliverAppBar (이미지) ─────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: firstImage != null
                      ? Image.network(firstImage, fit: BoxFit.cover)
                      : Container(
                          color: AppTheme.primaryLight,
                          child: const Icon(
                            Icons.local_car_wash,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                ),
                actions: [
                  // 즐겨찾기 버튼
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      if (!ref.read(isSignedInProvider)) {
                        context.push(AppRoutes.login);
                        return;
                      }
                      // TODO: 즐겨찾기 토글
                    },
                  ),
                  // 신고 버튼
                  IconButton(
                    icon: const Icon(Icons.flag_outlined),
                    onPressed: () => context.push(
                      AppRoutes.report,
                      extra: {'carWashId': id},
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 이름 & 영업상태 ───────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              carWash.name,
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          _StatusBadge(isActive: isActive),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // ── 주소 ─────────────────────────────────
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        text: carWash.roadAddress ?? carWash.address,
                      ),
                      if (carWash.phone != null) ...[
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          text: carWash.phone!,
                        ),
                      ],
                      if (carWash.openHours != null) ...[
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.access_time,
                          text: carWash.openHours!,
                        ),
                      ],
                      if (carWash.priceInfo != null) ...[
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.payments_outlined,
                          text: carWash.priceInfo!,
                        ),
                      ],
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // ── 편의시설 ──────────────────────────────
                      Text(
                        '편의시설',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (carWash.bayCount > 0)
                            _FacilityChip(
                              label: '베이 ${carWash.bayCount}개',
                              icon: Icons.garage_outlined,
                            ),
                          if (carWash.hasVacuum)
                            const _FacilityChip(
                              label: '청소기',
                              icon: Icons.cleaning_services,
                            ),
                          if (carWash.hasAirGun)
                            const _FacilityChip(
                              label: '에어건',
                              icon: Icons.air,
                            ),
                          if (carWash.hasMatWash)
                            const _FacilityChip(
                              label: '매트세척기',
                              icon: Icons.local_laundry_service,
                            ),
                          if (carWash.hasToilet)
                            const _FacilityChip(
                              label: '화장실',
                              icon: Icons.wc,
                            ),
                          if (carWash.hasWaiting)
                            const _FacilityChip(
                              label: '대기공간',
                              icon: Icons.weekend,
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── 광고 배너 ─────────────────────────────
                      const AdBanner(),
                      const SizedBox(height: 20),

                      // ── 리뷰 섹션 헤더 ────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '리뷰',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.reviewPath(id)),
                            child: const Text('리뷰 작성'),
                          ),
                        ],
                      ),
                      // TODO: 리뷰 목록 위젯 추가
                      const _ReviewPlaceholder(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? '운영중' : '운영종료',
        style: TextStyle(
          color: isActive ? Colors.green : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({required this.label, this.icon});
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null
          ? Icon(icon, size: 14, color: AppTheme.primary)
          : null,
      label: Text(label),
    );
  }
}

class _ReviewPlaceholder extends StatelessWidget {
  const _ReviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          '첫 번째 리뷰를 작성해보세요!',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}

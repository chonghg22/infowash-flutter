import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/car_wash.dart';

class CarWashCard extends StatelessWidget {
  const CarWashCard({
    super.key,
    required this.carWash,
  });

  final CarWash carWash;

  @override
  Widget build(BuildContext context) {
    final isActive = carWash.status == 'ACTIVE';
    final firstImage =
        carWash.images.isNotEmpty ? carWash.images.first : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── 썸네일 ──────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: firstImage != null
                    ? Image.network(
                        firstImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const _PlaceholderThumbnail(),
                      )
                    : const _PlaceholderThumbnail(),
              ),
            ),
            const SizedBox(width: 14),

            // ── 정보 영역 ────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름 + 상태
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          carWash.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(isActive: isActive),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 주소
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

                  // 거리 + 편의시설 태그
                  Row(
                    children: [
                      if (carWash.distanceM != null) ...[
                        Text(
                          _formatDistance(carWash.distanceM!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),

                  // 편의시설 태그
                  if (carWash.hasVacuum ||
                      carWash.hasAirGun ||
                      carWash.hasMatWash ||
                      carWash.bayCount > 0) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: [
                        if (carWash.bayCount > 0)
                          _MiniTag('베이 ${carWash.bayCount}개'),
                        if (carWash.hasVacuum) const _MiniTag('청소기'),
                        if (carWash.hasAirGun) const _MiniTag('에어건'),
                        if (carWash.hasMatWash) const _MiniTag('매트세척기'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double m) {
    if (m < 1000) return '${m.toInt()}m';
    return '${(m / 1000).toStringAsFixed(1)}km';
  }
}

class _PlaceholderThumbnail extends StatelessWidget {
  const _PlaceholderThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3F2FD),
      child: const Icon(Icons.local_car_wash, color: AppTheme.primary, size: 36),
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

class _MiniTag extends StatelessWidget {
  const _MiniTag(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

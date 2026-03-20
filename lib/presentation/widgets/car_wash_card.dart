import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/car_wash.dart';
import 'rating_bar.dart';

class CarWashCard extends StatelessWidget {
  const CarWashCard({
    super.key,
    required this.carWash,
    this.showDistance = false,
    this.distanceKm,
  });

  final CarWash carWash;
  final bool showDistance;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── 썸네일 ────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: carWash.thumbnailUrl != null
                    ? Image.network(
                        carWash.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _PlaceholderThumbnail(),
                      )
                    : _PlaceholderThumbnail(),
              ),
            ),
            const SizedBox(width: 14),

            // ── 정보 영역 ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름 + 영업 상태
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
                      _StatusBadge(isOpen: carWash.isOpen),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 주소
                  Text(
                    carWash.address,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // 별점 + 리뷰 수
                  Row(
                    children: [
                      ReadOnlyRatingBar(
                        rating: carWash.rating,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${carWash.rating.toStringAsFixed(1)} (${carWash.reviewCount})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (showDistance && distanceKm != null) ...[
                        const Spacer(),
                        Text(
                          _formatDistance(distanceKm!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // 편의시설 태그
                  if (carWash.hasDryer || carWash.hasVacuum || carWash.bayCount > 0) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: [
                        if (carWash.bayCount > 0)
                          _MiniTag('베이 ${carWash.bayCount}개'),
                        if (carWash.hasDryer)
                          const _MiniTag('건조기'),
                        if (carWash.hasVacuum)
                          const _MiniTag('청소기'),
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

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).toInt()}m';
    return '${km.toStringAsFixed(1)}km';
  }
}

class _PlaceholderThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3F2FD),
      child: const Icon(
        Icons.local_car_wash,
        color: AppTheme.primary,
        size: 36,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isOpen ? '영업중' : '영업종료',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isOpen ? Colors.green.shade700 : AppTheme.textSecondary,
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

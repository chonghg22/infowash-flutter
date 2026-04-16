import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/car_wash.dart';
import '../../../data/models/review.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/car_wash_provider.dart';
import '../../../providers/detail_provider.dart';
import '../../../providers/favorite_provider.dart';
import '../auth/login_screen.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  int _imageIndex = 0;

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchNaverMap(CarWash carWash) async {
    final naverMapUrl =
        'nmap://navigation?dlat=${carWash.lat}&dlng=${carWash.lng}'
        '&dname=${Uri.encodeComponent(carWash.name)}&appname=com.infowash.app';
    final uri = Uri.parse(naverMapUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(
        Uri.parse('market://details?id=com.nhn.android.nmap'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _toggleFavorite(CarWash carWash) async {
    final notifier = ref.read(favoriteProvider.notifier);
    if (notifier.isFavorite(widget.id)) {
      await notifier.removeFavorite(widget.id);
    } else {
      await notifier.addFavorite(carWash);
    }
  }

  Future<void> _openReview() async {
    if (!ref.read(isSignedInProvider)) {
      await showLoginBottomSheet(
        context,
        onLoginSuccess: () => context.push(AppRoutes.reviewPath(widget.id)),
      );
      return;
    }
    context.push(AppRoutes.reviewPath(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(carWashDetailProvider(widget.id));
    final reviewAsync = ref.watch(reviewListProvider(widget.id));
    final isFav = ref.watch(isFavoriteProvider(widget.id));

    return Scaffold(
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (carWash) {
          if (carWash == null) {
            return const Center(child: Text('세차장 정보를 찾을 수 없습니다.'));
          }

          return Stack(
            children: [
              // ── 스크롤 본문 ────────────────────────────────────────
              CustomScrollView(
                slivers: [
                  // ── SliverAppBar + 이미지 갤러리 ──────────────────
                  SliverAppBar(
                    expandedHeight: 260,
                    pinned: true,
                    actions: [
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () => _toggleFavorite(carWash),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: carWash.images.isEmpty
                          ? Container(
                              color: AppTheme.primaryLight,
                              child: const Icon(
                                Icons.local_car_wash,
                                size: 80,
                                color: Colors.white54,
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                PageView.builder(
                                  itemCount: carWash.images.length,
                                  onPageChanged: (i) =>
                                      setState(() => _imageIndex = i),
                                  itemBuilder: (context, i) => Image.network(
                                    carWash.images[i],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: AppTheme.primaryLight,
                                      child: const Icon(
                                        Icons.local_car_wash,
                                        size: 80,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                                if (carWash.images.length > 1)
                                  Positioned(
                                    bottom: 12,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${_imageIndex + 1}/${carWash.images.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),

                  // ── 본문 ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      // 하단 버튼 영역만큼 패딩
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── 이름 & 영업상태 ────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  carWash.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                              ),
                              _StatusBadge(
                                  isActive: carWash.status == 'ACTIVE'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),

                          // ── 기본 정보 ──────────────────────────────
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            text: carWash.roadAddress ?? carWash.address,
                          ),
                          if (carWash.phone != null) ...[
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _launchPhone(carWash.phone!),
                              child: _InfoRow(
                                icon: Icons.phone_outlined,
                                text: carWash.phone!,
                                textColor: AppTheme.primary,
                              ),
                            ),
                          ],
                          if (carWash.openHours != null) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.access_time,
                              text: carWash.openHours!,
                            ),
                          ],
                          if (carWash.bayCount > 0) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.garage_outlined,
                              text: '베이 ${carWash.bayCount}개',
                            ),
                          ],
                          if (carWash.priceInfo != null) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.payments_outlined,
                              text: carWash.priceInfo!,
                            ),
                          ],
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),

                          // ── 편의시설 아이콘 행 ─────────────────────
                          Text(
                            '편의시설',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _FacilityIcon(
                                icon: Icons.cleaning_services,
                                label: '진공청소기',
                                enabled: carWash.hasVacuum,
                              ),
                              _FacilityIcon(
                                icon: Icons.air,
                                label: '에어건',
                                enabled: carWash.hasAirGun,
                              ),
                              _FacilityIcon(
                                icon: Icons.local_laundry_service,
                                label: '매트세척기',
                                enabled: carWash.hasMatWash,
                              ),
                              _FacilityIcon(
                                icon: Icons.wc,
                                label: '화장실',
                                enabled: carWash.hasToilet,
                              ),
                              _FacilityIcon(
                                icon: Icons.weekend,
                                label: '대기공간',
                                enabled: carWash.hasWaiting,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),

                          // ── 리뷰 섹션 ──────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '리뷰',
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: _openReview,
                                child: const Text('리뷰 작성'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          reviewAsync.when(
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (reviews) {
                              if (reviews.isEmpty) {
                                return const Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: Text(
                                      '아직 리뷰가 없어요',
                                      style: TextStyle(
                                          color: AppTheme.textSecondary),
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: reviews
                                    .take(5)
                                    .map((r) => _ReviewTile(review: r))
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // ── 정보 수정 제보 ─────────────────────────
                          Center(
                            child: TextButton(
                              onPressed: () => context.push(
                                AppRoutes.report,
                                extra: {'carWashId': widget.id},
                              ),
                              child: const Text(
                                '정보 수정 제보',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── 하단 고정 버튼 ─────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchNaverMap(carWash),
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('길찾기'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openReview,
                          icon: const Icon(Icons.rate_review, size: 18),
                          label: const Text('리뷰 작성'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── 영업상태 배지 ──────────────────────────────────────────────────────────────
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
          color: isActive ? Colors.green.shade700 : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── 정보 행 ────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    this.textColor,
  });

  final IconData icon;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ── 편의시설 아이콘 ─────────────────────────────────────────────────────────────
class _FacilityIcon extends StatelessWidget {
  const _FacilityIcon({
    required this.icon,
    required this.label,
    required this.enabled,
  });

  final IconData icon;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppTheme.primary : Colors.grey.shade300;

    return Column(
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: enabled ? AppTheme.primary : AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── 리뷰 타일 ──────────────────────────────────────────────────────────────────
class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 별점
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < ((review.scoreClean + review.scoreFacility + review.scorePrice) / 3).round()
                        ? Icons.star
                        : Icons.star_border,
                    size: 14,
                    color: AppTheme.starColor,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                review.userNickname ?? '익명',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              if (review.createdAt != null)
                Text(
                  '${review.createdAt!.year}.${review.createdAt!.month.toString().padLeft(2, '0')}.${review.createdAt!.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review.content,
            style: const TextStyle(fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _ImageViewerScreen(
                          imageUrls: review.imageUrls,
                          initialIndex: index,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: review.imageUrls[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(),
        ],
      ),
    );
  }
}

// ── 이미지 전체화면 뷰어 ──────────────────────────────────────────────────────
class _ImageViewerScreen extends StatelessWidget {
  const _ImageViewerScreen({
    required this.imageUrls,
    required this.initialIndex,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, i) => PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(imageUrls[i]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}

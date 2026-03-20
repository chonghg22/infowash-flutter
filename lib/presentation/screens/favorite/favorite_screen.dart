import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/favorite_provider.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('즐겨찾기')),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 64, color: AppTheme.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    '즐겨찾기한 세차장이 없습니다.',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '세차장 상세 화면에서 ♥를 눌러 추가해보세요.',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cw = favorites[index];
              return Dismissible(
                key: ValueKey(cw.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.white, size: 28),
                ),
                onDismissed: (_) {
                  ref
                      .read(favoriteProvider.notifier)
                      .removeFavorite(cw.id);
                },
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: cw.images.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                cw.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.local_car_wash,
                                  color: AppTheme.primary,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.local_car_wash,
                              color: AppTheme.primary,
                            ),
                    ),
                    title: Text(
                      cw.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      cw.roadAddress ?? cw.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textSecondary,
                    ),
                    onTap: () => context.push(AppRoutes.detailPath(cw.id)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

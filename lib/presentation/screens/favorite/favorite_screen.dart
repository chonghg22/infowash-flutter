import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/models/favorite.dart';

// 즐겨찾기 목록 Provider
final favoriteListProvider = FutureProvider.autoDispose<List<Favorite>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final data = await Supabase.instance.client
      .from('favorites')
      .select('*, car_washes(id, name, address, rating, thumbnail_url)')
      .eq('user_id', user.id)
      .order('created_at', ascending: false);

  return (data as List<dynamic>)
      .map((e) => Favorite.fromJson(e as Map<String, dynamic>))
      .toList();
});

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignedIn = ref.watch(isSignedInProvider);
    final favoritesAsync = ref.watch(favoriteListProvider);

    if (!isSignedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('즐겨찾기')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border, size: 64, color: AppTheme.textSecondary),
              const SizedBox(height: 16),
              const Text(
                '로그인 후 즐겨찾기를 이용할 수 있습니다.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.login),
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('즐겨찾기')),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: AppTheme.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    '즐겨찾기한 세차장이 없습니다.',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '세차장 상세 화면에서 ♥를 눌러 추가해보세요.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(favoriteListProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final fav = favorites[index];
                final carWash = fav.carWash;
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: carWash?.thumbnailUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                carWash!.thumbnailUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.local_car_wash,
                              color: AppTheme.primary,
                            ),
                    ),
                    title: Text(
                      carWash?.name ?? '세차장',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      carWash?.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: AppTheme.starColor),
                        const SizedBox(width: 2),
                        Text(
                          carWash?.rating.toStringAsFixed(1) ?? '-',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                      ],
                    ),
                    onTap: () => context.push(
                      AppRoutes.detailPath(fav.carWashId),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
    );
  }
}

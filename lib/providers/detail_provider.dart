import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/review.dart';
import 'car_wash_provider.dart';
import 'favorite_provider.dart';

/// 리뷰 목록
final reviewListProvider =
    FutureProvider.autoDispose.family<List<Review>, String>((ref, id) {
  final repo = ref.watch(carWashRepositoryProvider);
  return repo.getReviews(id);
});

/// 즐겨찾기 상태 — favoriteProvider에서 파생
final isFavoriteProvider =
    Provider.autoDispose.family<bool, String>((ref, id) {
  final favorites = ref.watch(favoriteProvider).valueOrNull ?? [];
  return favorites.any((cw) => cw.id == id);
});

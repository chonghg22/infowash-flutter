import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/review.dart';
import 'car_wash_provider.dart';

/// 리뷰 목록
final reviewListProvider =
    FutureProvider.autoDispose.family<List<Review>, String>((ref, id) {
  final repo = ref.watch(carWashRepositoryProvider);
  return repo.getReviews(id);
});

/// 즐겨찾기 상태 (초기값 false, initState에서 실제 값으로 교체)
final isFavoriteProvider =
    StateProvider.autoDispose.family<bool, String>((ref, id) => false);
